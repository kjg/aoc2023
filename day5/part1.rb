#!/usr/bin/env ruby

file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

MAPPING_TYPES = %w{seed-to-soil soil-to-fertilizer fertilizer-to-water water-to-light light-to-temperature temperature-to-humidity humidity-to-location}
MAPPING_RULES = {}

# MAPPING_RULES = MAPPING_TYPES.inject({}) do |mappings, type|
#   mappings[type] = Hash.new { |hash,key| key }
#   mappings
# end

def add_rule_to_mapping(mapping, dest_start, source_start, length)
  MAPPING_RULES[mapping] << { source_start:, dest_start:, length: }
end


mapping_to_process = ""
File.open(file).each do |line|
  case line
  when /seeds/
    SEEDS = line.scan(/\d+/).map(&:to_i)
  when /map/
    mapping_to_process = line.match(/[\w\-]+/)[0]
    MAPPING_RULES[mapping_to_process] = []
  when /\d/
    add_rule_to_mapping(mapping_to_process, *line.scan(/\d+/).map(&:to_i))
  end
end

puts MAPPING_RULES.inspect

MAPPINGS = MAPPING_RULES.inject({}) do |mapping, (type, rules)|
  mapping[type] = Hash.new do |hash, key|
    dest = key
    rules.each do |rule|
      if key >= rule[:source_start] && key < (rule[:source_start] + rule[:length])
        dest= rule[:dest_start] + (key-rule[:source_start])
      end
    end
    dest
  end
  mapping
end

seed_to_location = SEEDS.map do |seed|
  puts "seed: #{seed}"
  key = seed
  MAPPING_TYPES.each do |type|
    key = MAPPINGS[type][key]
    puts "#{type.split("-")[-1]}: #{key}"
  end
  key
end

puts seed_to_location.inspect
puts seed_to_location.min
