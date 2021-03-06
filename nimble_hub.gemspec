require_relative "lib/nimble_hub/version"

Gem::Specification.new do |spec|
  spec.name        = "nimble_hub"
  spec.version     = NimbleHub::VERSION
  spec.authors     = ["Harris Reynolds"]
  spec.email       = ["mhreynolds@gmail.com"]
  # spec.homepage    = "TODO"
  spec.summary = "An integration hub for pulling in data from 3rd parties"
  spec.description = "An integration hub for pulling in data from 3rd parties"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.1.4", ">= 6.1.4.1"
  spec.add_dependency "devise"
  spec.add_dependency "httparty"
  spec.add_dependency "oauth"
  spec.add_dependency "friendly_id"
  spec.add_dependency "mongo"
  spec.add_dependency "twitter"
end
