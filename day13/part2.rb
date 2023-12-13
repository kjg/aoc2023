file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

lines = File.readlines(file, chomp: true)
patterns = []

def find_reflections(pattern)
  reflections = []
  first_line = pattern.first
  mirrored = (1..first_line.length-1).map do |vert|
    num_offsets = [vert, first_line.length-vert].min
    line_matches = (1..num_offsets).map do |offset|
      matches = pattern.map do |line|
        line[vert-offset] == line[vert+offset - 1]
      end
      matches.all?
    end
    line_matches.all?
  end
  
  mirrored.each_with_index do |m, index|
    reflections << index+1 if m
  end
  
  mirrored = (1..pattern.length-1).map do |line_no|
    num_offsets = [line_no, pattern.length-line_no].min
    col_matches = (1..num_offsets).map do |offset|
      matches =(0...first_line.length).map do |col|
        pattern[line_no-offset][col] == pattern[line_no+offset-1][col]
      end
      matches.all?
    end
    col_matches.all?
  end
  
  mirrored.each_with_index do |m, index|
    reflections << (index+1)*100 if m
  end
  reflections
end

current_pattern = []
lines.each do |line|
  if line.length > 0
    current_pattern << line
  else
    patterns << current_pattern
    current_pattern = []
  end
end
patterns << current_pattern if current_pattern.length.positive?

values = patterns.map do |pattern|
  orginal_reflections = find_reflections(pattern)
  new_reflection = nil
  pattern.each_with_index do |line, line_index|
    line.each_char.with_index do |char, char_index|
      new_pattern = pattern.map(&:dup)
      new_char = char == "#" ? "." : "#"
      # puts new_char
      new_pattern[line_index][char_index] = new_char
      # puts "NEW"
      # puts new_pattern
      # puts find_reflections(new_pattern)
      new_reflections = find_reflections(new_pattern) - orginal_reflections
      
      if new_reflections.length.positive?
        # puts new_reflections.inspect
        new_reflection = new_reflections.first
      end
    end
  end
  # if new_reflection.nil?
  #   puts "INVALID"
  #   puts pattern
  #   puts orginal_reflections
  # end
  # puts new_reflection
  new_reflection
end
puts values.sum
