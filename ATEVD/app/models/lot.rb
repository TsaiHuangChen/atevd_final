class Lot < ActiveRecord::Base
  belongs_to :device
  has_many :sites, :dependent => :destroy
  has_many :data, :dependent => :destroy

  has_many :alerts, :dependent => :destroy

  accepts_nested_attributes_for :sites

  #validate the unique
  #validates :name, uniqueness: true

  #validate the necessary blank
  validates :name, presence: true
  validates :tester, presence: true
  validates :device, presence: true
  validates :total_device_count, presence: true
  validates :site_number, presence: true
  validates :generate_mode, presence: true

  validate :total_number_is_divisible_to_site_number

  #validate the necessary if the generate mode is NORMAL
  #validates :basic_yield, presence: true, :unless => lambda { self.generate_mode != NORMAL }

  #validates :basic_yield, presence: true, :if => :mode_normal?
  #validates :cliff_number, :first_region_yield, :second_region_yield, presence: true, :if => :mode_cliff?


  def total_number_is_divisible_to_site_number
    if((total_device_count % site_number) != 0)
      errors.add(:total_device_count, "total device count is not divisible by the site number!")
    end
  end

  

  def mode_normal?
    generate_mode == 1
  end

  def mode_cliff?
    generate_mode == 2
  end

  def mode_site_difference?
    generate_mode == 3
  end
end
