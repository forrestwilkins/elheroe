class User < ActiveRecord::Base
  has_many :game_boards
  has_many :comments
  has_many :prizes
  has_many :cards
  has_many :posts
  has_many :notes
  # validations for creation of user
  validates :name, presence: true
  validates :password, presence: true
  validates_confirmation_of :password
  validates_numericality_of :zip_code
  validates_uniqueness_of :name

  before_save :downcase_name
  
  mount_uploader :icon, ImageUploader
  
  ZIP_CODE_RANGE = 10
  
  def close_enough(content)
    zips_in_range = []
    for user in User.all
      if self.zip_code and self.network_size and content.zip_code
        if (self.zip_code - user.zip_code).abs < ZIP_CODE_RANGE + self.network_size
          zips_in_range << user.zip_code
        end
      end
    end
    # sorts by difference
    zips_in_range.sort_by! do |zip|
      (self.zip_code - zip).abs
    end
    # removes the most different and searches for match
    for zip in zips_in_range.reverse.drop zips_in_range.size / 5
      if content.zip == zip
        return true
      end
    end
  end

  def self.authenticate(name, password)
    user = find_by_name(name.downcase)
    if user && password == user.password
      user
    else
      nil
    end
  end
  
  def downcase_name
    name.downcase!
  end
end
