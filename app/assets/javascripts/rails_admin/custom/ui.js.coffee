load_component_params = (component)->
  $.ajax
    url: '/whitekit/get_component_params'
    type: 'post'
    data: {component: component}
    success: (params)->
      $('#block_component_params_field .help-block').html("<pre>#{params}</pre>")

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
