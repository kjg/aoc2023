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
  
  diff = 0
  sequences.reverse.each do |sequence|
    diff = sequence[0] - diff
    sequence.unshift diff
  end
  
  sequences
end

puts extrapolations.inspect
puts extrapolations.map { |e| e[0][0] }.sum
