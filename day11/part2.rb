#!/usr/bin/env ruby

file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

lines = File.readlines(file, chomp: true)

empty_rows = (0...lines.length-1).to_a
empty_cols = (0...lines.first.length).to_a

@stars = []

lines.each_with_index do |line, row|
  line.each_char.with_index do |char, col|
    if char == "#"
      empty_cols.delete(col)
      empty_rows.delete(row)
      @stars << {row:, col:}
    end
  end
end

puts @stars.inspect
puts empty_rows.inspect
puts empty_cols.inspect

distances = []
@stars.each_with_index do |star1, index|
  @stars[index+1..-1].each do |star2|
    num_rows = (star1[:row] - star2[:row]).abs
    num_cols = (star1[:col] - star2[:col]).abs
    
    rows = [star1[:row], star2[:row]]
    cols = [star1[:col], star2[:col]]
    (rows.min+1...rows.max).each do |row|
      if empty_rows.include?(row)
        num_rows += 999_999
      end
    end
    
    (cols.min+1...cols.max).each do |col|
      if empty_cols.include?(col)
        num_cols += 999_999
      end
    end
    
    distances << [num_rows, num_cols].sum
  end
end

puts distances.sum
