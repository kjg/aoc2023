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

@loop = [@start].concat(@connections[@start])
next_tiles = @connections[@start]
current_tiles = [@start, @start]

while next_tiles.length.positive? do
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
    @loop << next_tile1 << next_tile2
    [next_tile1, next_tile2]
  end
end

puts @loop

inside_loop_count = 0

lines.each_with_index do |line, row|
  puts "row #{row}"
  line.each_char.with_index do |char, col|
    print "."
    next if @loop.include?({row:, col:})
    next if row == 0 || col == 0
    next if row == lines.length - 1
    next if col == line.length - 1
    
    if line.length - col > col
      row_start = 0
      row_end = col
    else
      row_start = col + 1
      row_end = line.length
    end

    num_ups = 0
    num_downs = 0
    blah = (row_start..row_end).map do |i|
      current_space = {row: row, col: i}
      next unless @loop.include? current_space
      @connections[current_space].each do |connect|
        if connect[:row] > row
          num_ups += 1
        end
        if connect[:row] < row
          num_downs += 1
        end
      end
    end
    if [num_ups, num_downs].any?(&:odd?)
      inside_loop_count += 1
    end
  end
end

puts inside_loop_count.inspect
