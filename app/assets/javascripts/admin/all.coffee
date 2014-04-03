#= require jquery
#= require jquery_ujs

## require turbolinks
## require nprogress
## require nprogress-turbolinks

$(document).on "ready page:load", ->
  # automatically sets the "colspan" attribute for all td.data-autoset-colspan
  $("table td[data-autoset-colspan]").each ->
    $table = $(this).closest("table")
    head_columns = $table.find("thead tr th").length
    $(this).attr("colspan", head_columns)