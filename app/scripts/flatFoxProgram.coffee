

class FlatFoxProgram
  defaultTile: {symbol: ".", color: " " }

  constructor: (w = 1, h = 1) ->
    @memory = [0, 0, 0, 0, 0, 0]
    @savedMemory = @memory[..]
    @program = []
    @resizeProgram(w, h)
    @reset()

  getTile: (x, y) ->
    row = @program[y]
    if not row? then return @defaultTile
    tile = row[x]
    if not tile? then return @defaultTile
    return tile

  setTile: (x, y, color, symbol) ->
    if x >= 0 and y >= 0 and x < @w and y < @h
      overwrite = (@program[y][x].symbol == "@")
      @program[y][x] = { symbol: symbol, color: color }
      if (symbol == "@") and (@headX >= 0) and ((@headX != x) or (@headY != y))
        @program[@headY][@headX] = @defaultTile
      if overwrite or (symbol == "@")
        [@headX, @headY] = @findStart()

  resizeProgram: (w, h) ->
    p2 = ([] for y in [0..(h-1)])
    for y in [0..(h-1)]
      for x in [0..(w-1)]
        p2[y].push @getTile(x, y)
    @w = w
    @h = h
    @program = p2
    [@headX, @headY] = @findStart()

  reset: ->
    @memory = @savedMemory[..]
    @steps = 0
    @running = false
    @finished = false
    [@headX, @headY] = @findStart()
    @dx = 1
    @dy = 0

  startRun: ->
    if @running then return
    @running = true

    @savedMemory = @memory[..]
    [@headX, @headY] = @findStart()
    if @headX < 0 then @running = false

  saveFile: ->
    b = new window.Blob([@programAsText()], {type: 'text/plain'})
    window.saveAs(b, "test.txt")

  tileToText: (t) -> t.color + t.symbol

  programAsText: ->
    ((@tileToText(@getTile(x,y)) for x in [0..(@w-1)]).join(" ") for y in [0..(@h-1)]).join("\n")

  loadFile: (evt) ->
    console.log evt
    # TODO
  
  findStart: ->
    for x in [0..(@w-1)]
      for y in [0..(@h-1)]
        if @getTile(x, y).symbol == '@' then return [x, y]
    return [-1, -1]

  colorIndex: (c) -> "RGBCMY".indexOf(c)

  step: ->
    if not @running then @startRun()
    if not @running then return
    if @finished then return
    @steps += 1

    tile = @getTile @headX, @headY
    s = tile.symbol
    c = tile.color
    ci = @colorIndex c

    if s in "^v><"
      if c == " " or @memory[ci] == 0
        switch s
          when "^" then [@dx, @dy] = [0, -1]
          when "v" then [@dx, @dy] = [0, 1]
          when ">" then [@dx, @dy] = [1, 0]
          when "<" then [@dx, @dy] = [-1, 0]

    if s == "+"
      @memory[ci] += 1
    if s == "-"
      if @memory[ci] > 0 then @memory[ci] -= 1
    if s == "#"
      @finished = true
        
    nx = @headX + @dx
    ny = @headY + @dy
    if (not @finished) and (nx >= 0) and (ny >= 0) and (nx < @w) and (ny < @h)
      @headX = nx
      @headY = ny
    else
      @finished = true

  statusMessage: ->
    if @headX < 0
      return { text: "Chybi startovni pole (@).", type: "error" }
    
    if @finished
      return { text: "Program dobehl po #{ @steps } krocich.", type: "warning" }
    
    if @running
      return { text: "Program spusten, probehlo #{ @steps } kroku.", type: "success" }

    return { text: "FlatFox je placaty :-)", type: "info" }

      
if angular?
  angular.module('flatFoxApp').value('FlatFoxProgram', FlatFoxProgram)

