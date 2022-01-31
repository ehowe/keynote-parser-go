//go:build linux || darwin
// +build linux darwin

package iwa

import (
	"google.golang.org/protobuf/proto"
)

type File struct {
	Contents []byte
	Objects  []proto.Message
}

func (f File) Parse() []proto.Message {
	contents := f.Contents

	compressedChunk := CompressedChunk{Contents: contents}
	objects := compressedChunk.Parse()

	f.Objects = append(f.Objects, objects...)

	return objects
}
