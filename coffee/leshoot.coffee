class Target
  contruct: (center,radio,points) ->
    @center = center
    @radio = radio
    @points = points

  isHit: (hit) ->

  getScore: (hit) ->

  draw: () ->
   

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

  constructor: (canvas,size) ->
    console.log(canvas)
    if canvas.canvas? and canvas.nodeName != "CANVAS" 
      throw "Missing Canvas object or canvas DOM node"
    @canvas = if canvas.nodeName? then canvas.getContext("2d") else canvas
    if size.width
      @boardSize.width = size.width
    if size.height
      @boardSize.height = size.height

    @canvas.beginPath()
    @canvas.arc(100,100,50,0, 2*Math.PI,true)
    @canvas.stroke()
    
    @canvas.beginPath()
    @canvas.arc(200,200,20,0, 2*Math.PI,true)
    @canvas.stroke()
  
  render: () ->

  addTarget: (target) ->
    @targets.push(target)
  
  renderTargets: () ->

  removeTargets: () ->

  nextLevel: (num) ->

  countDown: (max) ->
  
  showField: () ->

  hideField: () ->


draw = ->
  canvas = document.getElementById('le-shoot')
  try
    game = new LeShoot(canvas,{width:600,height:400});
  catch err
    console.log("Catch: #{err.message}")
