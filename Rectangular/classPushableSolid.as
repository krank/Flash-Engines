class classPushableSolid extends classSolid {
	
	var gravity:Number = 5; // Max fall speed. Set to 0 to disable gravity. 20 is default.
	var inertia:Number = 0; // Current inertia
	
	var visibleCheckers = true;
	
	var dirty:Boolean = true; // Remembers if something has changed
	
	var collisionChecker:MovieClip; // Movieclip used mainly for checking for bottom-collisions
	var sideChecker:MovieClip; // Movieclip used to check collisions left/right
	var vertChecker:MovieClip; // Movieclip used to check vertical collisions
	
	var allowLeft:Boolean = true; // Remembers whether left-movement is allowed
	var allowRight:Boolean = true; // Remembers whether right-movement is allowed
	
	var allowDown:Boolean = true;
	var allowUp:Boolean = true;
	
	var allowVerticalPush:Boolean = true;
	var allowHorizontalPush:Boolean = true;
	
	// Used to remember whether the block or the one colliding with it should move
	var thisMoveX:Boolean = true;
	var thisMoveY:Boolean = true;
	
	var moverTypes:String = "jumper enemy";
	
	var lastDirection = 0;
	var currentDirection = 0;
	
	var onGround:Boolean = false;
	
	
	function load() {
		// Create the main collision checker
		collisionChecker = createCollisionChecker(_x, _y, _width, _height, "collision" );
		// Create the side collision checker
		if (allowHorizontalPush) {
			sideChecker = createCollisionChecker(_x, _y + (0.10 * _height), 10, 0.80 * _height, "horizontal");
		}
		
		if (allowVerticalPush || gravity != 0) {
			vertChecker = createCollisionChecker(_x + (0.10 * _width), _y, 0.80 * _width, 10, "vertical");
		}
		
	}
	
	function effectOverlap(thing, overlapX, overlapY) {
		
		// Check if block is allowed to move in the direction it's pushed
		thisMoveX = false;
		thisMoveY = false;
		
		if (overlapX < 0 && allowRight && allowHorizontalPush) { // if going right, and is allowed to	
			thisMoveX = true;
		} else if (overlapX > 0 && allowLeft && allowHorizontalPush) { // if going left, and is allowed to
			thisMoveX = true;
		}
		
		if (overlapY < 0 && allowVerticalPush) { // if going right, and is allowed to	
			thisMoveY = true;
		} else if (overlapY > 0 && allowVerticalPush) { // if going left, and is allowed to
			thisMoveY = true;
		}
		
		
		// Move either the block or the pusher
		if (thisMoveX)    this._x -= overlapX;
		else              thing.moveX += overlapX;
		
		if (thisMoveY)    this._y -= overlapY;
		else              thing.moveY += overlapY;
		
		if (gravity && !onGround) {
			thing.moveY += gravity + inertia;
		}

		// Set block as dirty
		dirty = true;
		
		// Place sideChecker on right side if going right, and vice versa
		if (overlapX < 0) {
			sideChecker._x = _x + _width; // Going right
		} else if (overlapX > 0) {
			sideChecker._x = _x - sideChecker._width; // Going left
		}
		
		// Fix the Y
		//thing.moveY += overlapY;
		
	}
	
	function onEnterFrame() {
		
		if (!_root.paused) {
		
			// Check if there's any reason to suspect any change
			if (dirty) {
				
				
				
				
				
				// Reset the collision checker's x and y values to those of the block
				collisionChecker._x = _x;
				collisionChecker._y = _y;

				// Apply gravity and inertia to collisionChecker
				if (gravity > 0) collisionChecker._y += gravity - inertia;
				
				allowLeft = true;
				allowRight = true;
				
				onGround = false;
				
				// Check if collision checker collides with any of our friends
				for (var sNum in _root.solids) {
					var solid = _root.solids[sNum];
					if (solid != this) {
						if (this.collisionChecker.hitTest(solid)) {
							// Modify downward force accordingly
							var negY = collisionChecker._y + collisionChecker._height - solid._y;
							collisionChecker._y -= negY;
							dirty = false;
							onGround = true;
						}
						
						// check left/right collisions
						if (solid.hitTest(this.sideChecker)) {
							if (this.sideChecker._x > this._x) {
								allowRight = false;
							} else {
								allowLeft = false;
							}
						}
					}
				}
				
				this._y = collisionChecker._y;
				sideChecker._y = collisionChecker._y + collisionChecker._height * 0.10;
			}
			
			update();
		}
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
		c._visible = visibleCheckers;
		
		return c;
	}
	
	function update() {
		
	}
	
}