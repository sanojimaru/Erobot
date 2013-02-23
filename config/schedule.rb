set :output, File.join(Whenever.path, 'log', 'cron.log')

every 3.hours, :roles => [:app] do
  runner "Spider.run"
end
