load_component_params = (component)->
  $.ajax
    url: '/whitekit/get_component_params'
    type: 'post'
    data: {component: component}
    success: (params)->
      $('#block_component_params_field .help-block').html("<pre>#{params}</pre>")

$(document).ready ->

  # Fix rails admin window appear
  $('body').append($('#create-component-modal').remove())
  $('body').append($('#db-recovery-modal').detach())

  $('#db-recovery-modal form').submit ->
    $('#db-recovery-modal .modal-footer img').show()
    $('#db-recovery-modal .modal-footer input').remove()

  $('#create-component a').click (e)->
    if $(this).hasClass('disabled')
      false

  $('#create-component-modal .modal-body input').keydown ->
    $(this).removeClass('error')

  # Change component - load params help for component
  $(document).on 'change', '#block_component[name="block[component]"]', ->
    component = $(this).val()
    load_component_params(component)

  # Click on components group - load params help for component
  $(document).on 'click.component_params', 'fieldset', ->
    if $('#block_component_params_field', this).size() > 0
      component = $('#block_component[name="block[component]"]').val()
      load_component_params(component)
    $(document).off 'click.component_params'
