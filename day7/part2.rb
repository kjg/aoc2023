#!/usr/bin/env ruby

file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

HAND_TYPES = [:high_card, :one_pair, :two_pair, :three_of_a_kind, :full_house, :four_of_a_kind, :five_of_a_kind]
CARD_ORDER = %w{J 2 3 4 5 6 7 8 9 T Q K A}

BID_HANDS = []

def hand_type(hand)
  counts = hand.chars.tally
  
  num_jokers = counts["J"] || 0
  counts.delete("J")
  
  case
  when counts.values.include?(5) ||
    num_jokers == 5 ||
    num_jokers == 4 || 
    (num_jokers == 3 && counts.values.include?(2)) ||
    (num_jokers == 2 && counts.values.include?(3)) ||
    (num_jokers == 1 && counts.values.include?(4))
    return :five_of_a_kind
  when counts.values.include?(4) ||
    (num_jokers == 3 && counts.values.include?(1)) ||
    (num_jokers == 2 && counts.values.include?(2)) ||
    (num_jokers == 1 && counts.values.include?(3))
    return :four_of_a_kind
  when counts.values.include?(3) && counts.values.include?(2) ||
    (num_jokers == 1 && counts.values.tally[2] == 2)
    return :full_house
  when counts.values.include?(3) ||
    (num_jokers == 2 && counts.values.include?(1)) ||
    (num_jokers == 1 && counts.values.include?(2))
    return :three_of_a_kind
  when counts.values.tally[2] == 2
    return :two_pair
  when counts.values.include?(2) || num_jokers == 1
    return :one_pair
  else
    return :high_card
  end
end

File.open(file).each do |line|
  hand, bid = line.split(" ")
  type = hand_type(hand)
  BID_HANDS << {hand: hand, type: type, bid: bid.to_i}
end

# puts BID_HANDS.inspect

sorted = BID_HANDS.sort do |a,b|
  if a[:type] != b[:type]
    HAND_TYPES.find_index(a[:type]) <=> HAND_TYPES.find_index(b[:type])
  else
    hand_a = a[:hand].chars
    hand_b = b[:hand].chars
    
    hand_a.each_with_index do |card_a, index|
      if card_a != hand_b[index]
        break CARD_ORDER.find_index(card_a) <=> CARD_ORDER.find_index(hand_b[index])
      end
    end || 0
  end
end

puts sorted.inspect
puts sorted.each_with_index.inject(0) { |memo, (hand,index)| memo + (hand[:bid] * (index + 1)) }
