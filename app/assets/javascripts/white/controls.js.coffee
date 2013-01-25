window.WhitecmsControl =

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
  $('#whitecms-tools, #whitecms-tools a img').hover ->
    if $('#whitecms-tools .whitecms-slide-panel.w-open').hasClass('visible') || $('#whitecms-tools .whitecms-slide-panel.w-close').hasClass('visible')
      $(this).stop().fadeTo(400, 1)
  ,->
    if $('#whitecms-tools .whitecms-slide-panel.w-open').hasClass('visible') || $('#whitecms-tools .whitecms-slide-panel.w-close').hasClass('visible')
      $(this).stop().fadeTo(400, 0.5)

  # Hover on left panel in tools
  $('#whitecms-tools .whitecms-slide-panel').hover ->
    if $(this).hasClass('visible')
      $(this).stop().fadeTo(400, 0.7)
  ,->
    if $(this).hasClass('visible')
      $(this).stop().fadeTo(400, 0.3)

  # Click on the left panel in tools to close panel
  $('#whitecms-tools .whitecms-slide-panel.w-open').click ->
    next = $(this).next();
    if $(this).hasClass('visible')
      next.fadeTo(400, 0.3)
      $(this).removeClass('visible').fadeOut(400).parent().animate {right: '-214px'}, 400, ->
        next.addClass('visible');
        WhitecmsControl.cookie_set('whitecms-tools', 'closed')
      $('#whitecms-tools').fadeTo(400, 0.5)

  # Click on the left panel in tools to open panel
  $('#whitecms-tools .whitecms-slide-panel.w-close').click ->
    prev = $(this).prev()
    if $(this).hasClass('visible')
      prev.fadeTo(400, 0.3)
      $(this).removeClass('visible').fadeOut(400).parent().animate {right: 0}, 200, ->
        WhitecmsControl.cookie_delete('whitecms-tools')
        prev.addClass('visible')

  # Hover on editable blocks
  $('.white_block').hover ->
    edit = WhitecmsControl.cookie('whitecms-edit')
    if edit == 'on'
      $(this).addClass('whitecms-hover')
  ,->
    edit = WhitecmsControl.cookie('whitecms-edit')
    if edit == 'on'
      $(this).removeClass('whitecms-hover')

  # Click on editable blocks
  $('.white_block').click ->
    edit = WhitecmsControl.cookie('whitecms-edit')
    if edit == 'on'
      block = $(this).attr('id')
      id = parseInt(block.split('_').slice(-1)[0])
      document.location.href = "/admin/block/#{id}/edit"

  # Click on edit in tools
  $('#whitecms-tools #whitecms-edit').click (e)->
    e.preventDefault()
    edit = WhitecmsControl.cookie('whitecms-edit')
    console.log(edit);
    if edit == 'on'
      WhitecmsControl.cookie_delete('whitecms-edit')
      document.location.reload()
    else
      WhitecmsControl.cookie_set('whitecms-edit', 'on')
      document.location.reload()

  # Click on clear caches in tools
  $('#whitecms-tools #whitecms-clear-caches').click ->
    $(this).remove()
    $('#whitecms-tools #whitecms-clear-caches-loader').show()



















