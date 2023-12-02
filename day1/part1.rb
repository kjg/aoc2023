#!/usr/bin/env ruby

file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

total = 0
File.open(file).each do |l|
  number = l.match(/\d/)[0] << l.reverse.match(/\d/)[0]
  total += number.to_i
end
puts total
