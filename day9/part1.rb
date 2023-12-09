#!/usr/bin/env ruby

file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')
lines = File.readlines(file, chomp: true)

extrapolations = lines.map do |line|
  sequence = line.split(" ").map(&:to_i)
  sequences = [sequence]

  until sequence.all?(&:zero?)
    sequence = (1...sequence.length).map do |index|
      sequence[index] - sequence[index-1]
    end
    sequences << sequence
  end
  
  add = 0
  sequences.reverse.each do |sequence|
    add = sequence[-1] + add
    sequence << add
  end
  
  sequences
end

puts extrapolations.inspect
puts extrapolations.map { |e| e[0][-1] }.sum
