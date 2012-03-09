class Target
  score = 0

  constructor: (@raphObject,@center,@radio,@points) ->
    if @points.length == 0
      @points = [10, 20, 50] #create a function to add points using radio

  getScore: () ->
    @score

  draw: () ->
    thata = @raphObject.circle(@center.x, @center.y, @radio)
    thata.attr({"fill": "white", "stroke": "none"})
    thatb = @raphObject.circle(@center.x, @center.y, @reduceRadio(@radio, 40))
    thatb.attr({"fill": "blue"})
    thatc = @raphObject.circle(@center.x, @center.y, @reduceRadio(@radio, 80))
    thatc.attr({"fill": "red"})
    @target = @raphObject.set(thata, thatb,thatc)

    th = this
    raphOffset =
      x: @raphObject.canvas.offsetLeft
      y: @raphObject.canvas.offsetTop

    handler = @target.click( (eve) ->
      th.target.animate({"opacity": 0.0}, 500)
      pos = th.getCursorPosition(eve)
      th.calcScore({x: pos.x - raphOffset.x, y: pos.y - raphOffset.y})
      th.showScore()
      th.target.remove()
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
    console.log d
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
  startTarget: 2    #first level: 2 targets
  boardSize:        #board config
    width: 600
    height: 400
  jailSize:         #mouse jail size
    width: 50
    height: 50
  targets: []

  constructor: (@canvas,size) ->
    if size.width
      @boardSize.width = size.width
    if size.height
      @boardSize.height = size.height

    @addTarget(new Target(@canvas,{x:20,y:20},10, [10,20,100]))
    @addTarget(new Target(@canvas,{x:200,y:120},30, []))
    @addTarget(new Target(@canvas,{x:400,y:40},20, []))
    @addTarget(new Target(@canvas,{x:110,y:330},40, []))
    @addTarget(new Target(@canvas,{x:410,y:220},50, []))
    
    @render("all")

  render: (cant) ->
    if cant == "all"
      target.draw() for target in @targets

  addTarget: (target) ->
    @targets.push(target)
  
  renderTargets: () ->

  removeTargets: () ->

  nextLevel: (num) ->

  countDown: (max) ->
  
  showField: () ->

  hideField: () ->


draw = ->
  canvas = Raphael("canvas", 600, 400)
  try
    game = new LeShoot(canvas,{width:600,height:400})
  catch err
    console.log("Catch: #{err.message}")
