require "uuid"
require "rest-client"
require "uri"
require "acts_as_chain"

class BallouSmsGateway
  acts_as_chain :username, :password, :id, :request_id, :message, :to, :from
  
  def initialize
    # 
    # @UN Username
    # @PW Password
    # @O Sender
    # @RI Request id
    # @CR SMS id
    # @D Receiver
    # @LONGSMS Is this a long sms?
    # @M Message
    #
    @url = %w{
      http://sms2.ballou.se/http/get/SendSms.php?
      UN=%s&
      PW=%s&
      CR=%s&
      RI=%s&
      O=%s&
      D=%s&
      LONGSMS=%s&
      M=%s
    }.join
    
    @id         = UUID.new.generate
    @long       = false
    @request_id = UUID.new.generate
  end
  
  def long
    tap { @long = true }
  end
  
  def send!
    if @message.length > 160 and not @long
      raise "Message is to long, #{@message.length} characters."
    end
    RestClient.get(url)
  end
  
  def url
    @url % [@username, @password, @id, @request_id, @from, @to, @long, escaped_message]
  end
  
  def escaped_message
    CGI::escape(@message)
  end
end
