module BallouSmsGatewayModule
  class Request
    attr_reader :id, :to, :sms_id, :request_id, :message
    def initialize(args)
      args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
    end
    #
    # @return Boolean Did everything went okay?
    #
    def sent?
      error == 0
    end
    
    def status
      @status ? @status.to_i : -2
    end
    
    def error
      @error.to_i
    end
    
    alias_method :valid?, :sent?
  end
end