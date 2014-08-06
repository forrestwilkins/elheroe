class GameBoard < ActiveRecord::Base
  belongs_to :user
  has_many :cards, dependent: :destroy
  
  def you_won!
    winner = false
    Prize.wins.each do |key, win|
      a_win = true
      for num in win
        unless cards.find_by_board_loc(num).redeemed
          a_win = false
        end
      end
      if a_win
        winner = true
        User.find(user_id).prizes.create winning_combo: key.to_s
      end
    end
    return winner
  end
  
  def populate
    board_loc = 1
    for image in Dir.glob("app/assets/images/cards/board_#{board_number.to_s}/bw/*.png")
      cards.create image: "cards/board_#{board_number.to_s}/bw/#{image.split('/').last}",
        board_loc: board_loc
      board_loc += 1
    end
  end
  
  def board_number
    begin
      Code.find(code_id).board_number
    rescue
      nil # nil to the rescue!
    end
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