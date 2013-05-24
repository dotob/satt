# after document loaded completely
$(document).ready ->
  $("#searchterm").focus()
  presearch()
  $("#searchterm").keyup ->
    presearch()

presearch = () ->
    searchterm = $("#searchterm").val()
    $(".resultrow").remove()
    throttled_search searchterm

# do searchrequest to searchservice
search = (searchterm) ->
  url = "/search_menu_items/#{user_order_id()}/#{searchterm}"
  $.getJSON url, (results) ->
    count = results.items.length
    elips = ""
    $("#result_count").text("gefunden (#{count}#{elips})")
    $.each results.items, (k, v)->
      fill v, results.user_order_id

# render a table row
fill = (item, user_order_id) ->
  tmpl = table_row_template()
  t = HandlebarsTemplates[tmpl]({item: item, user_order_id: user_order_id});
  $(t).appendTo("#results")

# find which search to query
user_order_id = () ->
  $("#searchterm").attr("data-user-order-id")

# find which template to use for table
table_row_template = () ->
  $("#results").attr("data-row-template")

# make search throttled (do not consider every keypress)
throttled_search = _.throttle search, 500
