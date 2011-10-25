require "uuid"
require "rest-client"
require "uri"
require "acts_as_chain"

class BallouSmsGateway
  acts_as_chain :username, :password, :id, :request_id, :message
  
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
  
  #
  # Sends the message. Raises error if message is to long or if @send and @from isn't set.
  #
  def send!
    if @message.length > 160 and not @long
      raise "Message is to long, #{@message.length} characters."
    end
    
    unless @from
      raise "You need to specify a sender using #from."
    end
    
    unless @to
      raise "You need to specify a receiver using #to."
    end
    
    RestClient.get(url)
  end
    
  #
  # @to A list of phonenumbers. Can contain 0-9 and the "+" sign.
  # @return BallouSmsGateway
  def to(*to)
    to.flatten.each do |number|
      unless number.to_s.match(/[0-9\+]{4,}/)
        raise "Invalid receiver."
      end
    end
    
    @to = to.flatten.map { |number| CGI::escape(number) }.join(",")
    return self
  end
  
  #
  # @from String Sender. Max length when only numbers are submitet; 15, otherwise; 10
  # @return BallouSmsGateway
  #
  def from(from)
    if from.to_s.length.zero?
      raise "Sender is invalid, to short."
    end
    
    # Max length 15 for integers and 10 for chars 
    if from.match(/^[0-9]+$/)
      if  from.length > 15
        raise "Sender is invalid, to long."
      end
    elsif from.length > 10
      raise "Sender is invalid, to long."
    end
    
    @from = from
    return self
  end
  
  private
    def escaped_message
      CGI::escape(@message)
    end
    
    def url
      @url % [@username, @password, @id, @request_id, @from, @to, @long, escaped_message]
    end
end
