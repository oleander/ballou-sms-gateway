# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ballou_sms_gateway/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Linus Oleander"]
  gem.email         = ["linus@oleander.nu"]
  gem.description   = %q{SMS gateway for ballou.se}
  gem.summary       = %q{SMS gateway for ballou.se}
  gem.homepage      = "https://github.com/oleander/ballou-sms-gateway"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "ballou_sms_gateway"
  gem.require_paths = ["lib"]
  gem.version       = BallouSmsGateway::VERSION
end
