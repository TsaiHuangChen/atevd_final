class DataGenerateWorker
  include Sidekiq::Worker
  def perform()
    puts "starting data generator!"
    while true
      #time1 = Time.now

      Lot.find_each do |lot|
        #find the last tested device serial
        if(lot.data.last.nil?)
          $last_test_serial = 0
        else
          $last_test_serial = lot.data.last.serial
        end

        #if the last tested device serial < total device count => generate
        if($last_test_serial < lot.total_device_count)
          for site in lot.sites do
            if(site.site_enable == true)
              #handle the current testing serial
              $last_test_serial += 1
	      
              #if(lot.generate_mode == 1) #normal mode
	      #  if($last_test_serial == 1) #first test
              #    current_bin = bin_decision_first(lot.basic_yield)    
              #  else
              #    past_passed_num = Datum.where( :lot => lot, :bin => 1 ).count
              #    past_yield = (past_passed_num.to_f/($last_test_serial-1).to_f)*100
              #    current_bin = bin_decision(past_yield, lot.basic_yield)
              #  end
              #elsif(lot.generate_mode == 2)   #cliff mode
              #elsif(lot.generate_mode == 4)   #constinuously fail mode
              #else
              #end
              #handle the current tested bin
              if(lot.generate_mode == 1)    #normal mode
                current_bin = bin_decision(lot.basic_yield)
              elsif(lot.generate_mode == 2)   #cliff mode
                if($last_test_serial <= lot.cliff_number)
                  current_bin =  bin_decision(lot.first_region_yield)
                else
                  current_bin =  bin_decision(lot.second_region_yield)
                end
	      elsif(lot.generate_mode == 4)   #burst failure mode
                if($last_test_serial <= lot.cliff_number)
                  current_bin =  bin_decision(lot.first_region_yield)
                else
		  current_bin = 5
                  #current_bin =  continuously_fail_bin(lot.second_region_yield)
                end
              else  #site_diff_mode
                current_bin = current_bin =  bin_decision(site.site_yield)
              end

              #write in the data table
              d_in = Datum.new(:serial => $last_test_serial, :lot => lot, :bin => current_bin, :site => site.site_serial)
              d_in.save
            end
          end
        else
          #if the last tested device serial >= total device count => break, kill the lot?
        end

      end
      #time2 = Time.now
      #puts "End 128 lots generating at #{time2}"
      sleep 1
    end
  end

  private

  #def bin_decision_backup(past_yield, desired_yield)
  #  if(past_yield <= desired_yield)
  #    bin = 1
  #  else
  #    bin = rand(2..10)
  #  end
  #  return bin
  #end


  def bin_decision(threshold)
    tmp = rand(1..100)
    if(tmp <= threshold)
      bin = 1
    else
      bin = rand(2..10)
    end
    return bin
  end

  def continuously_fail_bin(threshold)
    tmp = rand(1..100)
    if(tmp <= threshold)
      bin = 1
    else
      bin = 2
    end
    return bin
  end

end
