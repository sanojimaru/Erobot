Handlebars.registerHelper 'each_upto', (ary, max, options) ->
  return options.inverse this unless ary && ary.length > 0

  counter = 0
  result = []
  for obj in ary
    break if counter >= max
    result.push options.fn(obj)
    counter += 1
  result.join ''
