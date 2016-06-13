class Device < ActiveRecord::Base

  has_many :lots, :dependent => :destroy
  #validate device uniqueness
  validates :name, uniqueness: true
  
  #validate the necessary blank
  validates :name, presence: true


  #validate the site difference parameter must exists
  validates :site_difference_detect_window, presence: true, :unless => lambda { self.site_difference_detect_enable == false }
  validates :site_difference_detect_threshold, presence: true, :unless => lambda { self.site_difference_detect_enable == false }

  #validate the continuously failure parameter must exist
  validates :continuously_failure_detect_threshold, presence: true, :unless => lambda { self.continuously_failure_detect_enable == false }

  #validate the time variance parameter must exist
  validates :time_variance_detect_window_small, presence: true, :unless => lambda { self.time_variance_detect_enable == false }
  validates :time_variance_detect_window_large, presence: true, :unless => lambda { self.time_variance_detect_enable == false }
  validates :time_variance_detect_threshold, presence: true, :unless => lambda { self.time_variance_detect_enable == false }

  #validate the different tester variance parameters must exist
  validates :different_tester_variance_detect_window, presence: true, :unless => lambda { self.different_tester_variance_detect_enable == false }
  validates :different_tester_variance_detect_threshold, presence: true, :unless => lambda { self.different_tester_variance_detect_enable == false }

end
