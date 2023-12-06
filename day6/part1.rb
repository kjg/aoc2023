#!/usr/bin/env ruby

file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

TIMES = []
DISTANCES = []

File.open(file).each do |line|
  case line
  when /Time/
    TIMES = line.scan(/\d+/).map(&:to_i)
  when /Distance/
    DISTANCES = line.scan(/\d+/).map(&:to_i)
  end
end

winning_ways = []

TIMES.each_with_index do |time, index|
  totals = []
  (1..time).each do |hold|
    time_left = time-hold
    distance = time_left * hold
    totals << distance
  end
  
  winning_ways << totals.select { |d| d > DISTANCES[index] }.count
end

puts winning_ways.reduce(:*)
