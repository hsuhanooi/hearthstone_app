require_relative 'card.rb'

file = ARGV[0]

Value = /^(\d{1,3})\^{0,2}\*{0,2}$/
Title = /ADWCTA's Arena Tier List: (\w+*)/

def parse_name_at_index(row, i, name)
  value = row[i]
  if Value.match(value) || value == "(empty)" || value == "half---" || value == "(Value)"
    name.strip
  else
    parse_name_at_index(row, i-1, "#{value} #{name}")
  end
end

def parse_pick_bonus(value)
  boni = []
  bon = value.match(/[^\d]+/)
  if bon
    bonus = bon[0]
    if bonus.index("**")
      boni << :second_pick_much_lower_value
    elsif bonus.index("*")
      boni << :second_pick_lower_value_third_much_lower
    end
    if bonus.index("^^")
      boni << :high_first_pick_bonus
    elsif bonus.index("^")
      boni << :slight_first_pick_bonus
    end
  end
  return boni
end

cards = []
type = ""

#Key: ^^ = high first pick bonus; ^ = slight first pick bonus; 
#** = second pick has much lower Value; 
#* = second pick has lower Value, third has much lower Value

File.open(file) {|f|
  str = f.read
  type = Title.match(str)[1]

  row = str.split("\s")
  row.each_with_index{|field, i|

    match = Value.match(field)
    if field.strip != "" && match
      card_name = parse_name_at_index(row, i-1, "")
      value = match[1]
#      puts "FIELD:#{field}\tCARD:#{card_name}\tVALUE:#{value}"
      card = Card.new(card_name, value, pick_bonus: parse_pick_bonus(value))
      cards << card
      # puts card.to_s
    end
  }
}

date = Time.now.strftime("%Y-%m-%d")
File.open("data/parsed/#{type}-#{date}.tsv", 'w') {|out|
  strs = cards.map{|card| "#{card.name}\t#{card.value}\t#{card.pick_bonus.join(",")}"}
  out.write(strs.join("\n"))
}

