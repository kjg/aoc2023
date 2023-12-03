#!/usr/bin/env ruby

require 'colorize'

file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

Coord = Struct.new(:row, :col)
DigitWithCoord = Struct.new(:digit, :coordinate)

class Part2
  def initialize(file)
    @file = file
    @grid = []
    @coord_to_number = {}
  end
  
  def numbers_touching(coordinate)
    numbers = []
    for row in (coordinate.row-1..coordinate.row+1) do
      next if row < 0
      for col in (coordinate.col-1..coordinate.col+1) do
        next if col < 0
        number_coord = Coord.new(row:, col:)
        numbers << @coord_to_number[number_coord] if @coord_to_number[number_coord]
      end
    end
    numbers
  end
  
  def process_number(number)
    part_num = ""
    is_a_part = false
    part_num = number.map(&:digit).join.to_i
  
    number.each do |digit|
      @coord_to_number[digit.coordinate] = part_num
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
        end
      end
    end

    gears = []
    @grid.each_with_index do |row, row_num|
      row.each_with_index do |char, char_num|
        if char == "*"
          numbers = numbers_touching(Coord.new(row: row_num, col: char_num)).uniq
          if numbers.length > 1
            gears << numbers.inject(:*)
          end
        end
      end
    end
    puts gears.sum
  end
end

Part2.new(file).run
