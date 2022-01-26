require "ffi"

module ExtractKeynote
  extend FFI::Library

  ffi_lib "keynoteparser"

  attach_function :parse, [:string], :pointer
end
