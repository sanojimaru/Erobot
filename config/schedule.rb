set :output, File.join(Whenever.path, 'log', 'cron.log')

every 6.hours, :roles => [:app] do
  runner "Spider.run"
end
