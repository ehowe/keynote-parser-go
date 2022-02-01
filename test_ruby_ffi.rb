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
  attach_function :parseSingleIwa, [:string, :string], :string

  module_function

  def parse(filename)
    Oj.load(_parse(filename))
  end

  def parse_single_iwa(filename, iwa_path)
    Oj.load(parseSingleIwa(filename, iwa_path))
  end
end
