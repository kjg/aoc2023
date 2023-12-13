file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

lines = File.readlines(file, chomp: true)


def arrangment_possible(springs, counts)
  spring_counts = springs.scan(/#+/).map(&:length)
  spring_counts == counts
end

all_possibilities = []
lines.each do |line|
  conditions, lengths = line.split(" ")
  lengths = lengths.split(",").map(&:to_i)

  arrangments = []
  
  conditions.each_char do |char|
    if arrangments.empty?
      if char == "." || char == "?"
        arrangments << "."
      end
      if char == "#" || char == "?"
        arrangments << "#"
      end
    else
      if char == "." || char == "#"
        arrangments.each do |arr|
          arr << char
        end
      end
      
      if char == "?"
        arrangments.dup.each do |arr|
          new_arr = arr.dup
          arr << "."
          new_arr << "#"
          arrangments << new_arr
        end
      end
    end
  end
  

  possible_arrangements = arrangments.inject(0) do |possible, arr|
    if arrangment_possible(arr, lengths)
      possible + 1
    else
      possible
    end
  end
  puts possible_arrangements
  all_possibilities << possible_arrangements
end

puts all_possibilities.sum
