/* o-----------------o
 * | - RECTANGULAR - |
 * 0-----------------o
 * 
 * Resisting class. Apply to semisolids like water.
 * 
 */

class classModifier extends classSolid {
	
	// Set vertical(falling), horizontal(walking) and jumping modifiers.
	var verticalModifier = .2;
	var horizontalModifier = .5;
	var jumpModifier = 2;
	
	function onLoad() {
		// If the list of resisting blocks does not exist, create it.
		if (not _root.modifiers) _root.modifiers = new Array();
		// Add this block to the list
		_root.modifiers.push(this);
	}
	
}