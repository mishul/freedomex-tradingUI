@MyOrdersUI = flight.component ->
  flight.compose.mixin this, [ItemListMixin]

  @getTemplate = (order) -> $(JST["templates/order_active"](order))

  @orderHandler = (event, order) ->
    return unless order.market.id == gon.market.id

    switch order.state
      when 'wait'
        @addOrUpdateItem order
      when 'cancel'
        @removeItem order.id
      when 'done'
        @removeItem order.id

  @cancelOrder = (event) ->
    tr = $(event.target).parents('tr')
    if confirm(formatter.t('place_order')['confirm_cancel'])
      $.ajax
        url:     formatter.market_url gon.market.id, tr.data('id')
        method:  'delete'
        success: =>
          location.reload()
  @handleSuccess = (event, data) ->
    @select('cancelDropDown').removeClass('open')
    #alert('Succcess!')
    location.reload()

  @handleError = (event, data) ->
    alert data.responseTex

  @after 'initialize', ->
    @on document, 'order::wait::populate', @populate
    @on document, 'order::wait order::cancel order::done', @orderHandler
    @on @select('tbody'), 'click', @cancelOrder

    @on @select('cancelButtons'), 'ajax:success', @handleSuccess
    @on @select('cancelButtons'), 'ajax:error', @handleError
