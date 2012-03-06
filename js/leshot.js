(function() {
  var LeShoot, Target;

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

    function LeShoot() {}

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

    LeShoot.prototype.construct = function(canvas, size) {
      if (!(canvas.canvas != null) || !canvas.nodeName === "CANVAS") {
        throw "Missing Canvas object or canvas DOM node";
      }
      this.canvas = canvas.nodeName != null ? canvas.getContext("2d") : canvas;
      if (size.width) this.boardSize.width = size.width;
      if (size.height) return this.boardSize.height = size.height;
    };

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

}).call(this);
