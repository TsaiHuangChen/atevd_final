class ClearQueueController < ApplicationController
  def index
    #Sidekiq::Queue.new.clear
    Lot.find_each do |lot|
        lot.site_difference_detected = false
        lot.continuously_failure_detected = false
        lot.time_variance_detected = false
        lot.different_tester_variance_detected = false

      lot.save
    end
  end
end
