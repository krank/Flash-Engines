/* o-----------------o
 * | - RECTANGULAR - |
 * 0-----------------o
 * 
 * Enemy class. Apply to any symbol that you wish to turn into a wandering enemy
 * 
 */

class classEnemy extends MovieClip {
	
	var gravity = 20;
	var walkVelocity = 10;
	var direction = 1;
	
	// Set up point positions
	var topSidePoints = 0.2;
	var bottomSidePoints = 0.8;
	
	var inertia;
	var inAir;
	var falling;
	
	var downForce;
	var upForce;
	
	var moveX;
	var moveY;
	
	function onLoad() {
		// Check to see if the enemies are already there. If they are not, create them
		if (not _root.unFriendlies) _root.unFriendlies = new Array();
		
		_root.unFriendlies.push(this);
	}
	
	function onEnterFrame() {
		// Reset the forces
		downForce = 0;
		upForce = 0;
		moveX = 0;
		moveY = 0;
		
		// If we are not falling, walk.
		if (not falling) moveX += walkVelocity * direction;
		
		// Apply gravity
		downForce += gravity;
		
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
		
		// Finalize Y-movement
		moveY = downForce - upForce;
		
		// Check for collisions w/ solids
		checkSolids();
		
		// Do extra checks
		extraChecks();
		
		// Check for hits
		hitChecks();

		// Finalize movement
		_x += moveX;
		_y += moveY;
		
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
			var overlapRight = checkRight(s)
			
			if (overlapRight) {
				moveX -= overlapRight["x"];
				rightCollide();
			}
			
			// Check if any of the left points are inside the solid
			var overlapLeft = checkLeft(s);

			if (overlapLeft) {
				moveX += (s._width - overlapLeft["x"]);
				leftCollide();
			}
			// The part within parenthesis = the overlap from the right side (i.e. the overlap from the left subtracted from the width).
		
			
			// --- GROUND ---
			
			var overlap = checkBottom(s);

			// If any of the feet had overlap
			if (overlap) {
				falling = false;
				
				// Do not move into the ground
				moveY = moveY - overlap["y"];
			}
			
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
		// --- NOT DONE YET
	}
	
	// Extend this class and replace the leftCollide and rightCollide methods
	// in order to gain more precise control of the thing's reactions to left/right collisions.
	function leftCollide() {
		direction = -direction;
	}
	
	function rightCollide() {
		direction = -direction;
	}
	
	// Extend this class and replace the isHit and extraChecks methods
	// in order to make extra checks or to make something happen when the thing is hit.
	function isHit(thing) {
		
	}
	
	function extraChecks() {
		
	}
	
}