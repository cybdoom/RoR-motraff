$ =>
  @quickController =
    content:
      link:
        apps: []

    isSelectButtonDisabled: ->
      $('#quickSearchResultTable input:checkbox:checked').length <= 0

    getSelectedApps: ->
      result = []
      mask = @selectionMask.toString(2)
      shift = @content.link.apps.length - mask.length
      for zeroOrOne, index in mask
        result.push @content.link.apps[shift + index] if zeroOrOne is "1"
      result

    render: (template, data) ->
      html = HandlebarsTemplates["quicks/#{template}"](data)
      $('#quickContent').html(html)

      button = $('actionPrepareQuickLink')
      if template == 'items'
        button.show()
      else
        button.hide()

  $('#quicks_search_form')
    .on("ajax:success", (e, data, status, xhr) ->
      if xhr.status is 200
        quickController.content.link.apps = data
        quickController.render 'items',
          apps: data
          isSelectButtonDisabled: quickController.isSelectButtonDisabled()
    )
    .on("ajax:error", (e, xhr, status, error) ->
      console.error error
    )
    .on('click', 'input:checkbox:enabled', (e) ->
      type = $(@).data('type')
      value = $(@).val()
      other$ = $("#quickSearchResultTable input:checkbox[data-type='#{type}']:not(input[value='#{value}'])")
      if $(@).prop('checked')
        other$.hide()
      else
        other$.show()

      button = $('#actionPrepareQuickLink')
      button.attr('disabled', if quickController.isSelectButtonDisabled() then 'disabled' else null)
    )
    .on('click', '#actionPrepareQuickLink', (e) ->
      quickController.selectionMask = 0
      $.each $('#quickSearchResultTable input:checkbox'), (index, checkbox) ->
        quickController.selectionMask *= 2
        quickController.selectionMask += 1 if $(checkbox).prop('checked')

      $.ajax
        url: '/quicks/get_access'
        success: (response) ->
          keys_to_copy = ['public_code', 'private_code']
          keys_to_copy.forEach (key) ->
            quickController.content.link[key] = response[key]
          quickController.render 'prepare',
            apps: quickController.getSelectedApps()
            link: response
        error: (response) ->
          console.error response.error
    )
    .on('click', '#actionQuickSave', (e) ->
      linkData = {}
      $.extend linkData, quickController.content.link, {apps: JSON.stringify(quickController.content.link.apps)}

      onFail = (response) ->
        console.error response.error
        quickController.render 'items', {apps: quickController.content.link.apps}

      $.ajax
        url: '/quicks'
        method: 'POST'
        data:
          link: linkData
        success: (response, status) ->
          if status isnt 'success'
            onFail(response)
          else
            quickController.render 'created', response
        error: onFail

    )
    .on('click', '#actionQuickCancel', (e)->
      quickController.render 'items',
        apps: quickController.content.link.apps
    )

