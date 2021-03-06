﻿/*    *----*
 *  /        \
 *  | - Circular -
 *  \        /
 *    *----*
 * 
 * classSolid
 * 
 * Solid class. Apply to any item which is to be considered solid in the game.
 * 
 */

class classSolid extends MovieClip {
	function onLoad() {
		// Check to see if the solids are already there. If they are not, create them
		if (not _root.solids) _root.solids = new Array();
		
		_root.solids.push(this);
	}
	
	function hitPoint(x, y) {
		
		var realX = _root.getRect(this).xMin;
		var realY = _root.getRect(this).yMin;

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
	
}