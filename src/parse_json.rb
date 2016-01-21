require 'json'

require_relative 'card.rb'

file = ARGV[0]
out_file = ARGV[1]
cards = []


File.open(file) {|f|
  json = JSON.parse(f.read)
  json.each {|card_set, card_arr|
    card_arr.each {|card_hsh|
        collectible = card_hsh["collectible"]
        if collectible
            card_id = card_hsh["id"]
            name = card_hsh["name"]
            card = Card.new(name, nil)

            rarity = Card.parse_card_rarity(card_hsh["rarity"])
            cost = card_hsh["cost"]
            atk = card_hsh["attack"]
            health = card_hsh["health"]
            card_text = card_hsh["text"] && card_hsh["text"].gsub(/<\/?b>/, '').gsub("\n", "")
            playerClass = card_hsh["playerClass"]
            durability = card_hsh["durability"]
            race = card_hsh["race"] && Card.parse_card_race(card_hsh["race"])
            card_type = Card.parse_card_type(card_hsh["type"])
            mechanics = Card.parse_card_mechanics(card_hsh["mechanics"], card_text)

            card.card_id = card_id
            card.rarity = rarity
            card.mechanics = mechanics
            card.cost = cost
            card.attack = atk
            card.health = health
            card.text = card_text
            card.player_class = playerClass
            card.durability = durability
            card.race = race
            card.set = card_set
            card.card_type = card_type

            puts card.to_s
            cards << card
        end
    }
  }
}

File.open(out_file, 'w') {|out|
  order = [:card_id, :name, :set, :rarity, :card_type, :cost, :attack, :health, :text, :player_class, :durability, :race, :mechanics]
  strs = cards.map{|card| 
    order.map{|field| 
        card.send(field)
    }.join("\t")}
  out.write(strs.join("\n"))
}

