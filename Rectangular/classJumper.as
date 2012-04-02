/* o-----------------o
 * | - RECTANGULAR - |
 * 0-----------------o
 * 
 * Jumper class. Apply to the character in order to give it gravity, movement and jumpiness.
 * 
 * 
 * TODO:
 * - Camera smoothing
 * - Camera looking left/right
 * - Fix death
 * FUTURE:
 * - Add parallax scrolling backgrounds
 * - Add life/health stuff
 */

class classJumper extends MovieClip {
	
	// Set up constants
	var gravity = 20;
	var maxJumpForce = 40;
	var walkVelocity = 10;
	var airDrag = 1.5; //  Make <1 in order to make air speed lower than ground speed
	
	var useCameraHorizontal = true;
	var useCameraVertical = false;
	
	// Set up controls
	var leftButton = Key.LEFT;
	var rightButton = Key.RIGHT;
	var jumpButton = Key.SPACE;
	
	// Set up variables
	var jumpForce;
	var falling;
	var inertia;
	var inAir;
	
	var moveX;
	var moveY;
	
	var downForce;
	var upForce;
	
	var mayJump;
	
	function onEnterFrame() {
		// Reset the forces
		downForce = 0;
		upForce = 0;
		moveX = 0;
		moveY = 0;
		
		inAir = true;
		
		// --- WALKING (X-movement)
		
		// Check for movement to the left; apply walkVelocity
		if (Key.isDown(leftButton)) {
			moveX -= walkVelocity;
		}
		
		// Check for movement to the right; apply walkVelocity
		if (Key.isDown(rightButton)) {
			moveX += walkVelocity;
		}
		
		
		// --- JUMPING AND FALLING (Y-movement)

		// Apply gravity
		downForce += gravity;

		// Check if jump button is pressed, and we've not begun falling
		if (Key.isDown(jumpButton) and not falling and mayJump) {
			// Reduce jump force
			jumpForce -= 2;
			
			// Add jump force if it's still higher than the gravity
			if (jumpForce >= gravity) {	
				upForce += jumpForce;
			}
		}
		
		// Set-up at beginning of fall
		if ((downForce > upForce) and not falling) {
			// Set falling
			falling = true;
			// Set initial inertia
			inertia = gravity;
		}
		
		// Reduce inertia and apply it, if we are falling
		if (falling) {
			if (inertia > 0) inertia -= 2;
			upForce += inertia;
		}
		
		
		moveY = downForce - upForce;
		
		// --- FINAL CHECKS ---

		// Apply air drag if we're in the air
		if (inAir) {
			// If in the air, air drag should be applied.
			moveX *= airDrag;
		}
		
		// Check if the jumper is interacting with any solid objects
		checkSolids();
		
		// Do hit checking
		hitChecks();

		
		// Apply camera movement if enabled
		if (useCameraHorizontal) {
			_root._x -= moveX;
		}

		if (useCameraVertical) {
			_root._y -= moveY;
		}
		

		// Apply final forces.
		_y += moveY;
		_x += moveX;

		// Animate
		animate();
		
	}
	
	function checkSolids() {
		
		// Go through all solids
		for (var solidnum in _root.solids) {
			
			// Use shorthand "s" for current solid
			var s = _root.solids[solidnum];
			
			// --- WALLS ---
			
			
			// Check if any of the right points are inside the solid
			
			// Top right point
			var overlapRight = s.hitPoint(_x + _width + moveX, _y + (_height*0.2));
			
			// Bottom right point
			if (not overlapRight) overlapRight = s.hitPoint(_x + _width + moveX, _y + (_height * 0.8));
			
			if (overlapRight) moveX -= overlapRight["x"];
			
			// Check if any of the left points are inside the solid
			
			// Top left point
			var overlapLeft = s.hitPoint(_x + moveX, _y + (_height *0.2));
			
			// Top right point
			if (not overlapLeft) {
				overlapLeft = s.hitPoint(_x + moveX, _y + (_height *0.8));
			}

			if (overlapLeft) moveX += (s._width - overlapLeft["x"]);
			// The part within parenthesis = the overlap from the right side (i.e. the overlap from the left subtracted from the width).
		
			
			// --- GROUND ---
			
			var overlap = s.hitPoint(_x+6, _y + _height + moveY); // Left foot point
			
			// If there is no left foot overlap
			if (not overlap) {
				overlap = s.hitPoint(_x-6 + _width, _y + _height + moveY); // Right foot point
			}
			
			// If any of the feet had overlap
			if (overlap) {
				// Apply normal force
				upForce = downForce;
				
				falling = false;
				
				jumpForce = maxJumpForce;
				
				// Do not move into the ground
				moveY = moveY - overlap["y"];
				
				inAir = false;
				
				// If the jump button is held down while character is on the ground, character should not jump.
				//  (fixes bouncing issue)
				if (Key.isDown(jumpButton)) {
					mayJump = false;
				} else {
					mayJump = true;
				}
				
			}
			
			// --- ROOF ---
			var overlap = s.hitPoint(_x+_width/2, _y+moveY); // Head point
			
			if (overlap) {
				falling = true;
				moveY += s._height - overlap["y"];
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
	
	// Extend this class and replace the animate method in order to 
	// animate the thing
	function animate() {
		
	}
	
	// Extend this class and replace the isHit method
	// in order to make something happen when the thing is hit
	function isHit(thing) {
		
	}
	
}