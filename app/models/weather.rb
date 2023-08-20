class Weather < ApplicationRecord
  
  def temperatures
    super.map(&:to_f) rescue []
  end
end
