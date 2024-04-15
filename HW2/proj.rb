require 'rails'

AUTOMAT = [
          #  D   S   C   T   I   N   L   {   }   [   ]   ,   ;   '   "   =   -   +
            [1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0], # S0
            [0,  2,  0,  0,  2,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0], # S1
            [0,  0,  0,  0,  0,  0,  0,  3,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0], # S2
            [0,  0,  4,  5,  0,  0,  0,  0, 10,  0,  0,  0,  0,  0,  0,  0,  0,  0], # S3
            [0,  0,  0,  5,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0], # S4
            [0,  0,  0,  0,  6,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0], # S5
            [0,  0,  0,  0,  0,  0,  0,  0,  0,  7,  0,  0,  3,  0,  0,  0,  0,  0], # S6
            [0,  0,  0,  0,  0,  8,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0], # S7
            [0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  9,  0,  0,  0,  0,  0,  0,  0], # S8
            [0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  3,  0,  0,  0,  0,  0], # S9
            [0,  0,  0,  0, 11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0], # S10
            [0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 12,  0,  0,  0,  0,  0], # S11
            [0,  0, 13,  0, 14,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0], # S12
            [0,  0,  0,  0, 14,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0], # S13
            [0,  0,  0,  0, 15,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0], # S14
            [0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 16,  0,  0], # S15
            [0,  0,  0,  0,  0,  0,  0, 17,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0], # S16
            [0,  0,  0,  0,  0, 20,  0,  0, 25,  0,  0,  0,  0, 21, 23,  0, 18, 19], # S17
            [0,  0,  0,  0,  0, 20,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0], # S18
            [0,  0,  0,  0,  0, 20,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0], # S19
            [0,  0,  0,  0,  0,  0,  0,  0, 25,  0,  0, 24,  0,  0,  0,  0,  0,  0], # S20
            [0,  0,  0,  0,  0,  0, 22,  0,  0,  0,  0,  0,  0, 20,  0,  0,  0,  0], # S21
            [0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 20,  0,  0,  0,  0], # S22
            [0,  0,  0,  0,  0,  0, 23,  0,  0,  0,  0,  0,  0,  0, 20,  0,  0,  0], # S23
            [0,  0,  0,  0,  0, 20,  0,  0,  0,  0,  0,  0,  0, 21, 23,  0, 18, 19], # S24
            [0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 14, 12,  0,  0,  0,  0,  0]  # S25 # S26 - end
          ]

def symbol?(x)
  [*('A'..'Z'), *('a'..'z'), '_'].include?(x) #|| ('0'..'9').include?(x)
end

def number?(x)
  ('0'..'9').include?(x)
end

def in_slovar?(ch)
  %w[{ } [ ] , ; ' " = - +].include?(ch)
end

def get_signal(ch)
  %w[D S C T I N L { } [ ] , ; ' " = - +].index(ch) || -1
end

def print_error(arr, i, ch) # порядок элементов в signals соответствует ошибкам
  error_messages = [
    'Expected \'typedef\'',
    'Expected \'struct\'',
    'Expected \'const\'',
    'Expected \'type\'',
    "Expected name of identifier, but found #{ch}",
    "Expected number, but found #{ch}",
    "Expected letter, but found #{ch}",
    "Expected '{', but found #{ch}",
    "Expected '}', but found #{ch}",
    "Expected '[', but found #{ch}",
    "Expected ']', but found #{ch}",
    "Expected ',', but found #{ch}",
    "Expected ';', but found #{ch}",
    "Expected '\'', but found #{ch}",
    "Expected '\"', but found #{ch}",
    "Expected '=', but found #{ch}",
    "Expected '-', but found #{ch}",
    "Expected '+', but found #{ch}"
  ]
  arr[i].each_with_index do |value, j|
    next if value.zero?

    puts error_messages[j]
  end
end

# D - typedef
# S - struct
# C - const
# T - type
# I - identifier
# N - number(unsigned)
# L - letter
# {}[],;'"=-+

def syntactic_analysis(str, syntactic_matrix)
  i = 0
  str.chars do |c|
    j = get_signal(c)
    if j == -1 
      puts "Unknown signal #{j}"
      return
    end
    if syntactic_matrix[i][j].zero?
      print_error(syntactic_matrix, i, c)
      puts 'Unsuccessful!'
      return
    else
      i = syntactic_matrix[i][j]
    end
  end
  puts 'Successful!'
end

def lexical_analysis(str)
  str.squish!
  result = ''
  buf = ''
  keywords = {
    'typedef' => 'D',
    'struct' => 'S',
    'const' => 'C',
    'char' => 'T',
    'int' => 'T'
  }
  k = 0
  flag = false
  identify_flag = number_flag = string_flag = false
  str.chars do |c|
    case
    when %w[' "].include?(c) then # check for string
      puts "Service symbol: #{c}"
      string_flag = !string_flag
      result << c
      buf = ''
    when string_flag then
      result << 'L'
    when in_slovar?(c) || c == ' '
      case # check for Identyty, Number or Service word
      when keywords.key?(buf)
        puts "Service word: #{buf}"
        result << keywords[buf]
      when identify_flag
        puts "Identify: #{buf}"
        result << 'I'
      when number_flag
        puts "Number: #{buf}"
        result << 'N'
      end
      identify_flag = number_flag = string_flag = false
      buf = ''
      unless c == ' '
        result << c
        puts "Service symbol: #{c}"
      end
    when symbol?(c)
      if number_flag
        puts 'Excepted number but found symbol'
        return
      else
        identify_flag ||= true # if if_flag is false => true
        buf << c
      end
    when number?(c)
      if identify_flag
        buf << c
      else
        number_flag ||= true
      end
      buf << c
    end
  end
  puts "result: #{result}"
  syntactic_analysis(result, AUTOMAT)
end

loop do
  print 'Input string; % - end: '
  input_string = gets.chomp
  break if input_string == '%'

  lexical_analysis(input_string)
end

# lexical_analysis(File.read('init.cpp'))
