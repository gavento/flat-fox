

class FlatFoxProgram
  defaultTile: {symbol: ".", color: " " }

  constructor: (w = 1, h = 1) ->
    @memory = [0, 0, 0, 0, 0, 0]
    @savedMemory = @memory[..]
    @program = []
    @resizeProgram(w, h)
    @reset()
    @message = @getStatusMessage()

  # Return a stopped copy of @
  copy: ->
    ffp = new FlatFoxProgram(@w, @h)
    ffp.memory = if @running then @savedMemory[..] else @memory[..]
    ffp.savedMemory = ffp.memory[..]
    for y in [0..(@h-1)]
      for x in [0..(@w-1)]
        t = @getTile x, y
        ffp.setTile x, y, t.color, t.symbol
    return ffp

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
    if w > 0 and h > 0
      for y in [0..(h-1)]
        for x in [0..(w-1)]
          p2[y].push @getTile(x, y)
    @w = w
    @h = h
    @program = p2
    [@headX, @headY] = @findStart()
    if @tracksIn? then @computeTracks()

  computeTracks: () ->
    # arrays[y][x] of bitflags for active entering and leaving directions
    @tracksIn = ((0 for x in [0..(@w-1)]) for y in [0..(@h-1)])
    @tracksOut = ((0 for x in [0..(@w-1)]) for y in [0..(@h-1)])

    # d = 0 (up) .. 3 (left)
    opposite = (d) -> (d + 2) % 4
    pow = (d) -> 1 << d
    dx = [0, 1, 0, -1]
    dy = [-1, 0, 1, 0]

    rec = (x, y, d) =>
      if x < 0 or y < 0 or x >= @w or y >= @h or (@tracksIn[y][x] & pow(opposite(d)))
        return
      @tracksIn[y][x] |= pow(opposite(d))
      sym = @getTile(x, y).symbol
      col = @getTile(x, y).color
      if sym == '#'
        return
      if sym in '<>^v'
        nd = '^>v<'.indexOf(sym)
        @tracksOut[y][x] |= pow(nd)
        rec(x + dx[nd], y + dy[nd], nd)
      if sym not in '<>^v' or col != ' '
        @tracksOut[y][x] |= pow(d)
        rec(x + dx[d], y + dy[d], d)

    for x in [0..(@w-1)]
      for y in [0..(@h-1)]
        sym = @getTile(x, y).symbol
        if sym in '<>^v'
          nd = '^>v<'.indexOf(sym)
          @tracksOut[y][x] |= pow(nd)
          rec(x + dx[nd], y + dy[nd], nd)
        if sym == '@'
          nd = 1
          @tracksOut[y][x] |= pow(nd)
          rec(x + dx[nd], y + dy[nd], nd)

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

  tileToText: (t) -> t.color + t.symbol

  programAsText: ->
    ((@tileToText(@getTile(x,y)) for x in [0..(@w-1)]).join(" ") for y in [0..(@h-1)]).join("\n") + "\n"

  parseText: (text) ->
    @resizeProgram(0, 0)
    lines = text.split(new RegExp("[\n\r]+")) # paranoid about separators ;-)
    for l in lines
      tokens = l.split(new RegExp("[\t ]+"))
      x = 0
      for t in tokens
        if t != ""
          if x == 0 # new non-empty line
            @resizeProgram(@w, @h + 1)
          if x >= @w
            @resizeProgram(x + 1, @h)
          if t.length == 1
            t = " " + t
          if (t.length > 2) or
              (not t[0] in "RGBCMY ") or
              ((t[0] in "RGBCMY") and (not t[1] in "<>^v+-")) or
              ((t[0] == " ") and (not t[1] in ".@#<>^v"))
            @message = { text: "Chybny retezec '#{ t }' v nacitanem programu.", type: "error" }
            return false
          @setTile(x, @h - 1, t[0], t[1])
          x += 1
    @savedMemory = [0, 0, 0, 0, 0, 0]
    @reset()
    @message = { text: "Nacten program #{ @w }x#{ @h }.", type: "success" }
    return true
 
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

  getStatusMessage: ->
    if @headX < 0
      return { text: "Chybi startovni pole (@).", type: "error" }
    
    if @finished
      return { text: "Program dobehl po #{ @steps } krocich.", type: "warning" }
    
    if @running
      return { text: "Program spusten, probehlo #{ @steps } kroku.", type: "success" }

    return { text: "FlatFox je placaty :-)", type: "info" }

      
if angular?
  angular.module('flatFoxApp').value('FlatFoxProgram', FlatFoxProgram)

window.FlatFoxProgram = FlatFoxProgram # hacky hacky

