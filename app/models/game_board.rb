class GameBoard < ActiveRecord::Base
  belongs_to :user
  has_many :cards, dependent: :destroy
  
  def populate
    case board_number
    when 1
      for image in Dir.glob("app/assets/images/cards/board_1/*.png")
        cards.create image: "cards/board_1/#{image.split('/').last}"
      end
    when 2
      for image in Dir.glob("app/assets/images/cards/board_2/*.png")
        cards.create image: "cards/board_2/#{image.split('/').last}"
      end
    when 3
      for image in Dir.glob("app/assets/images/cards/board_3/*.png")
        cards.create image: "cards/board_3/#{image.split('/').last}"
      end
    when 4
      for image in Dir.glob("app/assets/images/cards/board_4/*.png")
        cards.create image: "cards/board_4/#{image.split('/').last}"
      end
    end
  end
  
  def board_number
    Code.find(code_id).board_number if code_id
  end
  
  def self.redeem(code)
    _code = Code.find_by_code(code)
    if _code and _code.is_a_board
      _code
    else
      nil
    end
  end
end