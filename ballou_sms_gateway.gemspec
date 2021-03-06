Gem::Specification.new do |gem|
  gem.authors       = ["Linus Oleander"]
  gem.email         = ["linus@oleander.nu"]
  gem.description   = %q{Ruby bindings for Ballou's (ballou.se) SMS Gateway.}
  gem.summary       = %q{Ruby bindings for Ballou's (ballou.se) SMS Gateway.}
  gem.homepage      = "https://github.com/oleander/ballou-sms-gateway"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "ballou_sms_gateway"
  gem.require_paths = ["lib"]
  gem.version       = "2.0.2"
  
  gem.add_dependency("rest-client")
  gem.add_dependency("uuid")
  gem.add_dependency("nokogiri")
  gem.add_dependency("acts_as_chain", "~> 1.0.1")
  
  gem.add_development_dependency("vcr")
  gem.add_development_dependency("rspec")  
  gem.add_development_dependency("webmock")
  
  gem.required_ruby_version = "> 1.9.0"
end
