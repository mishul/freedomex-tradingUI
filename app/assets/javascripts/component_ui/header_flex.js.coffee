@HeaderFlexCoffee = flight.component ->
  @attributes
    marketsUl: 'ul'

  @setHeaderValues = (event, tickersData) ->
    for ticker in tickersData.tickers
      @marketLi = @select('marketsUl').find("li##{ticker.market}")
      if @marketLi.length > 0
        @setValuesNow ticker.data

  @setValuesNow = (marketTic) ->
    @marketLi.find('.lastTic').text marketTic.last
    @marketLi.find('.highTic').text marketTic.high
    @marketLi.find('.lowTic').text marketTic.low
    @marketLi.find('.volumeTic').text marketTic.volume
    changeData = @priceChange(marketTic)
    @marketLi.find('.changeTic').removeClass('text-up').removeClass('text-down').addClass(changeData.trend).text changeData.percent

  @priceChange = (marketTic) ->
    p1 = parseFloat marketTic.open
    p2 = parseFloat marketTic.last
    trend = formatter.trend(p1 <= p2)
    percent = if p1
                Math.round((100*(p2-p1)/p1) * 100) / 100
              else
                '0'
    return {percent: "#{percent}%", trend: trend}

  @after 'initialize', ->
    @on document, 'market::tickers', @setHeaderValues

