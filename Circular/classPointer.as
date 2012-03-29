/*    *----*
 *  /        \
 *  | - Circular -
 *  \        /
 *    *----*
 * 
 * classPointer
 * 
 * TODO:
 * - Collisions with static objects
 * - Shooting and whatnot
 * - Separate movement from rotation?
 * 
 */

class classPointer extends MovieClip {
	
	var walkVelocity = 10;
	
	var degrees;
	var radians;
	
	var upKey = 87;		//w
	var downKey = 83;	//s
	var leftKey = 65;	//a
	var rightKey = 68;	//d
	
	var moveX;
	var moveY;
	
	var followPointer = true;
	var moveKeys = false;
	
	var radius = 25;
	
	
	function onEnterFrame() {

		// Reset things
		moveX = 0;
		moveY = 0;
		degrees = 0;
		
		// --- ROTATION ---
		
		// get the opposite and adjacent sides
		var o = _root._xmouse - _x;
		var a = _root._ymouse - _y;
		
		// Get the radians based on arctan of a, o
		radians = Math.atan2(a, o);
		
		// Calculate the degrees
		degrees = radians * (180 / Math.PI)
		
		// --- MOVEMENT ---
		
		if (moveKeys) {
			if (Key.isDown(leftKey)) moveX -= walkVelocity;
			if (Key.isDown(rightKey)) moveX += walkVelocity;
			if (Key.isDown(upKey)) moveY -= walkVelocity;
			if (Key.isDown(downKey)) moveY += walkVelocity;
		}
		
		if (followPointer) {
			
			// Calculate distance
			
			var distance = Math.sqrt(Math.pow(_xmouse, 2) + Math.pow(_ymouse, 2));
			
			if (distance > 15) {
				// Calculate moveX and moveY
				moveX = Math.cos(radians) * walkVelocity;
				moveY = Math.sin(radians) * walkVelocity;
			}
			
		}
		
			
		// --- COLLISIONS ---
		
		// Go through all solids
		
		for (var solid in _root.solids) {
			var block = _root.solids[solid];
			if (moveX > 0) {
				// x-overlaps, 3 points
				var overlap = block.hitPoint(_x + radius + moveX, _y);

				if (overlap) {
					
				}
			}
			
		}
		
		
		// Not done yet
		
		// --- SHOOTING THINGS ---
		
		// Not done yet
		
		// --- FINALIZE ---
		
		_x += moveX;
		_y += moveY;
		
		_rotation = degrees;
		
	}

}