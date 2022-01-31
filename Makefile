ifeq ($(shell uname -o),Darwin)
	FILENAME = libkeynoteparser.dylib
else
	FILENAME = libkeynoteparser.so
endif

build:
	go build -buildmode c-shared -o $(FILENAME) keynote_parser.go

.PHONY: build
