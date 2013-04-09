class classPushableSolid extends classSolid {
	
	var gravity:Number = 20;
	var falling:Boolean = false;
	var inertia:Number = 0;
	
	var applyGravity:Boolean = true;
	
	var downForce:Number;
	var upForce:Number;
	
	var dirty:Boolean = false;
	
	var collisionChecker:MovieClip;
	
	function load() {
		createCollisionChecker();
	}
	
	function effectOverlap(thing, overlap) {
		this._x -= overlap;
		dirty = true;
		
		// This needs a checker for collisions left/right...
	}
	
	function onEnterFrame() {
		
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
						var neg = collisionChecker._y + collisionChecker._height - solid._y;
						collisionChecker._y -= neg;
						dirty = false;
						falling = false;
					}
				}
			}
			
			if (this._y < collisionChecker._y) {
				this._y = collisionChecker._y;
				
			}
			
		}
		
	}

	// Create a collision checker movieclip
	function createCollisionChecker() {
		var w:Number = this._width;
		var h:Number = this._height;
		
		var depth:Number = this.getNextHighestDepth()
		this.collisionChecker = _root.createEmptyMovieClip("checker", depth);
		
		// Draw
		this.collisionChecker.beginFill(0x333333);
		this.collisionChecker.lineTo(w, 0);
		this.collisionChecker.lineTo(w, h);
		this.collisionChecker.lineTo(0, h);
		this.collisionChecker.lineTo(0, 0);
		this.collisionChecker.endFill();
		
		this.collisionChecker._x = _x;
		this.collisionChecker._y = _y;
		this.collisionChecker._visible = true;
		this.collisionChecker._alpha = 0;
		
		this.hitArea = this.collisionChecker;
		
	}
	
}