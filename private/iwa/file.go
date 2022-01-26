//go:build linux || darwin
// +build linux darwin

package iwa

type File struct {
	Contents []byte
	Chunks   []CompressedChunk
}

func (f File) Parse() {
	contents := f.Contents

	compressedChunk := CompressedChunk{Contents: contents}
	var decodedChunk CompressedChunk
	decodedChunk = compressedChunk.Parse()

	f.Chunks = append(f.Chunks, decodedChunk)
}
