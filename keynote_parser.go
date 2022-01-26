package main

/*
#include <stdlib.h>
*/
import "C"

import (
	"archive/zip"
	"bytes"
	"encoding/json"
	"io/ioutil"
	"log"
	"regexp"

	"fmt"
	iwa "iwa"
)

type UncompressedFile struct {
	Filename string
	Contents []byte
}

type ExtractedFile struct {
	Filename string
	Contents iwa.File
}

type Keynote struct {
	FilePath          string
	UncompressedFiles []UncompressedFile
	ExtractedFiles    []ExtractedFile
}

func main() {}

//export parse
func parse(p *C.char) []byte {
	fmt.Println(C.GoString(p))
	filePath := C.GoString(p)
	keynoteFile := Keynote{
		FilePath: filePath,
	}

	keynoteFile.Extract()

	regexpString := ".iwa$"

	nameRegex, _ := regexp.Compile(regexpString)

	for _, uncompressedFile := range keynoteFile.UncompressedFiles {
		if nameRegex.MatchString(uncompressedFile.Filename) {
			file := iwa.File{Contents: uncompressedFile.Contents}

			file.Parse()

			extractedFile := ExtractedFile{
				Filename: uncompressedFile.Filename,
				Contents: file,
			}

			keynoteFile.ExtractedFiles = append(keynoteFile.ExtractedFiles, extractedFile)
		}
	}

	jsonKeynote, err := json.Marshal(keynoteFile)

	if err != nil {
		panic(err)
	}

	return jsonKeynote
}

func (key *Keynote) Extract() {
	file, err := ioutil.ReadFile(key.FilePath)

	if err != nil {
		panic(err)
	}

	reader := bytes.NewReader(file)
	zipReader, err := zip.NewReader(reader, int64(len(file)))

	if err != nil {
		panic(err)
	}

	for _, zipFile := range zipReader.File {
		unzippedFileBytes, err := readZipFile(zipFile)
		if err != nil {
			log.Println(err)
			continue
		}

		uncompressedFile := UncompressedFile{
			Filename: zipFile.Name,
			Contents: unzippedFileBytes,
		}

		key.UncompressedFiles = append(key.UncompressedFiles, uncompressedFile)
	}
}

func readZipFile(zf *zip.File) ([]byte, error) {
	f, err := zf.Open()
	if err != nil {
		return nil, err
	}
	defer f.Close()
	return ioutil.ReadAll(f)
}
