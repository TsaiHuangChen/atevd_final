require 'test_helper'

class UseMailerTest < ActionMailer::TestCase
  test "alert_comment" do
    mail = UseMailer.alert_comment
    assert_equal "Alert comment", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
