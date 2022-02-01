## Introduction

This is a project written in go that uses the groundwork laid out by github.com/psobot/keynote-parser. The protobuf source files are extracted directly from that project.

The goal is to have a library that can be utilized by Ruby through FFI.

This is a rough proof-of-concept right now.

## What doesn't work

Some attributes fail to deserialize in Go due to not having the correct UTF-8 encoding. These seem to all be styling related so it's not a blocker at this time.

## Building

`make`

## Testing with FFI

To test the FFI implementation, just load the included `test_ruby_ffi` in an IRB session and call `ExtractKeynote.parse("path/to/file.key")`
