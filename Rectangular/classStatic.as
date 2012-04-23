/* o-----------------o
 * | - RECTANGULAR - |
 * 0-----------------o
 * 
 * Static class. Used for HUD elements and the like.
 * 
 */

class classStatic extends MovieClip {
	function onLoad() {
		if (not _root.statics) _root.statics = new Array();
		_root.statics.push(this);
	}
}