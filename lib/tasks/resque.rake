require 'resque/tasks'

task "resque:setup" => :environment do
  ENV['QUEUE'] ||= '*'
  #for redistogo on heroku
  #http://stackoverflow.com/questions/2611747/rails-resque-workers-fail-with-pgerror-server-closed-the-connection-unexpectedl
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }

  Resque.after_fork do |job|
    ActiveRecord::Base.establish_connection
  end

  desc "Alias for resque:work (To run workers on Heroku)"
  task "jobs:work" => "resque:work"
end

