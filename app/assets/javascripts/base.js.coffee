$ ->
  $.getJSON '/pages', (data) ->
    source = $("#tmpl_page_thumb").html()
    template = Handlebars.compile(source)

    for page in data
      $('#page_thumbnails').append template(page)
    $('#page_thumbnails .thumbnail img:last').load -> $(this).trigger 'load:all'
