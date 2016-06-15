begin
  require 'rjb'
rescue LoadError 
  require 'rubygems' 
  require 'rjb'
end
require 'test/unit'
require 'fileutils'

FileUtils.rm_f 'jp/co/infoseek/hp/arton/rjb/Base.class'
FileUtils.rm_f 'jp/co/infoseek/hp/arton/rjb/ExtBase.class'

puts "start RJB(#{Rjb::VERSION}) test"
class TestRjb < Test::Unit::TestCase
  include Rjb
  def setup
    Rjb::load('.')
    Rjb::add_jar(File.expand_path('rjbtest.jar'))
    Rjb::primitive_conversion = false

    @jString = import('java.lang.String')
    @jInteger = import('java.lang.Integer')
    @jShort = import('java.lang.Short')
    @jDouble = import('java.lang.Double')
    @jFloat = import('java.lang.Float')
    @jBoolean = import('java.lang.Boolean')
    @jByte = import('java.lang.Byte')
    @jLong = import('java.lang.Long')
    @jChar = import('java.lang.Character')
  end

  SJIS_STR = "\x8a\xbf\x8e\x9a\x83\x65\x83\x4c\x83\x58\x83\x67"
  EUCJP_STR = "\xb4\xc1\xbb\xfa\xa5\xc6\xa5\xad\xa5\xb9\xa5\xc8"
  UTF8_STR = "\xE6\xBC\xA2\xE5\xAD\x97\xE3\x83\x86\xE3\x82\xAD\xE3\x82\xB9\xE3\x83\x88"
  def test_jsconv
    sys = import('java.lang.System')
    encoding = sys.property('file.encoding')
    s = @jString.new(SJIS_STR.force_encoding Encoding::SHIFT_JIS)
    e = @jString.new(EUCJP_STR.force_encoding Encoding::EUC_JP)
    u = @jString.new(UTF8_STR.force_encoding Encoding::UTF_8)
    if encoding == 'MS932'
      s1 = @jString.new(SJIS_STR.bytes)
    elsif encoding.upcase == 'EUC-JP'
      s1 = @jString.new(EUCJP_STR.bytes)
    elsif encoding.upcase == 'UTF-8'
      s1 = @jString.new(UTF8_STR.bytes)
    else
      skip 'no checkable encoding'
    end
    assert_equal s1.toString, s.toString
    assert_equal s1.toString, e.toString
    assert_equal s1.toString, u.toString
  end
end
