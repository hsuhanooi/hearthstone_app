class Card
  attr_accessor :card_id, :name, :value, :pick_bonus, :player_class, :rarity, :set, :card_type, :cost, :attack, :health, :durability, :mechanics, :race, :text

  def initialize(name, value, options={})
    self.name = name
    self.value = value
    self.pick_bonus = options[:pick_bonus]
  end

  def to_s
    [:card_id, :name, :value, :pick_bonus, :player_class, :rarity, :set, :card_type, :cost, :attack, :health, :durability, :mechanics, :race, :text].map {|field| "#{field.upcase}:#{self.send(field)}"}.join("\t")
  end

# typedef NS_ENUM(NSInteger, HSCardType) {
#     Spell=0,
#     Hero=1,
#     Minion=2,
#     Weapon=3
# };

  CardTypes = {:spell => 0, :hero => 1, :minion => 2, :weapon => 3}
  def self.parse_card_type(str)
    typ = CardTypes[str.downcase.to_sym]
    raise "Unrecognized card type #{str}" if typ.nil?
    typ
  end

# typedef NS_ENUM(NSInteger, HSCardRarity) {
#     Empty=0,
#     Free=1,
#     Common=2,
#     Rare=3,
#     Epic=4,
#     Legendary=5
# };

  CardRarity = {:empty => 0, :free => 1, :common => 2, :rare => 3, :epic => 4, :legendary => 5}
  def self.parse_card_rarity(str)
    typ = CardRarity[str.downcase.to_sym]
    typ = 0 if typ.nil?
    typ
  end

# typedef NS_ENUM(NSInteger, HSCardSet) {
#     Basic=0,
#     Classic=1,
#     Goblins=2,
#     Naxx=3,
#     Blackrock=4
# };

  CardSet = {:basic => 0, :classic => 1, :goblins => 2, :naxx => 3, :blackrock => 4}
  def self.parse_card_set(str)
    typ = CardSet[str.downcase.to_sym]
    raise "Unrecognized card set #{str}" if typ.nil?
    typ
  end

# typedef NS_ENUM(NSInteger, HSCardRace) {
#     None=0,
#     Beast=1,
#     Demon=2,
#     Dragon=3,
#     Mech=4,
#     Murloc=5,
#     Pirate=6,
#     Totem=7
# };

  CardRace = {:none => 0, :beast => 1, :demon => 2, :dragon => 3, :mech => 4, :murloc => 5, :pirate => 6, :totem => 7}
  def self.parse_card_race(str)
    typ = CardRace[str.downcase.to_sym]
    raise "Unrecognized card race #{str}" if typ.nil?
    typ
  end


# typedef NS_ENUM(NSInteger, HSCardMechanics) {
#     NoMechanics=0,
#     AdjacentBuff=1,
#     AffectedBySpellPower=2,
#     Aura=3,
#     Battlecry=4,
#     Charge=5,
#     Combo=6,
#     Deathrattle=7,
#     DivineShield=8,
#     Enrage=9,
#     Freeze=10,
#     HealTarget=11,
#     ImmuneToSpellPower=12,
#     Poisonous=13,
#     Stealth=14,
#     Secret=15,
#     Silence=16,
#     Spellpower=17,
#     Taunt=18,
#     Windfury=19
# };

  CardMechanics = {:no_mechanics => 0, :adjacentbuff => 1, :affectedbyspellpower => 2, :aura => 3,
    :battlecry => 4, :charge => 5, :combo => 6, :deathrattle => 7, :divineshield => 8, :enrage => 9,
    :freeze => 10, :healtarget => 11, :immunetospellpower => 12, :poisonous => 13, :stealth => 14,
    :secret => 15, :silence => 16, :spellpower => 17, :taunt => 18, :windfury => 19, :card_draw => 20
  }
  def self.parse_card_mechanics(arr, card_text)
    return "" if (arr.nil? || arr == "" || arr.empty?) && (card_text.nil? || card_text == "")
    mechanics = []
    (arr || []).each {|f|
      typ = CardMechanics[f.downcase.gsub(/\s/, "").to_sym]
      raise "Unable to recognize mechanics #{f}" if typ.nil?
      mechanics << typ  
    }

    mechanics << CardMechanics[:card_draw] if card_text.match(/[dD]raw [a\d] card/)
    return mechanics.join(",")
  end


end
