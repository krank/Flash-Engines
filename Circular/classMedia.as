/*    *----*
 *  /        \
 *  | - Circular -
 *  \        /
 *    *----*
 * 
 * classMedia
 * 
 */

class classMedia extends MovieClip {
	
	// SETTINGS
	var doPause:Boolean = true; // Whether to pause game while playing media
	
	
	// VARIABLES
	var origX, origY:Number;
	var isPlaying:Boolean = false;
	
	function onLoad() {
		
		// Remember original position
		origX = _x;
		origY = _y;
		
		// Do not play immediately
		this.stop();
	}
	
	function onEnterFrame() {
		// If media has reached the end of its timeline, stop it.
		if (this._currentframe == this._totalframes) {
			this.stop();
			
			// Also reset to original position
			this._x = origX;
			this._y = origY;
			isPlaying = false;
			
			// And unpause
			if (doPause) _root.paused = false;
		}
	}
	
	function activate() {
		
		// Play, if not already playing
		if ( !isPlaying ) {
			
			// Move to center of stage
			this._x = Stage.width / 2 - this._width / 2;
			this._y = Stage.height / 2 - this._height / 2;
			
			// Play
			this.play()
			isPlaying = true;
			
			// Pause the game
			if (doPause) _root.paused = true;
		}
	}
}