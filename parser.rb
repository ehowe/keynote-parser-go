require "pry"
require "snappy"

require_relative "ruby_protobuf/TSPArchiveMessages_pb"

ValueError = Class.new(RuntimeError)

class IWAFile
  attr_reader :filename, :chunks

  def initialize(filename:)
    @filename = filename
    @chunks   = []
  end

  def parse
    contents = File.open(filename, "rb").read

    IWACompressedChunk.new(contents: contents).parse do |chunk|
      chunks << Snappy.inflate(chunk)

      IWAArchiveSegment.new(data: chunk).parse
    end
  end
end

class IWACompressedChunk
  attr_reader :contents

  def initialize(contents:)
    @archives = []
    @contents = contents
  end

  def parse(&block)
    data = contents

    while data
      header = contents[0..3]
      first_byte = header[0]

      first_byte = first_byte.ord unless first_byte.is_a?(Integer)

      raise ValueError.new("IWA chunk does not start with 0x00! Found #{first_byte}") unless first_byte == 0x00

      appended = header[1..-1] + "\x00"
      unpacked = appended.unpack("I!<") # This is not returning the right value
      length   = unpacked[0]
      chunk    = data[4..(4 + length)]
      data     = data[(4 + length)..-1]

      block.call(chunk)
    end
  end
end

class IWAArchiveSegment
  attr_reader :archive, :data

  def initialize(data:)
    @data = data
  end

  #def get_archive_info_and_remainder
    #msg_len, new_pos = _DecodeVarint32(buf, 0)
    #n = new_pos
    #msg_buf = buf[n : n + msg_len]
    #n += msg_len
    #return ArchiveInfo.FromString(msg_buf), buf[n:]
  #end

  def parse
  end
end

IWAFile.new(filename: "./extracted/Index/Metadata.iwa").parse
