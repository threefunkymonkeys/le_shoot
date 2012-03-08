class Target
  that = null

  constructor: (@raphObject,@center,@radio,@points) ->

  isHit: (hit) ->

  getScore: (hit) ->

  draw: () ->
    @that = @raphObject.circle(@center.x, @center.y, @radio)
    @that.attr({"fill": "white", "stroke": "none"})
    @that.click( ->
      @animate({"opacity": 0.0},1000)
    )

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

    @addTarget(new Target(@canvas,{x:20,y:20},10, 0))
    @addTarget(new Target(@canvas,{x:200,y:120},30, 0))
    @addTarget(new Target(@canvas,{x:400,y:40},20, 0))
    @addTarget(new Target(@canvas,{x:110,y:330},40, 0))
    @addTarget(new Target(@canvas,{x:410,y:220},50, 0))
    
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
