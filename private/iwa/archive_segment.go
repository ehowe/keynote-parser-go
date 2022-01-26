package iwa

import (
	kpb "kpb"

	"google.golang.org/protobuf/encoding/protowire"
	"google.golang.org/protobuf/proto"
)

type ArchiveSegment struct {
	Data    []byte
	Objects []interface{}
}

func (s ArchiveSegment) Parse() {
	archiveInfo, payload := s.GetArchiveInfoAndRemainder()

	n := 0
	for _, messageInfo := range archiveInfo.MessageInfos {
		messageType := *messageInfo.Type
		messageLength := *messageInfo.Length

		messagePayload := payload[n : n+int(messageLength)]

		payloadObj := kpb.GetProto(messageType, messagePayload)

		s.Objects = append(s.Objects, payloadObj)
		n += int(messageLength)
	}
}

func (s ArchiveSegment) GetArchiveInfoAndRemainder() (*kpb.ArchiveInfo, []byte) {
	msgLen, newPos := protowire.ConsumeVarint(s.Data)
	n := uint64(newPos)
	msgBuf := s.Data[n : n+msgLen]
	info := &kpb.ArchiveInfo{}
	err := proto.Unmarshal(msgBuf, info)

	if err != nil {
		panic(err)
	}

	n += msgLen

	return info, s.Data[n:]
}
