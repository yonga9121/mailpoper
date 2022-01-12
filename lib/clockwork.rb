require 'clockwork'
require File.expand_path('../../config/boot.rb', __FILE__)
require File.expand_path('../../config/environment.rb', __FILE__)

module Clockwork
  configure do |config|
    log_dir = File.dirname(File.expand_path('../../log/clockwork.log', __FILE__))
    unless File.directory? log_dir
      FileUtils.mkdir_p(log_dir)
    end
    config[:logger] = Logger.new(File.expand_path('../../log/clockwork.log', __FILE__))
  end
  Mongo::Logger.logger.level = ::Logger::INFO
  puts "Clockwork configured. Starting."
  every(1.minute, 'Sending Emails') do
    puts "Sending Emails"
    RegistrationWorker.perform()
  end
end
