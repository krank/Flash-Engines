/* o-----------------o
 * | - RECTANGULAR - |
 * 0-----------------o
 * 
 * Turning Enemy class. Apply to any symbol that you wish to turn into a wandering enemy that turns away from cliffs
 * 
 */


class classEnemyTurning extends classEnemy {
	
	function extraChecks() {
		// Unless we find a solid under our feet for the next step, turn.
		var turn = true;
		
		// Go through all aolids
		for (var solidnum in _root.solids) {
			
			var block = _root.solids[solidnum];
			
			// Decide if we're gpoing to check the left or the right side
			var side = _x + moveX;;
			if (direction > 0) {
				side += _width;
			}
			
			// Check if the block is in front of us
			if (block.hitPoint(side, _y + _height + 1)) {
				turn = false;
			}
		
		}
		
		if (turn and not falling) {
			direction = -direction;
		}
	}
	
}