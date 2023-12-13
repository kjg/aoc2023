#!/usr/bin/env ruby

file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

@connections = {}
lines = File.readlines(file, chomp: true)

lines.each_with_index do |line, row|
  line.each_char.with_index do |char, col|
    @connections[{row:, col:}] = 
    case char
    when "|"
      [{row: row-1, col: }, {row: row+1, col:}]
    when "-"
      [{row: , col: col-1 }, {row:, col: col + 1}]
    when "L"
      [{row: row-1, col: }, {row:, col: col + 1}]
    when "J"
      [{row: row-1, col: }, {row:, col: col - 1}]
    when "7"
      [{row:, col: col-1}, {row: row + 1, col:}]
    when "F"
      [{row:, col: col + 1}, {row: row + 1, col:}]
    when "."
      nil
    when "S"
      @start = {row:, col:}
      []
    end
  end
end

(-1..1).each do |row_offset|
  (-1..1).each do |col_offset|
    next if row_offset.zero? && col_offset.zero?
    index = {row: @start[:row] + row_offset, col: @start[:col] + col_offset}
    if @connections[index]&.include? @start
      @connections[@start] << index
    end
  end
end

@steps = 0
next_tiles = @connections[@start]
current_tiles = [@start, @start]

while next_tiles.length.positive? do
  @steps += 1
  last_tiles = current_tiles
  current_tiles = next_tiles
  
  next_tile1 = @connections[current_tiles[0]].reject { |t| last_tiles.include? t}.first
  next_tile2 = @connections[current_tiles[1]].reject { |t| last_tiles.include? t}.first
  next_tiles = case
  when current_tiles.include?(next_tile1) || current_tiles.include?(next_tile2)
    []
  when current_tiles[0] == current_tiles[1]
    []
  else
    [next_tile1, next_tile2]
  end
end

puts @steps
