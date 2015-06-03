# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  appTemplate = Handlebars.compile $("#app-template").html();
  data =
    [
      id: 517845106
      logo_url: "http://is4.mzstatic.com/image/pf/us/r30/Purple3/v4/c6/61/61/c66161d3-5a6d-d77f-ab07-7c0092849d62/AppIcon57x57.png"
      publisher: "Tobi Apps Limited"
      store: "apple_store"
      title: "100 Floors - Can You Escape?"
      url: "https://itunes.apple.com/us/app/100-floors-can-you-escape/id517845106?mt=8&uo=4"
    ,
      id: 466993271
      logo_url: "http://is1.mzstatic.com/image/pf/us/r30/Purple7/v4/ae/3e/6e/ae3e6e0e-a3f4-1b75-3499-c709e1b0ab54/AppIcon57x57.png"
      publisher: "Tick Tock Apps Inc"
      store: "apple_store"
      title: "10000+ Wallpaper for iOS 8, iOS 7, iPhone, iPod and iPad"
      url: "https://itunes.apple.com/us/app/10000+-wallpaper-for-ios-8/id466993271?mt=8&uo=4"
    ]
  $('#apps').html(appTemplate apps: data)
  $('#new_search_apps').on("ajax:success", (e, data, status, xhr) ->
    $('#apps').html(appTemplate apps: data)
  ).on "ajax:error", (e, xhr, status, error) ->