## Introduction

This is a project written in go that uses the groundwork laid out by github.com/psobot/keynote-parser. The protobuf source files are extracted directly from that project.

The goal is to have a library that can be utilized by Ruby through FFI.

This is a rough proof-of-concept right now.

## What doesn't work

The export from Go to C for FFI is not right yet. It's probably close, but exporting a []byte from Go to C doesn't work. When the return type of the function is []byte, the function doesn't even correctly receive its input.
