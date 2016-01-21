require 'nokogiri'

require_relative 'card.rb'

file = ARGV[0]
out_file = ARGV[1]
cards = []

File.open(file) {|f|
  page = Nokogiri::HTML(f.read)
  page.css("table#cardtable-collapsible-1 > tbody > tr").each {|row|
    fields = row.css("td")
    name = fields[0].text
    card = Card.new(name, nil)

    rarity = fields[2].text
    card_class = fields[3].text
    cost = fields[4].text
    atk = fields[5].text
    health = fields[6].text
    card_text = fields[7].text

    card.card_text = card_text
    card.card_class = card_class
    card.rarity = rarity
    card.cost = cost
    card.attack = atk
    card.health = health

    puts card.to_s
    cards << card
  }
}

# File.open(out_file, 'w') {|out|
#   strs = cards.map{|card| [card.name, card.card_text, card.card_type, card.rarity, card.set].join("\t")}
#   out.write(strs.join("\n"))
# }

