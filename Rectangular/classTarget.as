class classTarget extends MovieClip {
	function onLoad() {
		// Check to see if the targets are already there. If they are not, create them
		if (not _root.targets) _root.targets = new Array();
		
		_root.targets.push(this);
	}
}