window.MarketSwitchUI = flight.component ->
  @attributes
    table: 'tbody'
    marketGroupName: '.panel-body-head thead span.name'
    marketGroupItem: '.market-header .currency-list li a'
    marketGroupItemLi: '.market-header .currency-list li'
    marketsTable: '.table.markets'
    searchBox: 'input.search-box-top'
    activeMarketGroupItem: '.market-header .currency-list li a.active'

  @switchMarketGroup = (event, item) ->
    item = $(event.target).closest('a')
    name = item.data('name')

    if name is 'all'
      $('.markets-toggle').removeClass('hide')
    else
      $('.markets-toggle').addClass('hide')
      $('.markets-toggle[data-quote-unit="' + name + '"]').removeClass('hide')
      $('.markets-toggle[data-base-unit="' + name + '"]').removeClass('hide')

    @select('marketGroupItem').removeClass('active')
    @select('marketGroupItemLi').removeClass('active')
    item.addClass('active')
    item.parent().addClass('active')

    @select('marketGroupName').text item.find('span').text()

  @searchMarkets = (event) ->
    if event.target.value != ''
      $('.markets-toggle').addClass('hide')
      $('.markets-toggle').filter (i, mrktTr) ->
        if mrktTr.getAttribute('data-market').includes(event.target.value.toLowerCase())
          $(mrktTr).removeClass('hide')
    else
      @select('activeMarketGroupItem').click()


  @updateMarket = (select, ticker) ->
    trend = formatter.trend ticker.last_trend

    select.find('td.price')
      .attr('title', ticker.last)
      .html("<span class='#{trend}'>#{formatter.ticker_price ticker.last}</span>")

    p1 = parseFloat(ticker.open)
    p2 = parseFloat(ticker.last)
    trend = formatter.trend(p1 <= p2)
    select.find('td.change').html("<span class='#{trend}'>#{formatter.price_change(p1, p2)}%</span>")

  @refresh = (event, data) ->
    table = @select('table')
    for ticker in data.tickers
      @updateMarket table.find("tr#market-list-#{ticker.market}"), ticker.data

    table.find("tr#market-list-#{gon.market.id}").addClass 'highlight'

  @after 'initialize', ->
    @on document, 'market::tickers', @refresh
    @on @select('marketGroupItem'), 'click', @switchMarketGroup

    @on @select('searchBox'), 'keyup', @searchMarkets

    @select('table').on 'click', 'tr', (e) ->
      unless e.target.nodeName == 'I'
        window.location.href = window.formatter.market_url($(@).data('market'))

    @.hide_accounts = $('tr.hide')
    $('.view_all_accounts').on 'click', (e) =>
      $el = $(e.currentTarget)
      if @.hide_accounts.hasClass('hide')
        $el.text($el.data('hide-text'))
        @.hide_accounts.removeClass('hide')
      else
        $el.text($el.data('show-text'))
        @.hide_accounts.addClass('hide')
