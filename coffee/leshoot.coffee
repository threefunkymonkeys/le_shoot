class Target
  score = 0
  destroyed = false

  constructor: (@raphObject,@center,@radio,@points) ->
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

    self = this
    raphOffset =
      x: @raphObject.canvas.offsetLeft
      y: @raphObject.canvas.offsetTop

    handler = @target.click( (eve) ->
      self.destroyed = true
      self.target.animate({"opacity": 0.0}, 1000, ">", ->
        self.target.remove()
      )
      pos = self.getCursorPosition(eve)
      self.calcScore({x: pos.x - raphOffset.x, y: pos.y - raphOffset.y})
      self.showScore()
    )
       

  getCursorPosition: (e) ->
    if e.pageX or e.pageY
      x = e.pageX
      y = e.pageY
    else 
      x = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
      y = e.clientY + document.body.scrollTop + document.documentElement.scrollTop
    
    return {x: x, y: y}
    
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

  constructor: (@canvas,size) ->
    
    self = this
    if size.width
      @boardSize.width = size.width
    if size.height
      @boardSize.height = size.height
     
    jailPos = 
      x: @boardSize.width - @jailSize.width - 30
      y: @boardSize.height - @jailSize.height - 30
    @jail = @canvas.rect(jailPos.x, jailPos.y, @jailSize.width, @jailSize.height, 10)
    @jail.attr({"stroke": "white", "stroke-width": 2, "stroke-dasharray": ".","fill": "white", "opacity": 0.5})
    @jail.hover( () ->
      self.jail.attr({"fill": "white", "opacity": 0.3})
      self.countDown()
    , () ->
      self.jail.attr({"fill": "white", "opacity": 0.5})
      if self.levelStart 
        self.jail.remove()
      else
        self.breakCountDown()
    , self
    , self
    )
    #@addTarget(new Target(@canvas,{x:20,y:20},10, [10,20,100]))
    #@addTarget(new Target(@canvas,{x:200,y:120},30, []))
    @addTarget(new Target(@canvas,{x:400,y:40},20, []))
    @addTarget(new Target(@canvas,{x:110,y:330},40, []))
    @addTarget(new Target(@canvas,{x:410,y:220},50, []))
    
    #@render("all")

  every: (ms,cb) -> setInterval cb, ms

  countDown: () ->
    self = this
    self.countDownObject = self.canvas.text(self.boardSize.width/2, self.boardSize.height/2, self.countDownCurrent)
    self.countDownObject.attr({"font-size": "50", "fill": "white"})
    self.countDownCurrent = parseInt(self.countDownCurrent) - 1  
    self.countDownTimer = self.every 1000, () ->
      if self.countDownCurrent == 0
        self.countDownCurrent = self.countDownMax
        self.countDownObject.attr({"font-size": "40", "fill": "white","text": "Kill them all!"}).animate({"opacity":0}, 1000,"linear", ->
          @remove()
        )
        clearInterval(self.countDownTimer)  
        self.levelStart = true
        self.render("all")
        self.gameTimerObject = self.canvas.text(70, self.boardSize.height - 20, "Time: 0.0")
        self.gameTimerObject.attr({"fill": "white", "font-size": "20"})
        self.loop = self.every 100, () -> 
          self.gameLoop()
      else
        self.countDownObject.attr("text", self.countDownCurrent )
        self.countDownCurrent = parseInt(self.countDownCurrent) - 1  
  
  breakCountDown: ->
    clearInterval(@countDownTimer)  
    @countDownObject.remove()
    soon = @canvas.text(@boardSize.width/2, @boardSize.height/2, "Too soon!")
    soon.attr({"font-size": "40", "fill": "white"}).animate({"opacity":0}, 1000,"linear", ->
      @remove()
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
      score = score / @gameTimer
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
  
  renderTargets: () ->

  removeTargets: () ->

  nextLevel: (num) ->

  showField: () ->

  hideField: () ->


draw = ->
  canvas = Raphael("canvas", 600, 400)
  try
    game = new LeShoot(canvas,{width:600,height:400})
  catch err
    console.log("Catch: #{err.message}")
