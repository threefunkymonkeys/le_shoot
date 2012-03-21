root = exports ? this

draw = ->
  canvas = Raphael("canvas", 600, 400)
  root.Canvas.get(canvas)
  try
    game = new LeShoot({width:600,height:400})
  catch err
    console.log("Catch: #{err.message}")

class root.Canvas
  _instance: undefined
  @get: (args) ->
    _instance ?= new _Canvas args

class _Canvas
  constructor: (@canvas) ->

  getCanvas: () ->
    @canvas
 
class Menu
  selection = -1

  constructor: () ->
    @canvas = root.Canvas.get().getCanvas()
    @menuItems = ["Play"]
    @menuObjects = []

  getSelection: ->
    @selection

  render: (@center) ->
    for item,i in @menuItems
      object = @canvas.text(@center.x, @center.y, item)
      object.attr({"fill": "white", "font-size": 50, "cursor": "hand"})
      object.click =>
        @selection = i
        console.log @selection

      object.hover( () ->
          this.attr({"opacity": 0.7})
        , () ->
          this.attr({"opacity": 1})
      )

      @menuObjects.push object

class Target
  score = 0
  destroyed = false

  constructor: (@center,@radio,@points) ->
    @raphObject = root.Canvas.get().getCanvas()
    if @points.length == 0
      @points = [10, 20, 50] #create a function to add points using radio

  getScore: () ->
    @score

  isDestroyed: () ->
    @destroyed

  draw: () ->
    thata = @raphObject.circle(@center.x, @center.y, @radio)
    thata.attr({"fill": "white", "stroke": "none"})
    thatb = @raphObject.circle(@center.x, @center.y, @reduceRadio(@radio, 40))
    thatb.attr({"fill": "blue"})
    thatc = @raphObject.circle(@center.x, @center.y, @reduceRadio(@radio, 80))
    thatc.attr({"fill": "red"})
    @target = @raphObject.set(thata, thatb,thatc)

    raphOffset =
      x: @raphObject.canvas.offsetLeft
      y: @raphObject.canvas.offsetTop
    
    dragStart = (x,y,eve) =>
      @destroyed = true
      @target.animate({"opacity": 0.0}, 1000, ">", =>
        @target.remove()
      )
      pos = @getCursorPosition(eve)
      @calcScore({x: pos.x - raphOffset.x, y: pos.y - raphOffset.y})
      @showScore()

    handler = @target.drag => 
        @destroyed = true
      , dragStart 
      , =>
        @destroyed = true

  getCursorPosition: (e) ->
    if e.pageX or e.pageY
      x = e.pageX
      y = e.pageY
    else 
      x = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
      y = e.clientY + document.body.scrollTop + document.documentElement.scrollTop
    {x: x, y: y}
    
  reduceRadio: (r,per) ->
    r - r*(per/100)

  getDistance: (p1,p2) ->
    Math.sqrt(Math.pow(p2.x-p1.x,2) + Math.pow(p2.y-p1.y,2))
  
  calcScore: (p) ->
    d = @getDistance(@center, p)
    r1 = @reduceRadio(@radio, 40)
    r2 = @reduceRadio(@radio, 80)

    if d > r1
      @score = @points[0]
    else if d > r2
      @score = @points[1]
    else 
      @score = @points[2]

  showScore: () ->
    text = @raphObject.text(@center.x,@center.y, @score)
    text.attr({"font-size": "12","font-weight":"bold","fill":"white"})

