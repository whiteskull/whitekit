$(document).ready ->

  create_component = $('#create-component-modal').remove()
  $('body').append(create_component)

  $('#create-component-modal .modal-footer a').click (e)->
    e.preventDefault()
    $('#create-component-modal .modal-body form').submit()

  $('#create-component a').click (e)->
    if $(this).hasClass('disabled')
      false

  $('#create-component-modal .modal-body input').keydown ->
    $(this).removeClass('error')

