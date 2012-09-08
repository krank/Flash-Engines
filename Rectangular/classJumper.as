﻿/* o-----------------o
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
	
	// Creature type
	var type = "jumper";
	
	// Set up constants
	var gravity = 20;
	var maxJumpForce = 40;
	var walkVelocity = 10;
	var airDrag = 1.5; //  Make <1 in order to make air speed lower than ground speed
	
	var useCameraHorizontal = true;
	var useCameraVertical = false;
	
	var useWallFriction = true;
	
	// Set up point positions
	var topSidePoints = 0.2;
	var bottomSidePoints = 0.8;
	
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
	
	var overlap;
	
	var lastDirection;
	
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
			lastDirection = -1;
		}
		
		// Check for movement to the right; apply walkVelocity
		if (Key.isDown(rightButton)) {
			moveX += walkVelocity;
			lastDirection = 1;
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
		
		// Calculate total Y-movement
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
			
			// Static elements should not move
			for (var i in _root.statics) {
				_root.statics[i]._x += moveX;
			}
		}

		if (useCameraVertical) {
			_root._y -= moveY;
			// Static elements should not move
			for (var i in _root.statics) {
				_root.statics[i]._y += moveY;
			}
		}
		

		// Apply final forces.
		_y += moveY;
		_x += moveX;

		// User-defined update()
		update();
		
	}
	
	function checkSolids() {

		// Go through all resistances
		for (var modnum in _root.modifiers) {
			// Get a shorthand for refering to each resistance block
			var modifier:classModifier = _root.modifiers[modnum];
			
			// Make bottom/top checks
			var overlapBottom = checkBottom(modifier);
			var overlapTop = checkUp(modifier);
			
			// If either top or bottom collides with the block, apply resistances.
			if (overlapBottom or overlapTop) {
				if (falling) moveY *= modifier.verticalModifier;
				else moveY *= modifier.jumpModifier;
			}
			
			// Make left/right checks
			var overlapLeft = checkLeft(modifier);
			var overlapRight = checkLeft(modifier);
			
			// If either left or right overlaps with the block, apply resistance.
			if (overlapLeft or overlapRight) {
				moveX *= modifier.horizontalModifier;
			}
			
		}
		
		// Go through all solids
		for (var solidnum in _root.solids) {
			
			// Use shorthand "s" for current solid
			var s = _root.solids[solidnum];
			
			// --- WALLS ---

			// Check if any of the right points are inside the solid
			
			if (moveX >= 0) {
				var overlapRight = checkRight(s);
				// Negate just enough movement to keep the jumper outside of the solid
				if (overlapRight) moveX -= overlapRight["x"];
			}
			
			// Check if any of the left points are inside the solid
			
			if (moveX <= 0) {
				var overlapLeft = checkLeft(s);
				// Negate just enough movement to keep the jumper outside of the solid
				if (overlapLeft) moveX += (s._width - overlapLeft["x"]);
			}
			// The part within parenthesis = the overlap from the right side (i.e. the overlap from the left subtracted from the width).
			
			// --- WALL FRICTION ---
			
			//If there is left/right overlap and we are falling
			if ((overlapLeft or overlapRight) and falling and useWallFriction) {
				// Only apply friction it it has not already been applied, or if the applied friction is lower 
				// than the new one. Always use the HIGHEST friction!
				if (not wallFriction or wallFriction < s.sideFriction) {
					// Set the friction based on the block we're colliding with
					var wallFriction = s.sideFriction;
				}
			}
			
			// --- GROUND ---
			
			overlap = checkBottom(s);
			
			// If any of the feet had overlap
			if (overlap) {
				
				// Stop falling and reset jumpforce
				falling = false;
				jumpForce = maxJumpForce;
				inAir = false;
				
				// Do not move into the ground
				moveY -= overlap["y"];
				
				// If the jump button is held down while character is on the ground, character should not jump.
				//  (fixes bouncing issue)
				if (Key.isDown(jumpButton)) {
					mayJump = false;
				} else {
					mayJump = true;
				}
				
			}
			
			// --- ROOF ---
			overlap = checkUp(s) // Head point
			
			if (overlap) {
				s.effectBottom(this);
			}
			
		}

		// --- APPLY WALL FRICTION ---
		
		if (wallFriction) {
			moveY -= moveY * wallFriction;
		}
	}
	
	
	function checkBottom(thing:MovieClip) {
		
		// Left foot point
		var overlap = thing.hitPoint(_x+6, _y + _height + moveY); 
			
		// If there is no left foot overlap
		if (not overlap) {
			// Right foot point
			overlap = thing.hitPoint(_x-6 + _width, _y + _height + moveY);
		}
		
		return overlap;
	}
	
	function checkLeft(item:MovieClip) {
		// Top left point
		var overlapLeft = item.hitPoint(_x + moveX, _y + (_height * topSidePoints));
			
		// Top right point
		if (not overlapLeft) {
			overlapLeft = item.hitPoint(_x + moveX, _y + (_height * bottomSidePoints));
		}
		
		return overlapLeft;
	}
	
	function checkRight(item:MovieClip) {
		// Top right point
		var overlapRight = item.hitPoint(_x + _width + moveX, _y + (_height * topSidePoints));
		
		// Bottom right point
		if (not overlapRight) overlapRight = item.hitPoint(_x + _width + moveX, _y + (_height * bottomSidePoints));
		
		return overlapRight;
	}
	
	function checkUp(item:MovieClip) {
		return item.hitPoint(_x+_width/2, _y+moveY); // Head point
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
		
		// If there are teleports...
		if (_root.teleports) {
			// Go through all teleports
			for (var teleportNum in _root.teleports) {
				
				// Check if the teleport hits us
				var teleport = _root.teleports[teleportNum];
				if (this.hitTest(teleport)) {
					
					// Get the name of the teleport; will also be used as name for target.
					var targetName = teleport._name;
					
					// Find the target, if it exists
					var targetObject = false;
					
					for (var targetNum in _root.targets) {
						if (_root.targets[targetNum]._name == targetName) {
							targetObject = _root.targets[targetNum];
						}
					}
					
					// See if a target object has been found
					if (!targetObject) {
						// If not, try to go to the frame using the same name instead
						_root.gotoAndStop(targetName);
					} else {
					
						// Get difference in coordinates
						var travelX = targetObject._x - this._x;
						var travelY = targetObject._y - this._y;
						
						// Place jumper in center of target
						
						travelX += (targetObject._width / 2) - (this._width / 2);
						travelY += (targetObject._height / 2) - (this._height / 2);
						
						// Apply x and y movement to both world and jumper, as appropriate
					
						this._x += travelX;
						this._y += travelY;
						
						if (this.useCameraHorizontal) _root._x -= travelX;
						if (this.useCameraVertical) _root._y -= travelY;
						
					}
				}
				
			}
			
		}
		
	}

	
	
	// Extend this class and replace the update method in order to 
	// add extra code.
	function update() {
		
	}

	
	// Extend this class and replace the isHit method
	// in order to make something happen when the thing is hit
	function isHit(thing) {
		// use thing to refer to what we hit
		// use thing.type to read its type.
	}
	
}