#!/usr/bin/env ruby

file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

LIMITS = {
  "red"   => 12,
  "green" => 13,
  "blue"  => 14,
}

total = 0
File.open(file).each_with_index do |line, index|
  possible = true
  id = index + 1
  game = line.split(": ")[1]
  pulls = game.split("; ")
  pulls.each do |pull|
    count_colors = pull.split(", ")
    count_colors.each do |count_color|
      count = count_color.match(/\d+/)[0].to_i
      color = count_color.match(/[a-z]+/)[0]
      puts [count, color].inspect
      if count > LIMITS[color]
        possible = false
      end
    end
  end
  total = total + id if possible
end
puts total
