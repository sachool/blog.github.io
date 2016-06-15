require 'rjb'
p Rjb::VERSION
Rjb::load
CharArrayReader = Rjb::import('java.io.CharArrayReader')
reader = CharArrayReader.new([48, 49, 50, 51, 52, 53])
loop do
  ch = reader.read
  break if ch < 0
  p ch
end
reader.close
