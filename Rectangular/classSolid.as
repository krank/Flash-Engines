﻿/* o-----------------o
 * | - RECTANGULAR - |
 * 0-----------------o
 * 
 * Solid class. Apply to any item which is to be considered solid in the game.
 * 
 */

class classSolid extends MovieClip {
	
	// The amount of friction given to the jumper
	var sideFriction = 0.5;
	var type = "solid";
	
	function onLoad() {
		// Check to see if the solids are already there. If they are not, create them
		if (not _root.solids) _root.solids = new Array();
		
		_root.solids.push(this);
		load();
	}
	
	
	function load() {
		// Placeholder
	}
	
	function hitPoint(x, y) {
		//Between left and right...
		
		var in_x = x > _x and x < _x + _width;
		var in_y = y > _y and y < _y + _height;
		
		if (in_x and in_y) {
			var overlap = new Array();
			overlap["x"] = x - _x;
			overlap["y"] = y - _y;
			return overlap;
		} else {
			return false;
		}
	}
	
	function effectOverlap(thing, overlapX, overlapY) {
		// Negate just enough movement to keep the jumper outside of the solid
		thing.moveX += overlapX;
		thing.moveY += overlapY;
	}
	
}