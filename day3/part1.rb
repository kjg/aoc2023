#!/usr/bin/env ruby

require 'colorize'

file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

Coord = Struct.new(:row, :col)
DigitWithCoord = Struct.new(:digit, :coordinate)

class Part1
  def initialize(file)
    @file = file
    @grid = []
    @parts = []
  end

  def coord_touches_symbol(coordinate)
    for row in (coordinate.row-1..coordinate.row+1) do
      next if row < 0
      for col in (coordinate.col-1..coordinate.col+1) do
        next if col < 0
        if @grid[row] && @grid[row][col]
          char = @grid[row][col]
          if char.match?(/[^\d\.]/)
            return true
          end
        end
      end
    end
    false
  end
  
  def process_number(number)
    part_num = ""
    is_a_part = false
    number.each do |digit|
      part_num << digit.digit
      is_a_part = true if coord_touches_symbol(digit.coordinate)
    end
    
    if is_a_part
      @parts << part_num.to_i
      print part_num.green
    else
      print part_num
    end
  end

  def run
    File.open(@file).each do |line|
      row = []
      line.chars.each do |char|
        next if char == "\n"
        row << char
      end
      
      @grid << row
    end

    @grid.each_with_index do |row, row_num|
      current_number = []
      row.each_with_index do |char, char_num|
        case char
        when /\d/
          current_number << DigitWithCoord.new(
            digit: char,
            coordinate: Coord.new(row: row_num, col: char_num)
          )
          if char_num == row.length - 1
            process_number(current_number)
          end
        else
          process_number(current_number) if current_number.length > 0
          current_number = []
          print char
        end
      end
      print "\n"
    end
    
    puts @parts.inspect
    puts @parts.sum
  end
end

Part1.new(file).run
