require "ffi"
require "oj"

module ExtractKeynote
  extend FFI::Library

  ffi_lib File.expand_path("./libkeynoteparser.so")

  attach_function :_parse, :parse, [:string], :string

  module_function

  def parse(filename)
    Oj.load(_parse(filename))
  end
end