class LeShoot
  canvas: null      #store canvas
  jail: null
  startTarget: 2    #first level: 2 targets
  boardSize:        #board config
    width: 600
    height: 400
  jailSize:         #mouse jail size
    width: 75
    height: 75
  targets: []
  levelStart: false
  totalShots: 0
  countDownMax: 3
  countDownCurrent: 3
  countDownTimer: null
  countDownObject: null

  gameTimer: 0.0

  loop: null
  menu: null
  mLoop: null

  constructor: (size) ->
    @canvas = root.Canvas.get().getCanvas()
    if size.width
      @boardSize.width = size.width
    if size.height
      @boardSize.height = size.height
    @center = 
      x: @boardSize.width / 2
      y: @boardSize.height / 2

    @menu = new Menu()
    @renderMenu()
    @mLoop = @every 100, @menuLoop

  renderMenu: () ->
    @menu.render(@center) 

  menuLoop: () =>
    if @menu.getSelection() == 1
      @canvas.clear()
      clearInterval(@mLoop)
      @playLevel()


  playLevel: () ->
    jailPos = 
      x: @boardSize.width - @jailSize.width - 30
      y: @boardSize.height - @jailSize.height - 30

    @jail = @canvas.rect(jailPos.x, jailPos.y, @jailSize.width, @jailSize.height, 10)
    @jail.attr({"stroke": "white", "stroke-width": 2, "stroke-dasharray": ".","fill": "white", "opacity": 0.5})
    @jail.hover( () =>
      @jail.attr({"fill": "white", "opacity": 0.3})
      @countDown()
    , () =>
      @jail.attr({"fill": "white", "opacity": 0.5})
      if @levelStart 
        @jail.remove()
      else
        @breakCountDown()
    )
    @addTarget(new Target({x:20,y:20},10, [10,20,100]))
    @addTarget(new Target({x:200,y:120},30, []))
    @addTarget(new Target({x:500,y:40},20, []))
    @addTarget(new Target({x:110,y:330},40, []))
    @addTarget(new Target({x:300,y:270},50, []))
    
    #@render("all")

  every: (ms,cb) -> setInterval cb, ms

  countDown: () ->
    @countDownObject = @canvas.text(@boardSize.width/2, @boardSize.height/2, @countDownCurrent)
    @countDownObject.attr({"font-size": "50", "fill": "white"})
    @countDownCurrent = parseInt(@countDownCurrent) - 1  
    @countDownTimer = @every 1000, () =>
      if @countDownCurrent == 0
        @countDownCurrent = @countDownMax
        @render("all")
        @countDownObject.attr({"font-size": "40", "fill": "red","text": "Kill them all!"}).toFront().animate({"opacity":0}, 1000,"linear", ->
          this.remove()
        )
        clearInterval(@countDownTimer)  
        @levelStart = true
        @gameTimerObject = @canvas.text(70, @boardSize.height - 20, "Time: 0.0")
        @gameTimerObject.attr({"fill": "white", "font-size": "20"})
        @loop = @every 100, () => 
          @gameLoop()
      else
        @countDownObject.attr("text", @countDownCurrent )
        @countDownCurrent = parseInt(@countDownCurrent) - 1  
  
  breakCountDown: ->
    clearInterval(@countDownTimer)  
    @countDownObject.remove()
    soon = @canvas.text(@boardSize.width/2, @boardSize.height/2, "Too soon!")
    soon.attr({"font-size": "40", "fill": "white"}).animate({"opacity":0}, 1000,"linear", ->
      soon.remove()
    )
    @countDownCurrent = @countDownMax

  gameLoop: () ->
    @updateGameTimer()
    destroyed = 0
    for target in @targets  
      destroyed++ if target.isDestroyed()
    if @targets.length == destroyed
      clearInterval(@loop)
      @levelStart = false
      score = 0
      score += target.getScore() for target in @targets
      if @gameTimer >= @targets.length
        score -= 20
      else if @gameTimer > @targets.length*0.7  
        score += 20
      else
        score += 100
      score = score.toFixed(0)
      @canvas.clear()
      scoreText = @canvas.text(@boardSize.width/2, @boardSize.height/2, "Time: "+@gameTimer+ "\nScore: " + score)
      scoreText.attr({"fill": "white", "font-size": "50"})

  updateGameTimer: ->
    @gameTimer = parseFloat(@gameTimer) + 0.1
    @gameTimer = @gameTimer.toFixed(1)
    @gameTimerObject.attr("text", "Time: "+@gameTimer)

  render: (cant) ->
    if cant == "all"
      target.draw() for target in @targets

  addTarget: (target) ->
    @targets.push(target)
