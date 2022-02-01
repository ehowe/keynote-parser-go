package iwa

import (
	kpb "kpb"

	"google.golang.org/protobuf/encoding/protowire"
	"google.golang.org/protobuf/proto"
)

type ArchiveSegment struct {
	Data    []byte
	Objects []proto.Message
}

func (s ArchiveSegment) Parse() []proto.Message {
	buf := s.Data

	for len(buf) > 0 {
		var archiveInfo *kpb.ArchiveInfo
		archiveInfo, buf = s.GetArchiveInfoAndRemainder(buf)

		for _, messageInfo := range archiveInfo.MessageInfos {
			n := 0
			messageType := *messageInfo.Type
			messageLength := *messageInfo.Length

			messagePayload := buf[n : n+int(messageLength)]

			payloadObj := kpb.GetProto(messageType, messagePayload)

			s.Objects = append(s.Objects, payloadObj)
			n += int(messageLength)

			buf = buf[n:]
		}
	}

	return s.Objects
}

func (s ArchiveSegment) GetArchiveInfoAndRemainder(buf []byte) (*kpb.ArchiveInfo, []byte) {
	msgLen, newPos := protowire.ConsumeVarint(buf)
	n := uint64(newPos)
	msgBuf := buf[n : n+msgLen]
	info := &kpb.ArchiveInfo{}
	err := proto.Unmarshal(msgBuf, info)

	if err != nil {
		panic(err)
	}

	n += msgLen

	return info, buf[n:]
}
