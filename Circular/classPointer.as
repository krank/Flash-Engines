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
	
	var cameraFollow = false;
	
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
		
		checkSolids();
		
		// --- SHOOTING THINGS ---
		
		// Not done yet
		
		// --- CAMERA ---
		
		if (cameraFollow) {
			_root._x -= moveX;
			_root._y -= moveY;
		}
		
		// --- FINALIZE ---
		
		_x += moveX;
		_y += moveY;
		
		_rotation = degrees;
		
	}
	
	function checkSolids() {
		
		// EXPERIMENTAL:
		
		// Create new movieclip;
		
		
		
		
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

}