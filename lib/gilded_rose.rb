class GildedRose
  attr_reader :name, :days_remaining, :quality
  
  AGED_BRIE = "Aged Brie"
  NORMAL_ITEM = "Normal Item"
  CONJURED_MANA = "Conjured Mana Cake"
  SULFURAS = "Sulfuras, Hand of Ragnaros"
  BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert"
  
  NO_QUALITY = 0
  MAX_QUALITY = 50
  MODERATE_QUALITY = 10

  ON_SELL_DAYS = 0
  BEFORE_SELL_DAYS = 5
  AFTER_SELL_DAYS = -10

  def initialize(name:, days_remaining:, quality:)
    @name = name
    @days_remaining = days_remaining
    @quality = quality
  end

  def decrease_days_remaining
    @days_remaining -= 1 unless @name == SULFURAS
  end

  def tick
    update_quality
    decrease_days_remaining
  end

  def update_quality
    @quality +=
      case name
        when NORMAL_ITEM then calculate_normal_item_adjustment
        when AGED_BRIE then calculate_aged_brie_adjustment 
        when BACKSTAGE_PASSES then calculate_backstage_pass_adjustment 
        when CONJURED_MANA then calculate_conjured_mana_adjustment 
        else 0
      end
  end
  
  def calculate_aged_brie_adjustment 
    adjustment = days_remaining == ON_SELL_DAYS && quality == MODERATE_QUALITY ? 2 : 1 unless quality == MAX_QUALITY
    adjustment = 1 if days_remaining == BEFORE_SELL_DAYS && quality == MODERATE_QUALITY
    adjustment = 2 if days_remaining == AFTER_SELL_DAYS unless quality == MAX_QUALITY
    adjustment.nil? ? 0 : adjustment
  end

  def calculate_backstage_pass_adjustment 
    adjustment =
      case days_remaining
        when -10, 0 then -10
        when 1, 5 then 3
        when 6, 10 then 2 
        when 11 then 1 
        else 0
      end unless quality == MAX_QUALITY
    adjustment.nil? ? 0 : adjustment
  end

  def calculate_conjured_mana_adjustment
    adjustment = 
      case days_remaining
        when -10, 0 then -4
        when 5 then -2
        else 0
      end unless quality == NO_QUALITY
    adjustment.nil? ? 0 : adjustment
  end

  def calculate_normal_item_adjustment 
    adjustment = days_remaining > ON_SELL_DAYS ? -1 : -2 unless quality <= NO_QUALITY
    adjustment.nil? ? 0 : adjustment
  end

end