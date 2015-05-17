class Board
  constructor: (el, socket) ->
    @el = el
    @width = 0
    @height = 0
    @selecting = false
    @selected = {}

    $('body').on 'keydown', (evt) =>
      return unless evt.which == 16

      @selecting = true
      $(@el).addClass('selecting')

    $('body').on 'keyup', (evt) =>
      return unless evt.which == 16

      @selecting = false
      $(@el).removeClass('selecting')
      @activateSelected()

    $(el).on 'mousedown', 'td', (evt) =>
      @cellClicked(evt)

    $('body').on 'mouseup', 'td', (evt) =>
      @mousedown = false

    $('body').on 'mousedown', 'td', (evt) =>
      @mousedown = true

    $(el).on 'mouseover', 'td', (evt) =>
      return unless @mousedown
      @cellClicked(evt)

    socket.connect()
    socket.join("board:state", {}).receive "ok", (chan) =>
      @chan = chan
      chan.on "update", (payload) =>
        @update payload

  activateSelected: ->
    coords = []
    console.log @selected
    for x, ys of @selected
      for y,_ of ys
        coords.push [parseInt(x), parseInt(y)]

    @chan.push("activate_cells", coords)
    console.log coords

    @selected = {}
    $('td.selected').removeClass('selected').addClass('live')

  cellClicked: (evt) ->
    return unless @selecting

    cell = $(evt.target)
    cellData = cell.data()
    x = parseInt(cellData.x)
    y = parseInt(cellData.y) 
    @selected[x] ||= {}
    @selected[x][y] = true
    cell.addClass('selected')

  create: =>
    boardHtml = ""
    for y in [0..@height-1]
      boardHtml += "<tr>"

      for x in [0..@width-1]
        boardHtml += "<td data-x='#{x}' data-y='#{y}' id='x#{x}-y#{y}'> </td>"
      boardHtml += '</tr>'

    $(@el).html(boardHtml)

  update: (data) ->
    if data.width != @width or data.height != @height
      @width = data.width
      @height = data.height
      @create()

    $(@el).find('td').removeClass("live")
    for y in [0..@height-1]
      for x in [0..@width-1]
        cell = $(@el).find("td#x#{x}-y#{y}")
        if data.cells[y * @height + x]
          cell.addClass("live")
        if @selected[x]?[y]
          cell.addClass("selected")

$ ->
  socket = new Phoenix.Socket("/ws")
  board = new Board($('.board'), socket)

