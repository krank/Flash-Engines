class classMissile extends MovieClip {

	// Set speed
	var speed = 10;
	
	// Set type
	var type = "missile";
	
	// Name of thing to follow
	var follow = false;
	
	// Variables
	var moveX;
	var moveY;
	
	var degrees;
	
	
	
	
	// Set the direction of the missile
	function setDirection(degrees) {
	
		this.degrees = degrees;
		var radians = degrees * (Math.PI / 180);
		
		// Get x- and y-movement based on radians and speed
		// (trigonometry)
		this.moveX = Math.sin(radians) * speed;
		this.moveY = Math.cos(radians) * speed;
		
		// Set graphical rotation¨'
		this._rotation = degrees;
	}
	
	function setSpeed(speed) {
		this.speed = speed;
		setDirection(this.degrees);
	}
	
	function setTarget(target) {
		// Calculate opposite and adjacent sides of the triangle
		// i.e. the x- and y-distance between the missile and its target
		var o = target._x - _x;
		var a = target._y - _y;

		// Calculate new angle based on distances (o/a)
		var radians = Math.atan2(o, a);
		this.degrees = radians * (180 / Math.PI);
		
		// Set new direction
		setDirection(degrees);
	}
	
	function onEnterFrame() {
		
		if (not moveX) {
			moveX = speed;
		}
		
		// If the missile is a seeker
		if (follow) {
			setTarget(_root[follow]);
		}
		
		// Update
		update();
		
		// Move missile
		_x += moveX;
		_y += moveY;

		// Make hit testing
		hitTests();
		
	}
	
	function hitTests() {
		// If there is a list of unfriendlies
		if (_root.unFriendlies) {
			// Go through the list
			for (var enum in _root.unFriendlies) {
				// Create a temporary enemy variable to hold each enemy
				var enemy = _root.unFriendlies[enum];
				
				// if this missile is hitting the enemy,
				// activate moth the missile's and the enemy's isHit
				// methods.
				if (this.hitTest(enemy)) {
					this.isHit(enemy);
					enemy.isHit(this);
				}
			}
		}
		
		// if there is a list of solids
		if (_root.solids) {
			// Go through the list
			for (var snum in _root.solids) {
				// Create a temporary solid variable to hold each solid
				var solid = _root.solids[snum];
				
				// If this missile is hitting a solid, activate its isHit
				// method.
				if (this.hitTest(solid)) {
					this.isHit(solid);
				}
				
			}
		}
		
	}
	
	
	// When extending this class, replace isHit() to make the missile
	// do things when hit. Use thing.type to check the type of what's hitting it.
	function isHit(thing) {
		
	}
	
	
	function update() {
		
	}
	
	function create() {
		
	}
	
}