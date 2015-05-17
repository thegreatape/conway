class Board
  constructor: (el, height, width) ->
    this.el = el
    this.height = height
    this.width = width

    boardHtml = ""
    for y in [0..height-1]
      boardHtml += '<tr class="y'+y+'">'

      for x in [0..width-1]
        boardHtml += '<td class="x'+x+'"> </td>'
      boardHtml += '</tr>'

    $(el).html(boardHtml)

  update: (data) ->

$ ->
  board = new Board($('.board'), 5, 5)

  socket = new Phoenix.Socket("/ws")
  socket.connect()
  socket.join("board:state", {}).receive "ok", (chan) ->
    chan.on "update", (payload) ->
      board.update payload

