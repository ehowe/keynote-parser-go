module keynote_parser

go 1.17

replace iwa v0.0.0 => ./private/iwa

replace kpb v0.0.0 => ./private/iwa/kpb

require (
	google.golang.org/protobuf v1.27.1
	iwa v0.0.0
)

require (
	github.com/golang/snappy v0.0.4 // indirect
	kpb v0.0.0 // indirect
)
