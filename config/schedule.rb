set :output, File.join(Whenever.path, 'log', 'cron.log')

every 3.hours, :roles => [:app] do
  runner "NewSpider.run"
end
