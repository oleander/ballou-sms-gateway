module BallouSmsGatewayModule
  class Request
    attr_reader :id, :to
    def initialize(args)
      args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
    end
    #
    # @return Boolean Did everything went okay?
    #
    def send?
      error == 0
    end
    
    def status
      @status ? @status.to_i : -2
    end
    
    def error
      @error.to_i
    end
  end
end