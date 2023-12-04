#!/usr/bin/env ruby

file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

total = 0
File.open(file).each do |line|
  numbers_sets = line.split(":")[1]
  winner_set, have_set = numbers_sets.split("|")
  winners = winner_set.scan(/\d+/)
  haves = have_set.scan(/\d+/)
  
  matches = winners & haves
  if matches.count > 0
    total += 2 ** ( matches.count - 1)
  end
end
puts total
