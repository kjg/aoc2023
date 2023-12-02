#!/usr/bin/env ruby

file = File.join(File.dirname(__FILE__), ARGV[0] || 'example2.txt')

DIGITS = {
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9
}

def digit(value)
  if value.length > 1
    return DIGITS[value].to_s
  end
  value
end

total = 0
File.open(file).each do |l|
  dreg = DIGITS.keys.join("|")
  matches = l.scan(/(?=(\d|#{dreg}))/).flatten

  number = digit(matches[0]) << digit(matches[-1])
  total += number.to_i
end

puts total
