class classPushableSolid extends classSolid {
	
	var gravity:Number = 20;
	var falling:Boolean = false;
	var inertia:Number = 0;
	
	var applyGravity:Boolean = true;
	
	var downForce:Number;
	var upForce:Number;
	
	var dirty:Boolean = false;
	
	var collisionChecker:MovieClip;
	var sideChecker:MovieClip;
	
	var moveX:Number = 0;
	
	function load() {
		collisionChecker = createCollisionChecker(_x, _y, _width, _height );
		
		sideChecker = createCollisionChecker(_x, _y + (0.10 * _height), 10, 0.80 * _height);
	}
	
	function effectOverlap(thing, overlap) {
		
		this._x -= overlap;
		dirty = true;
		
		if (overlap < 0) { // if going to right
			sideChecker._x = _x + _width;
		} else {
			sideChecker._x = _x - sideChecker._width;
		}
		
		// This needs a checker for collisions left/right...
	}
	
	function collideSolids() {
		for (var sNum in _root.solids) {
			var solid = _root.solids[sNum];
			if (solid != this) {
				if (this.collisionChecker.hitTest(solid)) {
					return true;
				}
			}
		}
		
		return false;
		
	}
	
	function onEnterFrame() {

		//trace(collideSolids());
		
		// Move some of this to effectOverlap? Or have permanent variables stating current state of collisions left/right?
		
		if (dirty) {
			// Apply gravity and inertia to collision checker
			collisionChecker._y = _y + gravity - inertia;
			collisionChecker._x = _x;

			// Check if collision checker collides with any of our friends
			for (var sNum in _root.solids) {
				var solid = _root.solids[sNum];
				if (solid != this) {
					if (this.collisionChecker.hitTest(solid)) {
						// Modify downward force accordingly
						var negY = collisionChecker._y + collisionChecker._height - solid._y;
						collisionChecker._y -= negY;
						dirty = false;
						falling = false;
					}
				}
			}
			
			if (this._y < collisionChecker._y) {
				this._y = collisionChecker._y;
				sideChecker._y = collisionChecker._y + collisionChecker._height * 0.10;
			}
			
		} else {
			collisionChecker._y = _y-1;
			collisionChecker._x = _x;
		}
		
		//sideChecker._x = _x;
		//sideChecker._y = _y;
		
	}

	// Create a collision checker movieclip
	function createCollisionChecker(xPos:Number, yPos:Number, width:Number, height:Number, ident:String) {

		var w:Number = width;
		var h:Number = height;
		
		var depth:Number = _root.getNextHighestDepth();
		var c = _root.createEmptyMovieClip(ident, depth);
		
		// Draw
		c.beginFill(0x333333);
		c.lineTo(w, 0);
		c.lineTo(w, h);
		c.lineTo(0, h);
		c.lineTo(0, 0);
		c.endFill();
		
		c._x = xPos;
		c._y = yPos;
		c._visible = true;
		c._alpha = 50;
		
		return c;
	}
	
	
	
}