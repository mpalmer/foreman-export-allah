# -*- ruby -*-
# vim: set nosta noet ts=4 sw=4:
# encoding: utf-8

BEGIN {
	require 'pathname'
	basedir = Pathname.new( __FILE__ ).dirname.parent.parent.parent
	$LOAD_PATH.unshift( basedir ) unless $LOAD_PATH.include?( basedir )
}

require 'helpers'

require 'pathname'
require 'rspec'
require 'tmpdir'

require 'foreman/engine'
require 'foreman/export/allah'


#####################################################################
###	C O N T E X T S
#####################################################################
RSpec.configure do |config|
	config.order = 'rand'
	config.fail_fast = true
	config.mock_with( :rspec )
end


describe Foreman::Export::Allah do

	let( :servicedir ) { @tmpdir + 'service' }
	let( :datadir )    { Pathname(__FILE__).dirname.parent.parent + 'data' }
	let( :procfile )   { datadir + 'Procfile' }
	let( :engine ) do
		Foreman::Engine.new(options).load_procfile(procfile).tap do |engine|
			engine.env['HOMEDIR']       = '/Users/ged'
			engine.env['MONGREL2_HOME'] = '/var/run/mongrel2'
		end
	end
		 	
	let( :options )    {{
		:app_root    => datadir,
		:app         => 'test',
		:env         => datadir + '.env',
		:formation   => 'cms=2,api=0,mongrel2=1',
	}}

	subject { described_class.new(servicedir, engine, options) }

	before( :each ) do
		logdevice = ArrayLogger.new
		subject.logger = Logger.new( logdevice )
		subject.logger.formatter = HtmlFormatter.new( subject.logger )
		if ENV['HTML_LOGGING'] || (ENV['TM_FILENAME'] && ENV['TM_FILENAME'] =~ /_spec\.rb/)
			Thread.current['logger-output'] = logdevice.array
		end

		subject.export
	end

	around(:each) do |example|
		Dir.mktmpdir do |tmpdir|
			@tmpdir = Pathname.new(tmpdir)
			example.call
		end
	end

	it "creates the servicedir" do
		expect(servicedir).to be_directory
	end
	
	%w[ test-cms-1 test-cms-2 test-mongrel2 ].each do |procname|
		context "service #{procname}" do
			let(:procdir) { servicedir + procname }
			let(:runfile) { procdir + 'run' }

			it "creates the procdir" do
				expect(procdir).to be_directory
			end

			it "makes the runfile" do
				expect(runfile).to be_file
			end
			
			it "makes the runfile executable" do
				expect(runfile).to be_executable
			end
			
			it "changes to the correct directory" do
				expect(runfile.read).to match(%r{^cd #{datadir}$})
			end

			it "runs the correct command" do
				expect(runfile.read).to match(%r{^exec envdir #{procdir}/env })
			end
			
			let(:logdir) { procdir + 'log' }
			let(:logrun) { logdir + 'run' }
			
			it "creates the log service" do
				expect(logdir).to be_directory
			end
			
			it "creates the log runfile" do
				expect(logrun).to be_file
			end
			
			it "makes the log runfile executable" do
				expect(logrun).to be_executable
			end
			
			context "with default log option" do
				it "puts the correct content in the log runfile" do
					expect(logrun.read).to match(%r{^exec multilog s16777215 t ./logs$})
				end
			end

			context "with a custom log option" do
				let(:options) { super().merge(:log => "/my/log/dir") }

				it "puts the correct content in the log runfile" do
					expect(logrun.read).to match(%r{^exec multilog s16777215 t /my/log/dir/#{procname}$})
				end
			end

			let(:envdir) { procdir + 'env' }
			
			it "creates the envdir" do
				expect(envdir).to be_directory
			end
			
			it "writes HOMEDIR" do
				expect((envdir + 'HOMEDIR').read).to eq("/Users/ged\n")
			end
			
			it "writes MONGREL2_HOME" do
				expect((envdir + 'MONGREL2_HOME').read).to eq("/var/run/mongrel2\n")
			end

			let(:groupfile) { procdir + 'group' }
			
			it "creates the groupfile" do
				expect(groupfile).to be_file
			end

			it "sets the groupfile correctly" do
				name_bits = procname.split('-')[0..1]
				until name_bits.empty?
					expect(groupfile.read).to match(/^#{name_bits.join('-')}$/)
					name_bits.pop
				end
			end
		end
	end
end
