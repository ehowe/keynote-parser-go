require "ffi"
require "oj"

module ExtractKeynote
  extend FFI::Library

  if FFI::Platform::IS_MAC
    ffi_lib File.expand_path("./libkeynoteparser.dylib")
  else
    ffi_lib File.expand_path("./libkeynoteparser.so")
  end

  attach_function :_parse, :parse, [:string], :string

  module_function

  def parse(filename)
    Oj.load(_parse(filename))
  end
end
