#!/usr/bin/env ruby

file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

copies = []
File.open(file).each_with_index do |line, index|
  copies[index] = (copies[index] || 0) + 1
  
  numbers_sets = line.split(":")[1]
  winner_set, have_set = numbers_sets.split("|")
  winners = winner_set.scan(/\d+/)
  haves = have_set.scan(/\d+/)
  
  matches = winners & haves
  wins = matches.count
  
  copies[index].times do
    (index+1..index+wins).each do |copy|
      copies[copy] = (copies[copy] || 0) + 1
    end
  end
end
puts copies.sum
