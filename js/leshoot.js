var LeShoot, Target, draw;

Target = (function() {

  function Target() {}

  Target.prototype.contruct = function(center, radio, points) {
    this.center = center;
    this.radio = radio;
    return this.points = points;
  };

  Target.prototype.isHit = function(hit) {};

  Target.prototype.getScore = function(hit) {};

  Target.prototype.draw = function() {};

  return Target;

})();

LeShoot = (function() {

  LeShoot.prototype.canvas = null;

  LeShoot.prototype.startTarget = 2;

  LeShoot.prototype.boardSize = {
    width: 600,
    height: 400
  };

  LeShoot.prototype.jailSize = {
    width: 50,
    height: 50
  };

  LeShoot.prototype.targets = [];

  function LeShoot(canvas, size) {
    console.log(canvas);
    if ((canvas.canvas != null) && canvas.nodeName !== "CANVAS") {
      throw "Missing Canvas object or canvas DOM node";
    }
    this.canvas = canvas.nodeName != null ? canvas.getContext("2d") : canvas;
    if (size.width) this.boardSize.width = size.width;
    if (size.height) this.boardSize.height = size.height;
    this.canvas.beginPath();
    this.canvas.arc(100, 100, 50, 0, 2 * Math.PI, true);
    this.canvas.stroke();
    this.canvas.beginPath();
    this.canvas.arc(200, 200, 20, 0, 2 * Math.PI, true);
    this.canvas.stroke();
  }

  LeShoot.prototype.render = function() {};

  LeShoot.prototype.addTarget = function(target) {
    return this.targets.push(target);
  };

  LeShoot.prototype.renderTargets = function() {};

  LeShoot.prototype.removeTargets = function() {};

  LeShoot.prototype.nextLevel = function(num) {};

  LeShoot.prototype.countDown = function(max) {};

  LeShoot.prototype.showField = function() {};

  LeShoot.prototype.hideField = function() {};

  return LeShoot;

})();

draw = function() {
  var canvas, game;
  canvas = document.getElementById('le-shoot');
  try {
    return game = new LeShoot(canvas, {
      width: 600,
      height: 400
    });
  } catch (err) {
    return console.log("Catch: " + err.message);
  }
};
