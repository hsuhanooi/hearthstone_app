require 'nokogiri'

require_relative 'card.rb'

file = ARGV[0]
out_file = ARGV[1]
cards = []

File.open(file) {|f|
  page = Nokogiri::HTML(f.read)
  page.css("table#cards > tbody > tr > td.visual-details-cell").each {|row|
    name = row.css("h3").first.text
    card = Card.new(name, nil)

    card_text = row.css("p").first
    card_text = card_text && card_text.text
    card_type = nil
    rarity = nil
    set = nil

    row.css("ul > li").each{|node|
      type_match = node.text.match(/Type: (\w+)/)
      rarity_match = node.text.match(/Rarity: (\w+)/)
      set_match = node.text.match(/Set: (\w+)/)

      card_type = type_match[1] if type_match
      rarity = rarity_match[1] if rarity_match
      set = set_match[1] if set_match

    }

    card.card_text = card_text
    card.card_type = card_type
    card.rarity = rarity
    card.set = set

    # puts card.to_s
    cards << card
  }
}

File.open(out_file, 'w') {|out|
  strs = cards.map{|card| [card.name, card.card_text, card.card_type, card.rarity, card.set].join("\t")}
  out.write(strs.join("\n"))
}

