# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby-push-notifications/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby-push-notifications"
  spec.version       = RubyPushNotifications::VERSION
  spec.authors       = ['Carlos Alonso']
  spec.email         = ['info@mrcalonso.com']
  spec.summary       = %q{iOS, Android and Windows Phone Push Notifications made easy!}
  spec.description   = %q{Easy to use gem to send iOS, Android and Windows Phone Push notifications}
  spec.homepage      = 'https://github.com/calonso/ruby-push-notifications'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 1.9.3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'builder', '~> 3.2'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'factory_girl', '~> 4.0'
  spec.add_development_dependency 'webmock', '~> 1.20'
end
