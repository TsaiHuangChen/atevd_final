class DataAnalyzeWorker
  include Sidekiq::Worker
  def perform()
    puts "starting data analyzer!"
    while true
      sleep 5
      #sleep 30  #analyze each 30 seconds
      Lot.find_each do |lot|
        if(Datum.where( :lot => lot ).last.nil?)
          current_serial = 0
        else
          current_serial = Datum.where( :lot => lot ).last.serial
        end


        if(lot.device.site_difference_detect_enable == true)
          if(lot.site_difference_detected == false)
            if (current_serial >= lot.device.site_difference_detect_window)
              do_site_different_detect(lot)
            #else
              #puts "#{lot.name} not enough information for site difference detection"
            end
          #else
            #puts "#{lot.name} site difference already detected!"
          end
        end

        if(lot.device.continuously_failure_detect_enable == true)
          if(lot.continuously_failure_detected == false)
            if(current_serial >= lot.device.continuously_failure_detect_threshold)
              do_continuously_fail_detect(lot)
            end
          #else
            #puts "#{lot.name} continuously failure already detected!"
          end
        end

        if(lot.device.time_variance_detect_enable == true)
          if(lot.time_variance_detected == false)
            if(current_serial >= (lot.device.time_variance_detect_window_large +  lot.device.time_variance_detect_window_small))
              do_time_variance_detect(lot)
            #else
              #puts "#{lot.name} not enough information for time variance detection"
            end
          #else
            #puts "#{lot.name} time variance already detected!"
          end
        end

        if(lot.device.different_tester_variance_detect_enable == true)
          if(lot.different_tester_variance_detected == false)
            if(current_serial >= lot.device.different_tester_variance_detect_window)
              do_diff_ate_variance_detect(lot)
            #else
              #puts "#{lot.name} not enough information for different ATE variance detection"
            end
          #else
            #puts "#{lot.name} differenct ate variance already detected!"
          end
        end

      end
      #ActiveRecord::Base.clear_active_connections!

    end
  end

  private


  def do_site_different_detect(lot)
    puts "#{lot.name} perform the site difference detection"
    #calc the yield of each site
    en_sites = lot.sites.where( :site_enable => true )

    site_array = []
    max_yield = 0.0
    min_yield = 100.0
    max_site = 0
    min_stie = 0
    for site in en_sites do
      passed = Datum.where( :lot => lot, :site => site.site_serial, :bin => 1 ).count
      total = Datum.where( :lot => lot, :site => site.site_serial).count
      site_yield = (passed.to_f / total.to_f) * 100.0
      site_array = site_array + [site_yield]

      if(site_yield >= max_yield)
        max_yield = site_yield
        max_site = site.site_serial
      end

      if(site_yield <= min_yield)
        min_yield = site_yield
        min_site = site.site_serial
      end
    end

    puts "#{lot.name} max_site_yield is #{max_yield}, min_site_yield is #{min_yield}"

    #calc the yield difference
    if ((max_yield-min_yield)> lot.device.site_difference_detect_threshold)
      #alert if the difference > threshold
      puts "#{lot.name} site difference detected!"

      #save the error information in alerts table
      a_in = Alert.new(
          :alerts_kind => 1,
          :fixed => false,
          :lot => lot,
          :max_yield => max_yield,
          :max_element => max_site.to_s,
          :min_yield => min_yield,
          :detected_serial => Datum.where( :lot => lot ).last.serial,
          :min_element => min_site.to_s
      )
      a_in.save
      #send email
      #UseMailer.send_multi_mail(a_in)

      #set the error detect flag to true
      lot.site_difference_detected = true
      lot.save


    end
  end

  def do_continuously_fail_detect(lot)
    puts "#{lot.name} perform the continuously failure detection"
    window = lot.device.continuously_failure_detect_threshold

    i = 0
    if(Datum.where( :lot => lot ).last.bin != 1)
      while(true)
        if(Datum.where( :lot => lot).order('id DESC').limit(i+1).last.bin == Datum.where( :lot => lot ).last.bin)
          i += 1
        else
          break
        end
      end

      if(i >= window)
        #alert if the difference > threshold
        puts "#{lot.name} continuously failure detected!"

        a_in = Alert.new(
            :alerts_kind => 2,
            :fixed => false,
            :lot => lot,
            :detected_serial => Datum.where( :lot => lot ).last.serial,
            :continuously_fail_number => i,
            :continuously_fail_bin => Datum.where( :lot => lot ).last.bin
        )
        a_in.save
        #send email
        #UseMailer.send_multi_mail(a_in)

        #set the error detect flag to true
        lot.continuously_failure_detected = true
        lot.save
      end
    end

  end

  def do_time_variance_detect(lot)
    puts "#{lot.name} perform the time variance detection"

    window_a = lot.device.time_variance_detect_window_large
    window_b = lot.device.time_variance_detect_window_small
    window_t = window_a + window_b

    passed_t = Datum.where( :id => Datum.where(:lot=>lot).last(window_t), :bin => 1 ).count #passed_a + passed_b
    passed_b = Datum.where( :id => Datum.where(:lot=>lot).last(window_b), :bin => 1 ).count
    passed_a = passed_t - passed_b

