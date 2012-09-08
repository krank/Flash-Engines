class classTeleport extends MovieClip {
	function onLoad() {
		// Check to see if the teleports are already there. If they are not, create them
		if (not _root.teleports) _root.teleports = new Array();
		
		_root.teleports.push(this);
	}
	
	function activate() {
		trace ("Go to target!");
	}
}