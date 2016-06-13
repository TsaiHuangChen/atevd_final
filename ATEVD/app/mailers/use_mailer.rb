class UseMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.use_mailer.alert_comment.subject
  #

  default :from => "avd.server@gmail.com"

  def self.send_multi_mail(send_alert)
    @recipients = ["avd.eng.01@gmail.com", "acd.eng.02@gmail.com", "avd.eng.03@gmail.com"]
    @recipients.each do |recipient|
      alert_comment(recipient, send_alert).deliver_now!
    end
  end

  def alert_comment(recipient, send_alert)
    #common information
    @alert_lot = send_alert.lot.name
    @alert_device = send_alert.lot.device.name
    @alert_time = send_alert.created_at
    if(send_alert.alerts_kind == 1)
      @alert_type = 1
      @max_yield = send_alert.max_yield
      @min_yield = send_alert.min_yield
      @max_element = send_alert.max_element
      @min_element = send_alert.min_element
      @alert_threshold = send_alert.lot.device.site_difference_detect_threshold
      @detected_serial = send_alert.detected_serial
      title = "site difference at #{send_alert.lot.name} alerts"
    elsif(send_alert.alerts_kind == 2)
      @alert_type = 2
      @detected_serial = send_alert.detected_serial
      @continuously_fail_number = send_alert.continuously_fail_number
      @continuously_fail_bin = send_alert.continuously_fail_bin
      @alert_threshold = send_alert.lot.device.continuously_failure_detect_threshold
      title = "Continuously fail at #{send_alert.lot.name} alerts"
    elsif(send_alert.alerts_kind == 3)
      @alert_type = 3
      @window_large = send_alert.lot.device.time_variance_detect_window_large
      @window_small = send_alert.lot.device.time_variance_detect_window_small
      @region_1_yield = send_alert.region_1_yield
      @region_2_yield = send_alert.region_2_yield
      @alert_threshold = send_alert.lot.device.time_variance_detect_threshold
      @detected_serial = send_alert.detected_serial
      title = "Time variance at #{send_alert.lot.name} alerts"
    else
      @alert_type = 4
      @max_yield = send_alert.max_yield
      @min_yield = send_alert.min_yield
      @max_element = send_alert.max_element
      @min_element = send_alert.min_element
      @alert_threshold = send_alert.lot.device.different_tester_variance_detect_threshold
      @detected_serial = send_alert.detected_serial
      title = "Different ATE variance at #{send_alert.lot.name} alerts"
    end


    mail( :to => recipient, :subject => title )

  end
end
