class Board
  constructor: (el) ->
    @el = el
    @width = 0
    @height = 0

  create: =>
    boardHtml = ""
    for y in [0..@height-1]
      boardHtml += '<tr id="y'+y+'">'

      for x in [0..@width-1]
        boardHtml += '<td id="x'+x+'"> </td>'
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
        cell = $(@el).find("tr#y#{y} td#x#{x}")
        if data.cells[y * @height + x]
          cell.addClass("live")

$ ->
  board = new Board($('.board'))

  socket = new Phoenix.Socket("/ws")
  socket.connect()
  socket.join("board:state", {}).receive "ok", (chan) ->
    chan.on "update", (payload) ->
      board.update payload

