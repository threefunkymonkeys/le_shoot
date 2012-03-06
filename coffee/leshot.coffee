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

  construct: (canvas,size) ->
    if not canvas.canvas? or not canvas.nodeName is "CANVAS" 
      throw "Missing Canvas object or canvas DOM node"
    @canvas = if canvas.nodeName? then canvas.getContext("2d") else canvas

    if size.width
      @boardSize.width = size.width
    if size.height
      @boardSize.height = size.height

  render: () ->

  addTarget: (target) ->
    @targets.push(target)
  
  renderTargets: () ->

  removeTargets: () ->

  nextLevel: (num) ->

  countDown: (max) ->
  
  showField: () ->

  hideField: () ->
