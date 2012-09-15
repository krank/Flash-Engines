class classTeleport extends MovieClip {
	function onLoad() {
		// Check to see if the teleports are already there. If they are not, create them
		if (not _root.teleports) _root.teleports = new Array();
		
		_root.teleports.push(this);
	}
	
	function activate(character) {
		// Get the name of the target.
		var targetName = "t_" + this._name.split("_")[0];
		
		// Find the target, if it exists
		var targetObject = false;
		for (var targetNum in _root.targets) {
			if (_root.targets[targetNum]._name == targetName) {
				targetObject = _root.targets[targetNum];
			}
		}
		
		
		// See if a target object has been found
		if (!targetObject) {
			// If not, reset the "camera".
			character.move(_root._x, _root._y);
			
			// Also try to go to the frame using the same target name instead
			_root.gotoAndStop(targetName);
			
		} else {
			// Get difference in coordinates
			var travelX = targetObject._x - character._x;
			var travelY = targetObject._y - character._y;
			
			// Place character in center of target
			travelX += (targetObject._width / 2) - (character._width / 2);
			travelY += (targetObject._height / 2) - (character._height / 2);
			
			// Apply x and y movement to both world and character, as appropriate
			character.move(travelX, travelY);
		}
		
	}
	
}