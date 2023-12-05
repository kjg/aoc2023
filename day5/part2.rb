#!/usr/bin/env ruby

file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

MAPPING_TYPES = %w{seed-to-soil soil-to-fertilizer fertilizer-to-water water-to-light light-to-temperature temperature-to-humidity humidity-to-location}
MAPPING_RULES = {}
SEEDS = []

def add_rule_to_mapping(mapping, dest_start, source_start, length)
  MAPPING_RULES[mapping] << { 
    source_range: (source_start...source_start+length),
    offset: dest_start-source_start
  }
end


mapping_to_process = ""
File.open(file).each do |line|
  case line
  when /seeds/
    line.scan(/\d+/).map(&:to_i).each_slice(2) do |loc, length|
      SEEDS << (loc...loc+length)
    end
  when /map/
    mapping_to_process = line.match(/[\w\-]+/)[0]
    MAPPING_RULES[mapping_to_process] = []
  when /\d/
    add_rule_to_mapping(mapping_to_process, *line.scan(/\d+/).map(&:to_i))
  end
end

puts SEEDS.inspect
puts MAPPING_RULES.inspect

ranges = SEEDS
MAPPING_RULES.each do |type, rules|
  ordered_rules = rules.sort { |a, b| a[:source_range].min <=> b[:source_range].min }
  puts "Processing: #{type}"
  new_ranges = []
  ranges.each do |range|
    rules = ordered_rules.dup
    rule = rules.shift
    while range.size > 0
      case
      when rule.nil?
        new_ranges << range
        range = (0...0)
      when range.min < rule[:source_range].min
        new_ranges << (range.min...rule[:source_range].min)
        range = (rule[:source_range].min..range.max)
      when rule[:source_range].cover?(range.min)
        new_range_start = range.min + rule[:offset]
        
        if rule[:source_range].cover? range.max
          new_range_end = range.max + rule[:offset]
          range = (0...0)
        else
          new_range_end = rule[:source_range].max + rule[:offset]
          range = ((rule[:source_range].max+1)..range.max)
          rule = rules.shift
        end
        
        new_ranges << (new_range_start..new_range_end)
      else
        rule = rules.shift
      end
    end
  end
  ranges = new_ranges
  puts ranges.inspect
end

puts ranges.sort { |a,b| a.min <=> b.min }.first.min
