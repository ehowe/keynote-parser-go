build:
	go build -buildmode c-shared -o libkeynoteparser.so keynote_parser.go

.PHONY: build
