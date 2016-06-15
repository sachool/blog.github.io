require 'rjb'
p Rjb::VERSION
Rjb::load
JString = Rjb::import('java.lang.String')
CharArrayReader = Rjb::import('java.io.CharArrayReader')
reader = CharArrayReader.new([48, 49, 50, 51, 52, 53])
buffer = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
p buffer
len = reader.read(buffer, 0, buffer.length)
p len
p buffer
reader.close
