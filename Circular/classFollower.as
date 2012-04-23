/*    *----*
 *  /        \
 *  | - Circular -
 *  \        /
 *    *----*
 * 
 * classFollower
 * 
 * Follower class. Apply to any enemy that should be following something.
 * Remember to set followTarget to the 
 * 
 */

class classFollower extends MovieClip {
	
	// Creature type
	var type = "follower";
	
	// Basic parameters
	var walkVelocity = 5;
	var radius = 25;
	var followTarget = "pointer";
	
	var ghost = false;
	
	// Variables
	var radians;
	var degrees;
	var moveX;
	var moveY;
	
	function onLoad() {
		// Check to see if the enemies are already there. If they are not, create them
		if (not _root.unFriendlies) _root.unFriendlies = new Array();
		
		_root.unFriendlies.push(this);
	}	

	function onEnterFrame() {
		
		
		
		// Set x- and y-movement to 0
		moveX = 0;
		moveY = 0;
		
		// Get the x-distance and y-distance between the target and this enemy.
		var o = _root[followTarget]._x - _x;
		var a = _root[followTarget]._y - _y;
		
		// Get the radians based on arctan of a, o.
		//  This means calculating the angle based on the x/y distances, which act as
		//  the Opposite and Adjacent sides of the triangle.
		radians = Math.atan2(a, o);
		
		// Calculate the degrees based on the radians.
		degrees = radians * (180 / Math.PI)
		
		
		// Calculate the distance (hypotenuse) between target and this enemy.
		var distance = Math.sqrt(Math.pow(a, 2) + Math.pow(o, 2));
		
		// if the distance is greater than 5, calculate x, y-movement based on velocity and angle
		if (distance > 5) {
			moveX = Math.cos(radians) * walkVelocity;
			moveY = Math.sin(radians) * walkVelocity;
		}
		
		// Check for solids
		
		if (not ghost) checkSolids();
		
		// --- FINALIZE ---
		
		// Move
		_x += moveX;
		_y += moveY;
		
		// Rotate
		_rotation = degrees;
		
		// Animate
		animate();
		
		// Do extra checking
		extraChecks();
		
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

				if (overlapX) moveX -= overlapX;

			} else if (moveX < 0) {
				
				// Upper left point
				var overlapX = block.hitPoint(leftSide, hypotheticalY - radius / 1.5);
				// Lower left point
				if (not overlapX) overlapX = block.hitPoint(leftSide, hypotheticalY + radius / 1.5);
				
				if (overlapX) moveX += block.width - overlapX;

			}
			
			// Y-axis
			if (moveY > 0) {
				// Lower left point
				var overlapY = block.hitPoint(hypotheticalX - radius / 1.5, bottomSide);
				// Lower right point
				if (not overlapY) overlapY = block.hitPoint(hypotheticalX + radius / 1.5, bottomSide);

				if (overlapY) moveY -= overlapY;

			} else if (moveY < 0) {
				
				// Top left point
				var overlapY = block.hitPoint(hypotheticalX - radius / 1.5, topSide);
				// Top right point
				if (not overlapY) overlapY = block.hitPoint(hypotheticalX + radius / 1.5, topSide);

				if (overlapY) moveY += block.height - overlapY;
				
			}
			
			

		}
	}
	
	function isHit(thing) {
		// use thing to refer to what we hit
		// use thing.type to read its type.
	}
	
	function animate() {
		
	}
	
	function extraChecks() {
		
	}
	
}