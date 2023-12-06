#!/usr/bin/env ruby

file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

File.open(file).each do |line|
  case line
  when /Time/
    TIME = line.scan(/\d+/).join.to_i
  when /Distance/
    DISTANCE = line.scan(/\d+/).join.to_i
  end
end

totals = []
(1..TIME).each do |hold|
  time_left = TIME-hold
  distance = time_left * hold
  totals << distance
end
  
puts totals.select { |d| d > DISTANCE }.count
