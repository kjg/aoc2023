file = File.join(File.dirname(__FILE__), ARGV[0] || 'example1.txt')

lines = File.readlines(file, chomp: true)
patterns = []

def find_reflection(pattern)
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
  
  if index = mirrored.find_index(true)
    return index+1
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
  
  if index = mirrored.find_index(true)
    return (index+1)*100
  end
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

puts patterns.map{ |p| find_reflection(p)}.sum