#puts "passed_t=#{passed_t}, passed_a=#{passed_a}, passed_b=#{passed_b}"

    yield_a  = (passed_a.to_f/window_a.to_f)*100.0
    yield_b  = (passed_b.to_f/window_b.to_f)*100.0


#    puts "#{lot.name} yield_a is #{yield_a} yield_b is #{yield_b}"

    thre = lot.device.time_variance_detect_threshold

    if((yield_b - yield_a).abs > thre)
      #alert if the difference > threshold
      puts "#{lot.name} time variance detected!"

      #save the error information in alerts table
      a_in = Alert.new(
          :alerts_kind => 3,
          :fixed => false,
          :lot => lot,
          :region_1_yield => yield_a,
          :region_2_yield => yield_b,
          :detected_serial => Datum.where( :lot => lot ).last.serial
      )
      a_in.save

      #send email
      #UseMailer.send_multi_mail(a_in)

      #set the error detect flag to true
      lot.time_variance_detected = true
      lot.save

    end

  end

  def do_diff_ate_variance_detect(lot)
    puts "#{lot.name} perform the different ate variance detection"
    #calc the lot yield
    window_1 = lot.device.different_tester_variance_detect_window
    #passed_1 = Datum.where( :id => Datum.where(:lot=>lot).last(window_1), :bin => 1 ).count
    passed_1 = Datum.where( :id => Datum.where(:lot=>lot), :bin => 1 ).count
    yield_1 = (passed_1.to_f/window_1.to_f)*100.0


    max_yield = yield_1
    min_yield = yield_1
    max_ate = lot.tester
    min_ate = lot.tester

    Lot.find_each do |lot2|
      if(lot2.name == lot.name)
        if(lot2.tester != lot.tester)
          if(Datum.where( :lot => lot2).count >= window_1)
            #passed_2 = Datum.where( :id => Datum.where(:lot=>lot2).last(window_1), :bin => 1 ).count
	    passed_2 = Datum.where( :id => Datum.where(:lot=>lot2), :bin => 1 ).count
            yield_2 = (passed_2.to_f/window_1.to_f)*100.0

            if(yield_2 >= max_yield)
              max_yield = yield_2
              max_ate = lot2.tester
            end

            if(yield_2 <= min_yield)
              min_yield = yield_2
              min_ate = lot2.tester
            end
          end
        end
      end
    end


    #calc the yield difference
    if ((max_yield-min_yield)> lot.device.different_tester_variance_detect_threshold)
      #alert if the difference > threshold
      puts "#{lot.name} different ate variance detected!"
      #do the vote
      #vote_system(site_array, lot.device.site_difference_detect_threshold)
      #save the error information in alerts table
      a_in = Alert.new(
            :alerts_kind => 4,
            :fixed => false,
            :lot => lot,
            :max_yield => max_yield,
            :max_element => max_ate,
            :min_yield => min_yield,
            :min_element => min_ate,
	    :detected_serial => Datum.where( :lot => lot ).last.serial
      )
      a_in.save

      #send email
      #UseMailer.send_multi_mail(a_in)

      #set the all lots error detect flag to true
      Lot.find_each do |lot2|
        if(lot2.name == lot.name)
          lot2.different_tester_variance_detected = true
          lot2.save
        end
      end
    end
  end

  def vote_system(yield_array, threshold)
    #find max and min yield
    puts "in the vote system"
    max_yield = yield_array.max
    max_index = yield_array.index(yield_array.max)
    min_yield = yield_array.min
    max_index = yield_array.index(yield_array.min)

    #estblish the candidate array
    candidate_array = [max_yield - 0.5*threshold]
    y = max_yield - 0.5*threshold
    while(y >= min_yield)
      y = y - threshold
      candidate_array << y
    end

    votes_array = Array.new(candidate_array.length+1, 0)

    yield_array.each do |y|
      for i in 0..(candidate_array.length-1) do
        if(y > candidate_array[i])
          votes_array[i] += 1
          break
        end
      end
    end

    #find out the most vote candidate
  end

end
