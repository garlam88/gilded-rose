class GildedRose
  attr_reader :name, :days_remaining, :quality
  
  AGED_BRIE = "Aged Brie"
  BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert"
  SULFURAS = "Sulfuras, Hand of Ragnaros"
  CONJURED = "Conjured Mana Cake"
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
    adjustment = 0
    if @name == AGED_BRIE
      if @days_remaining == ON_SELL_DAYS
        if @quality != MAX_QUALITY
          if @quality == MODERATE_QUALITY
           adjustment = 2
         else
            adjustment = 1
         end
       end

      else
        if @days_remaining == BEFORE_SELL_DAYS
          if @quality == MODERATE_QUALITY
            adjustment = 1
          end
        else
          if @days_remaining == AFTER_SELL_DAYS
            adjustment = 2 unless @quality == MAX_QUALITY
          end
        end
      end
    else
      if @name == BACKSTAGE_PASSES
        if @quality != MAX_QUALITY
          case @days_remaining
            when -10,0 then adjustment = -10
            when 1, 5 then adjustment = 3
            when 6, 10 then adjustment = 2 
            when 11 then adjustment = 1 
          end

        end   
      else
        if @name == CONJURED
          if @quality != NO_QUALITY
            case @days_remaining
              when -10, 0 then adjustment = -4
              when 5 then adjustment = -2
            end 
          end
        else
          if @name == NORMAL_ITEM
            if @quality > NO_QUALITY
              if @days_remaining > ON_SELL_DAYS
                adjustment = -1
              else
                adjustment = -2
              end
            end
          end
        end
      end
    end
    @quality += adjustment
  end
end
