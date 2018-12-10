@MyOrdersHistoryUI = flight.component ->
  flight.compose.mixin this, [ItemListMixin]

  @getTemplate = (order) -> $(JST["templates/order_history"](order))

  @orderHandler = (event, order) ->
    return unless order.market.id == gon.market.id

    switch order.state
      #when 'wait'
      #  @addOrUpdateItem order
      when 'cancel'
        @addOrUpdateItem order
      when 'done'
        @addOrUpdateItem order

  @after 'initialize', ->
    @on document, 'order::history::populate', @populate
    @on document, 'order::wait order::cancel order::done', @orderHandler
