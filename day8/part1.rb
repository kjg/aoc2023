#!/usr/bin/env ruby

file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

@nodes = {}
lines = File.readlines(file, chomp: true)
@steps = lines[0].each_char.map { |char| if char == "L"; 0; else 1; end; }

lines[2..-1].each do |line|
  index, *nodes = line.scan(/\w+/)
  @nodes[index] = nodes
end

step_count = 0
finished = false
destination = "AAA"
until finished do
  index = step_count % @steps.length
  step_count +=1

  destination = @nodes[destination][@steps[index]]
  finished = true if destination == "ZZZ"
end

puts step_count
