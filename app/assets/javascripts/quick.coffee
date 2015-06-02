# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  data = items: [{name: "Some App"}, {name: 'App 2'}]
  source   = $("#entry-template").html();
  template = Handlebars.compile(source);
  html    = template(data);

  $('#items').append(html);