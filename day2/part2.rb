#!/usr/bin/env ruby

file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

total = 0
File.open(file).each_with_index do |line, index|
  id = index + 1
  game = line.split(": ")[1]
  pulls = game.split("; ")
  max = {
    "red" => 0,
    "green" => 0,
    "blue" => 0
  }
  pulls.each do |pull|
    count_colors = pull.split(", ")
    count_colors.each do |count_color|
      count = count_color.match(/\d+/)[0].to_i
      color = count_color.match(/[a-z]+/)[0]
      puts [count, color].inspect

      if count > max[color]
        max[color] = count
      end
    end
    
  end
  puts max.inspect
  puts max.values.reduce(:*)
  total += max.values.reduce(:*)
end
puts total
