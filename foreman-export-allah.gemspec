require 'git-version-bump' rescue nil

Gem::Specification.new do |s|
	s.name = "foreman-export-allah"

	s.version = GVB.version rescue "0.0.0.1.NOGVB"
	s.date    = GVB.date    rescue Time.now.strftime("%Y-%m-%d")

	s.platform = Gem::Platform::RUBY

	s.summary  = "Export a Foreman Procfile to allah services"

	s.authors  = ["Matt Palmer"]
	s.email    = ["theshed+foreman-export-allah@hezmatt.org"]
	s.homepage = "http://theshed.hezmatt.org/foreman-export-allah"

	s.files = `git ls-files -z`.split("\0").reject { |f| f =~ /^(G|spec|Rakefile)/ }

	s.required_ruby_version = ">= 2.0.0"

	s.add_runtime_dependency "foreman", "~> 0.60"

	s.add_development_dependency 'bundler'
	s.add_development_dependency 'github-release'
	s.add_development_dependency 'guard-spork'
	s.add_development_dependency 'guard-rspec'
	s.add_development_dependency 'pry-byebug'
	s.add_development_dependency 'rake', '~> 10.4', '>= 10.4.2'
	# Needed for guard
	s.add_development_dependency 'rb-inotify', '~> 0.9'
	s.add_development_dependency 'rspec', "~> 3.0"
	s.add_development_dependency 'yard'
end
