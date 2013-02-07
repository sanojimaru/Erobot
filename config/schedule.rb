set :output, Rails.root.join('log', 'cron.log')

every 6.hours do
  runner "Spider.run"
end
