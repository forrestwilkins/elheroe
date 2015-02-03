class Zip < ActiveRecord::Base
  belongs_to :group
  
  validates_uniqueness_of :zip_code
  validate :valid_format
  
  ZIP_CODE_RANGE = 10
  
  def density
    zips_in_range = []
    for zip in Zip.all
      difference = (self.zip_code - zip.zip_code).abs
      if difference < ZIP_CODE_RANGE
        zips_in_range << zip.zip_code
      end
    end
    return zips_in_range.size
  end
  
  def self.orphans
    where group_id: nil
  end
  
  def self.record(zip)
    unless self.find_by_zip_code(zip) or zip.nil?
      new_zip = self.new zip_code: zip
      if new_zip.save
        true
      end
    end
  end
  
  def self.zip_code_range
    ZIP_CODE_RANGE
  end
  
  private
  
  def valid_format
    unless self.zip_code.to_s.size == 5
      errors.add(:invalid_zip, "Zip codes must be 5 digits.")
    end
  end
end
