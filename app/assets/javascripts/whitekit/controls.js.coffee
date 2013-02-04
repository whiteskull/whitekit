window.WhitekitControl =

  # get cookie
  cookie: (cookie_name)->
    result = document.cookie.match ( '(^|;) ?' + cookie_name + '=([^;]*)(;|$)' )
    if result
      unescape ( result[2] )
    else
      ''
  # set cookie
  cookie_set: (name, value, days = 30)->
    oDate = new Date()
    oDate.setDate(days + oDate.getDate())
    # domain = self.location.host
    document.cookie = name + "=" + value + "; path=/; expires=" + oDate.toGMTString()

  # delete cookie
  cookie_delete: (name)->
    # domain = self.location.host
    document.cookie = name + "=; path=/; expires=Thu, 01 Jan 1970 00:00:01 GMT"

$(document).ready ->

  # Hover on tools and image
  $('#whitekit-tools, #whitekit-tools a img').hover ->
    if $('#whitekit-tools .whitekit-slide-panel.w-open').hasClass('visible') || $('#whitekit-tools .whitekit-slide-panel.w-close').hasClass('visible')
      $(this).stop().fadeTo(400, 1)
  ,->
    if $('#whitekit-tools .whitekit-slide-panel.w-open').hasClass('visible') || $('#whitekit-tools .whitekit-slide-panel.w-close').hasClass('visible')
      $(this).stop().fadeTo(400, 0.5)

  # Hover on left panel in tools
  $('#whitekit-tools .whitekit-slide-panel').hover ->
    if $(this).hasClass('visible')
      $(this).stop().fadeTo(400, 0.7)
  ,->
    if $(this).hasClass('visible')
      $(this).stop().fadeTo(400, 0.3)

  # Click on the left panel in tools to close panel
  $('#whitekit-tools .whitekit-slide-panel.w-open').click ->
    next = $(this).next();
    if $(this).hasClass('visible')
      next.fadeTo(400, 0.3)
      $(this).removeClass('visible').fadeOut(400).parent().animate {right: '-214px'}, 400, ->
        next.addClass('visible');
        WhitekitControl.cookie_set('whitekit-tools', 'closed')
      $('#whitekit-tools').fadeTo(400, 0.5)

  # Click on the left panel in tools to open panel
  $('#whitekit-tools .whitekit-slide-panel.w-close').click ->
    prev = $(this).prev()
    if $(this).hasClass('visible')
      prev.fadeTo(400, 0.3)
      $(this).removeClass('visible').fadeOut(400).parent().animate {right: 0}, 200, ->
        WhitekitControl.cookie_delete('whitekit-tools')
        prev.addClass('visible')

  # Hover on editable blocks
  $('.white_block, .news').hover ->
    edit = WhitekitControl.cookie('whitekit-edit')
    if edit == 'on'
      $(this).addClass('whitekit-hover')
  ,->
    edit = WhitekitControl.cookie('whitekit-edit')
    if edit == 'on'
      $(this).removeClass('whitekit-hover')

  # Hover on editable news in block
  $('.white_block .news').hover ->
    edit = WhitekitControl.cookie('whitekit-edit')
    if edit == 'on'
      $(this).addClass('whitekit-sub-hover')
  ,->
    edit = WhitekitControl.cookie('whitekit-edit')
    if edit == 'on'
      $(this).removeClass('whitekit-sub-hover')

  # Click on editable news
  $('.news').click (e)->
    e.stopPropagation()
    edit = WhitekitControl.cookie('whitekit-edit')
    if edit == 'on'
      block = $(this).attr('id')
      id = parseInt(block.split('_').slice(-1)[0])
      document.location.href = "/admin/news/#{id}/edit"

  # Click on editable blocks
  $('.white_block').click ->
    console.log($(this).class);
    edit = WhitekitControl.cookie('whitekit-edit')
    if edit == 'on'
      block = $(this).attr('id')
      id = parseInt(block.split('_').slice(-1)[0])
      document.location.href = "/admin/block/#{id}/edit"

  # Click on edit in tools
  $('#whitekit-tools #whitekit-edit').click (e)->
    e.preventDefault()
    edit = WhitekitControl.cookie('whitekit-edit')
    console.log(edit);
    if edit == 'on'
      WhitekitControl.cookie_delete('whitekit-edit')
      document.location.reload()
    else
      WhitekitControl.cookie_set('whitekit-edit', 'on')
      document.location.reload()

  # Click on clear caches in tools
  $('#whitekit-tools #whitekit-clear-caches').click ->
    $(this).remove()
    $('#whitekit-tools #whitekit-clear-caches-loader').show()

  # Ace editor
  ace_editor = ace.edit('whitekit-editor')
  ace_editor.setTheme('ace/theme/monokai')
  ace_editor.getSession().setMode("ace/mode/ruby")
  ace_editor.getSession().setTabSize(2)


















