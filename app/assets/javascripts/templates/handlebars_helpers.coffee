$ =>
  Handlebars.registerHelper 'iif', (v1, v2, options)->
    if v1 is v2
      return options.fn(@)
    return options.inverse(@)

