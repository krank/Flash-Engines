/*    *----*
 *  /        \
 *  | - Circular -
 *  \        /
 *    *----*
 * 
 * classPointer
 * 
 * TODO:
 * - Shooting and whatnot
 * - Separate movement from rotation?
 * 
 */

class classPointer extends MovieClip {
	
	// SETTINGS
	
	// Walking speed
	var walkVelocity:Number = 10;

	// Keys to use
	var upKey:Number = 87;		//w
	var downKey:Number = 83;	//s
	var leftKey:Number = 65;	//a
	var rightKey:Number = 68;	//d
	
	// What to follow and look at
	var followPointer:Boolean = true;
	var lookAtPointer:Boolean = true;
	var moveKeys:Boolean = false; // Overrides followPointer when true
	var deadzone:Number = 15 // only used when following pointer
	
	// Camera following
	var cameraFollowVertical:Boolean = true;
	var cameraFollowHorizontal:Boolean = true;
	
	// Set to the radius used for collision detection (assuming round symbol)
	var radius:Number = 25;
	
	
	// VARIABLES
	
	// Remembers the rotation direction
	var look_degrees:Number;
	var look_radians:Number;
	// Remembers the movement direction
	var move_degrees:Number;
	var move_radians:Number;
	
	// Remembers the movement
	var moveX:Number;
	var moveY:Number;
	
	// Remembers the distance between pointer and center of pointer
	var distance:Number;
	
	// Remembers the current media trigger when going through the stack
	var mediaTrigger:classMediaTrigger;
	
	
	
	function onEnterFrame() {

		if (!_root.paused) {
		
			// Reset things
			moveX = 0;
			moveY = 0;
			look_degrees = 0;
			move_degrees = 0;
			
			// --- MOVEMENT ---
			
			if (moveKeys) {
				if (Key.isDown(leftKey)) moveX -= walkVelocity;
				if (Key.isDown(rightKey)) moveX += walkVelocity;
				if (Key.isDown(upKey)) moveY -= walkVelocity;
				if (Key.isDown(downKey)) moveY += walkVelocity;
			} else if (followPointer) {
				var o = _root._xmouse - _x;
				var a = _root._ymouse - _y;
				
				// Get the radians based on arctan of a, o
				move_radians = Math.atan2(a, o);
				
				// Calculate the degrees
				move_degrees = move_radians * (180 / Math.PI)
				
				distance = Math.sqrt(Math.pow(_xmouse, 2) + Math.pow(_ymouse, 2));
				
				if (distance > 15) {
					// Calculate moveX and moveY
					moveX = Math.cos(move_radians) * walkVelocity;
					moveY = Math.sin(move_radians) * walkVelocity;
				}
			}
			
			// --- ROTATION ---
			
			// get the opposite and adjacent sides
			if (lookAtPointer) {
				var o = _root._xmouse - _x;
				var a = _root._ymouse - _y;
			} else {
				var o = moveX;
				var a = moveY;
			}
			
			look_radians = Math.atan2(a, o);
			look_degrees = look_radians * (180 / Math.PI);
			
			// --- SHOOTING THINGS ---
			
			// Not done yet
			
			// --- COLLISIONS ---
			
			checkSolids();
			hitChecks();
			
			// --- CAMERA ---
			
			if (cameraFollowHorizontal) _root._x -= moveX;
			
			if (cameraFollowVertical) _root._y -= moveY;
			
			// --- MEDIA TRIGGERS
			
			checkMediaTriggers();
			
			// --- UPDATE
			
			update();
			
			// --- FINALIZE ---
			
			_x += moveX;
			_y += moveY;
			
			if (lookAtPointer) {
				_rotation = look_degrees;
			}
		}
	}
	
	function checkMediaTriggers() {
		for (var triggerNum in _root.mediaTriggers) {
			mediaTrigger = _root.mediaTriggers[triggerNum];
			
			if (this.hitTest(mediaTrigger)) {
				mediaTrigger.activate();
			}
			
		}
	}
	
	function checkSolids() {
		
		// Set hypotheticals; if current move is done, what would be the x and y?
		var hypotheticalX = _x + moveX;
		var hypotheticalY = _y + moveY;
		
		// Set "sides" as if the character was basically rectangular
		var rightSide = hypotheticalX + radius;
		var leftSide = hypotheticalX - radius;
		var topSide = hypotheticalY - radius;
		var bottomSide = hypotheticalY + radius;
		
		// Go through all the solids
		for (var solid in _root.solids) {
			var block = _root.solids[solid];
			
			// X-axis
			if (moveX > 0) {
				// Upper right point
				var overlapX = block.hitPoint(rightSide, hypotheticalY - radius / 1.5);
				// Lower right point
				if (not overlapX) overlapX = block.hitPoint(rightSide, hypotheticalY + radius / 1.5);
				
				
				if (overlapX) {
					moveX -= overlapX;
				}

			} else if (moveX < 0) {
				
				// Upper left point
				var overlapX = block.hitPoint(leftSide, hypotheticalY - radius / 1.5);
				// Lower left point
				if (not overlapX) overlapX = block.hitPoint(leftSide, hypotheticalY + radius / 1.5);
				
				if (overlapX) {
					moveX += block.width - overlapX;
				}
			}
			
			// Y-axis
			if (moveY > 0) {
				// Lower left point
				var overlapY = block.hitPoint(hypotheticalX - radius / 1.5, bottomSide);
				// Lower right point
				if (not overlapY) overlapY = block.hitPoint(hypotheticalX + radius / 1.5, bottomSide);

				if (overlapY) {
					moveY -= overlapY;
				}

			} else if (moveY < 0) {
				
				// Top left point
				var overlapY = block.hitPoint(hypotheticalX - radius / 1.5, topSide);
				// Top right point
				if (not overlapY) overlapY = block.hitPoint(hypotheticalX + radius / 1.5, topSide);

				if (overlapY) {
					moveY += block.height - overlapY;
				}
			}
			
			

		}
	}

	function hitChecks() {
		// If there are unfriendlies...
		if (_root.unFriendlies) {
			// Go through all unfriendlies
			for (var unFriendlyNum in _root.unFriendlies) {
				
				// Check if the unFriendly thing hits this
				var unFriendly = _root.unFriendlies[unFriendlyNum];
				if (this.hitTest(unFriendly)) {
					
					// Use each things isHit
					this.isHit(unFriendly);
					unFriendly.isHit(this);
				}
			}
		}
	}
	
	function isHit(thing) {}
	
	function update() {}
	
}