set :output, Rails.root.join('log', 'cron.log')

every 1.day do
  runner "Spider.run"
end
