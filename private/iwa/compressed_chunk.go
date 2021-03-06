package iwa

import (
	"encoding/binary"
	"errors"

	"github.com/golang/snappy"
	"google.golang.org/protobuf/proto"
)

type CompressedChunk struct {
	Objects  []proto.Message
	Contents []byte
}

func (c CompressedChunk) Parse() []proto.Message {
	data := c.Contents
	decoded := make([]byte, 0, len(data)+1)

	for len(data) > 0 {
		header := data[:4]
		first_byte := header[0]

		if first_byte != 0x00 {
			panic(errors.New("IWA chunk does not start with 0x00"))
		}

		appended := []byte{}
		appended = append(appended, header[1:]...)
		appended = append(appended, 0x00, 0x00, 0x00, 0x00, 0x00)

		length := binary.LittleEndian.Uint32(appended)

		chunk := data[4 : 4+length]

		decodedChunk, err := snappy.Decode(nil, chunk)

		if err != nil {
			panic(err)
		}

		decoded = append(decoded, decodedChunk...)

		data = data[4+length:]
	}

	archiveSegment := ArchiveSegment{Data: decoded}

	objects := archiveSegment.Parse()

	c.Objects = append(c.Objects, objects...)

	return c.Objects
}
