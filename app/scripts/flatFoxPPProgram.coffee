class FlatFoxPPProgram extends FlatFoxProgram

  constructor: (w = 1, h = 1) ->
    @memory = (BigInteger(0) for i in [1..6])
    @savedMemory = @memory[..]
    @program = []
    @resizeProgram(w, h)
    @reset()
    @message = @getStatusMessage()

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
              ((t[0] in "R") and (not t[1] in "0<>^v+-")) or
              ((t[0] in "GBCMY") and (not t[1] in "ASDML0<>^v+-")) or
              ((t[0] in " ") and (not t[1] in "o.@#<>^v"))
            @message = { text: "Chybny retezec '#{ t }' v nacitanem programu.", type: "error" }
            return false
          @setTile(x, @h - 1, t[0], t[1])
          x += 1
    @savedMemory = (BigInteger.ZERO for i in [1..6])
    @reset()
    @message = { text: "Nacten program #{ @w }x#{ @h }.", type: "success" }
    return true
 
  step: ->
    if not @running then @startRun()
    if not @running then return
    if @finished then return
    @breakpoint = undefined
    @steps += 1

    console.log @

    tile = @getTile @headX, @headY
    s = tile.symbol
    c = tile.color
    ci = @colorIndex c

    if s in "^v><"
      if c == " " or @memory[ci].isZero()
        switch s
          when "^" then [@dx, @dy] = [0, -1]
          when "v" then [@dx, @dy] = [0, 1]
          when ">" then [@dx, @dy] = [1, 0]
          when "<" then [@dx, @dy] = [-1, 0]

    if s == "+"
      @memory[ci] = @memory[ci].add(1)
    if s == "-"
      @memory[ci] = @memory[ci].subtract(1)
      if @memory[ci].isNegative() then @memory[ci] = BigInteger.ZERO
    if s == "0"
      @memory[ci] = BigInteger.ZERO
    if s == "A"
      @memory[0] = @memory[0].add(@memory[ci])
    if s == "S"
      @memory[ci] = @memory[ci].subtract(@memory[ci])
      if @memory[ci].isNegative() then @memory[ci] = BigInteger.ZERO
    if s == "M"
      @memory[0] = @memory[0].multiply(@memory[ci])
    if s == "D"
      if @memory[ci] > 0
        [@memory[ci], @memory[0]] = @memory[0].divRem(@memory[ci])
    if s == "L"
      @memory[ci] = @memory[0]

    if s == "#"
      @finished = true
    if s == "o"
      null # breakpoints handled below
        
    nx = @headX + @dx
    ny = @headY + @dy
    if (not @finished) and (nx >= 0) and (ny >= 0) and (nx < @w) and (ny < @h)
      @headX = nx
      @headY = ny
    else
      @finished = true

    newTile = @getTile @headX, @headY
    if newTile.symbol == "o"
      @breakpoint = true

  getStatusMessage: ->
    if @headX < 0
      return { text: "Chybi startovni pole (@).", type: "error" }
    
    if @finished
      return { text: "Program dobehl po #{ @steps } krocich.", type: "warning" }
    
    if @running
      return { text: "Program spusten, probehlo #{ @steps } kroku.", type: "success" }

    return { text: "FlatFox je placaty :-)", type: "info" }

      
if angular?
  angular.module('flatFoxApp').value('FlatFoxPPProgram', FlatFoxPPProgram)

