$ =>
  @quickController =
    content: []
    selectedIds: []
    renderContent: (template, context)  ->
      html = HandlebarsTemplates["quicks/#{template}"](context)
      $('#quickContent').html(html)
      if template == 'create'
        $('#actionCreateQuickLink').hide()
      else
        $('#actionCreateQuickLink').show()

  $('#quicks_search_form')
    .on("ajax:success", (e, data, status, xhr) ->
      if xhr.status is 200
        window.quickController.content = data
        quickController.renderContent('items', {apps: data})
    )
    .on("ajax:error", (e, xhr, status, error) ->
      console.error error
    )
    .on('click', 'input:checkbox:enabled', (e)->
      type = $(@).data('type')
      value = $(@).val()
      other$ = $("#quickSearchResultTable input:checkbox[data-type='#{type}']:not(input[value='#{value}'])")
      if $(@).prop('checked')
        other$.hide()
      else
        other$.show()
    )
    .on('click', '#actionCreateQuickLink', (e)->
      appIds = $('#quickSearchResultTable input:checkbox:checked').map(-> $(@).val())
      if appIds.length is 0
        alert 'PLease select at least one application from list'
        return
      $.getJSON '/quicks/get_access', (response)->
        selectedApps = _.filter window.quickController.content, (a)-> _.indexOf(appIds, a.id.toString()) isnt -1
        window.quickController.selectedApps = selectedApps
        window.quickController.access = response
        window.quickController.renderContent('create', {apps: selectedApps, access: response})
    )
    .on('click', '#actionQuickSave', (e) ->
      requestObject = {}
      $.extend(requestObject, window.quickController.access, {apps: JSON.stringify(window.quickController.selectedApps)})
      $.ajax
        url: '/quicks'
        method: 'post'
        data: requestObject
      alert 'Your link was saved'
      window.quickController.renderContent('items', {apps: window.quickController.content})
    )
    .on('click', '#actionQuickCancel', (e)->
      window.quickController.renderContent('items', {apps: window.quickController.content})
    )

