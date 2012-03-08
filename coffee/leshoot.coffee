class Target
  thata = null
  thatb = null
  thatc = null
  score = 0

  constructor: (@raphObject,@center,@radio,@points) ->

  isHit: (hit) ->

  getScore: () ->
    @score

  draw: () ->
    @thata = @raphObject.circle(@center.x, @center.y, @radio)
    @thata.attr({"fill": "white", "stroke": "none"})
    @thatb = @raphObject.circle(@center.x, @center.y, @reduceRadio(@radio, 40))
    @thatb.attr({"fill": "blue"})
    @thatc = @raphObject.circle(@center.x, @center.y, @reduceRadio(@radio, 80))
    @thatc.attr({"fill": "red"})
    $this = this
    @thata.click( ->
      $this.score = $this.points[0]
      $this.hideAll()
    )
    @thatb.click( ->
      $this.score = $this.points[1]
      $this.hideAll()
    )
    @thatc.click( ->
      $this.score = $this.points[2]
      $this.hideAll()
    )

  reduceRadio: (r,per) ->
    r - r*(per/100)

  hideAll: () ->
    @thata.animate({"opacity": 0.0},1000)
    @thatb.animate({"opacity": 0.0},1000)
    @thatc.animate({"opacity": 0.0},1000)
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

    @addTarget(new Target(@canvas,{x:20,y:20},10, [10,20,50]))
    @addTarget(new Target(@canvas,{x:200,y:120},30, [10,20,50]))
    @addTarget(new Target(@canvas,{x:400,y:40},20, [10,20,50]))
    @addTarget(new Target(@canvas,{x:110,y:330},40, [10,20,50]))
    @addTarget(new Target(@canvas,{x:410,y:220},50, [10,20,50]))
    
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
