class GildedRose
  attr_reader :name, :days_remaining, :quality
  
  AGED_BRIE = "Aged Brie"
  BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert"
  SULFURAS = "Sulfuras, Hand of Ragnaros"
  CONJURED_MANA = "Conjured Mana Cake"
  NORMAL_ITEM = "Normal Item"
  MODERATE_QUALITY = 10
  MAX_QUALITY = 50
  NO_QUALITY = 0
  BEFORE_SELL_DAYS = 5
  ON_SELL_DAYS = 0
  AFTER_SELL_DAYS = -10

  def initialize(name:, days_remaining:, quality:)
    @name = name
    @days_remaining = days_remaining
    @quality = quality
  end

  def decrease_days_remaining(val = 1)
    @days_remaining -= val unless @name == SULFURAS
  end

  def tick
    update_quality
    decrease_days_remaining
  end

  def update_quality
    adjustment = (case @name
      when AGED_BRIE then calculate_aged_brie_adjustment 
      when BACKSTAGE_PASSES then calculate_backstage_pass_adjustment 
      when CONJURED_MANA then calculate_conjured_mana_adjustment 
      when NORMAL_ITEM then calculate_normal_item_adjustment
      else 0
    end)
    @quality += adjustment
  end
  
  def calculate_aged_brie_adjustment 
    val = (@days_remaining == ON_SELL_DAYS && @quality == MODERATE_QUALITY ? 2 : 1) unless @quality == MAX_QUALITY
    val = 1 if @days_remaining == BEFORE_SELL_DAYS && @quality == MODERATE_QUALITY
    (val = 2 if @days_remaining == AFTER_SELL_DAYS) unless @quality == MAX_QUALITY
    return val.nil? ? 0 : val
  end

   def calculate_backstage_pass_adjustment 
     (case @days_remaining
        when -10,0 then val = -10
        when 1, 5 then val = 3
        when 6, 10 then val = 2 
        when 11 then val = 1 
      end) unless @quality == MAX_QUALITY
     return val.nil? ? 0 : val
   end

  def calculate_conjured_mana_adjustment
    (case @days_remaining
      when -10, 0 then val = -4
      when 5 then val = -2
    end) unless @quality == NO_QUALITY
    return val.nil? ? 0 : val
  end

  def calculate_normal_item_adjustment 
    val = (@days_remaining > ON_SELL_DAYS ? -1 : -2) unless @quality <= NO_QUALITY
    return val.nil? ? 0 : val
  end

end