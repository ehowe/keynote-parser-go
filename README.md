## Introduction

This is a project written in go that uses the groundwork laid out by github.com/psobot/keynote-parser. The protobuf source files are extracted directly from that project.

The goal is to have a library that can be utilized by Ruby through FFI.

This is a rough proof-of-concept right now.

## What doesn't work

The export works and attaching the function through FFI returns a JSON object that can be consumed. However, it does not contain all of the attributes that it does through the Python serializer. This seems like it is really close.
