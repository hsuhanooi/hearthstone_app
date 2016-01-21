require_relative 'card.rb'

file = ARGV[0]
query = ARGV[1]

def load_index(file)
  iidx = {}
  File.open(file, 'r') {|f|
    f.each_line {|line|
      row = line.split("\t")
      name, value, pick_bonus = row
      card = Card.new(name, value, pick_bonus: pick_bonus.strip.split(","))
      tokens = card.name.split(/[\- ]/)

      tokens.each{|token|
        clean = token.strip.downcase
        (0..clean.size-1).each {|i|
          tok = clean[0,i+1] 
          if iidx[tok].nil?
            iidx[tok] = [card]
          else
            iidx[tok] << card
          end
          # puts "TOKEN: #{tok}; CARD: #{card.name}"
        }
      }
    }
  }
  return iidx
end

iidx = load_index(file)

if !query.nil? && query != ""
  puts "Matches"
  matches = iidx[query]
  matches && matches.each{|card|
    puts "#{card.to_s}"
  }
end