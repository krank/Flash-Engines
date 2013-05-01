import mx.data.encoders.Num;
/*    *----*
 *  /        \
 *  | - Circular -
 *  \        /
 *    *----*
 * 
 * classMediaTrigger
 * 
 */

class classMediaTrigger extends MovieClip {
	
	// SETTINGS
	var triggerDelay:Number = 24; // The number of frames to wait between activations. 0 = no delay
	var destroyAfterUse:Boolean = false; // set to true to destroy trigger after first activation
	
	// VARIABLES
	var mediaClip:classMedia; // Remembers the target mediaclip
	var triggerCounter:Number = 0; // The timer for the trigger delay
	
	function onLoad() {
		
		// Make sure there is a _root list of mediatriggers, and add self to it.
		if (not _root.mediaTriggers) _root.mediaTriggers = new Array();
		_root.mediaTriggers.push(this);
		
		// Generate media identifier
		var ident = this._name.split("_")[1];
		
		// If the mediaclip exists, save it for later use.
		if (_root[ident]) {
			mediaClip = _root[ident];
		} else {
			trace(ident + " not found!");
		}
	}
	
	function onEnterFrame() {
		// Count down if not paused
		if (triggerCounter > 0 && !_root.paused) {
			triggerCounter -= 1;
		}
	}
	
	function activate() {
		
		// If counter is at 0, activate etc.
		if (triggerCounter == 0) {
			
			// Activate the mediaclip
			mediaClip.activate();
			
			// Set the activation timer
			triggerCounter = triggerDelay;
			
			// Perhaps destroy self
			if (destroyAfterUse) {
				this.unloadMovie();
			}
		}
	}
	
}