# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = 'shopify_webhook'
  spec.version       = '0.0.1'
  spec.authors       = ['Pat Allan']
  spec.email         = ['pat@freelancing-gods.com']
  spec.summary       = %q{A Rack endpoint for handling Shopify webhooks.}
  spec.description   = %q{A Rack endpoint for handling Shopify webhooks, and fires an ActiveSupport notification for each succesful request.}
  spec.homepage      = 'http://github.com/inspire9/shopify_webhook'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
end
