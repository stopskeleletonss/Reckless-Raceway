class Enemy {
  float enemyx,enemyy; //x and y position of the enemy car
  int[] sides; //x coordinates of the furthest 2 lanes that are randomly selected for being spawned in
  int espawn; //variable used as the random chance for the enemy car spawning
  int bulletsize,bulletspeed; //size and speed of the projectile shot by the enemy car
  int shots; //how many projectiles have been shot
  float start, current, end; //start time of when the player is hit, current time since player is hit, end time of when the timer should stop
  boolean timerstart,starttime; //timerstart starts the timer, while starttime makes sure the start variable is only updated once at the start of a timer
  boolean carchase; //whether or not the random chance was met, and a car chase should happen
  boolean fired; //whether or not there is a projectile currently on screen
  boolean shotadd; //adds to the shots variable only once per hit
  boolean timerover; //if the timer when hitting the player is over
  PVector position; //x and y of the enemy car, starting place of the bullet
  PVector velocity; //the rate/speed at which the bullet moves towards the player's last known x coordinate
  PVector target; //x and y coordinate of the player car as the moment the bullet is fired (does not change direction if you move)

  Enemy() { //constructor of Enemy class
    shots=0; //initial amount of shots is 0
    bulletsize=20; //projectile size is 20
    bulletspeed=12; //projectile speed is 12
    velocity = new PVector(); //velocity is initially 0
    sides = new int[] {width/8, (width/8)*7}; //sides array contains the x coordinates of the far left and right lanes
    for (int i=0; i<sides.length; i++) { //i has an initial variable of 0, while i is less than the length of the sides array, i++
      enemyx=sides[int(random(2))]; //x coordinate of the enemy car is randomly selected between the two furthest lanes
    }
    enemyy=height+playercode.psizey; //initial enemyy is the height + half the length of the car as to not be seen beforehand
    position = new PVector(enemyx, enemyy); //starting position of the bullet is the x and y coordinate of the enemy car
    end=1500; //the end of the timer is 1500 (1.5 seconds)
    timerover=true; //timer is initially not activated
  }

  void enemy() {
    if (carchase==false) espawn=int(random(7000)); //if the enemy isn't currently activated/on screen, espawn is constantly changing to a number between 0 and 7000
    if (espawn<10) carchase=true; //if espawn is less than 10, an enemy car event is activated
    if (carchase) { //if a carchase is currently happening
      image(enemy, enemyx, enemyy); //draws the enemy car at the current enemyx and enemyy coordinate
      if (enemyy>(height/2)) { //if enemyy is greater than the half the height of the screen (the midpoint up and down)
        enemyy-=4; //enemyy moves upwards at a speed of 4 (enemy-=4 over and over)
      }
    }
  }

  void bullet() {
    if (enemyy<(height/2)+1&&shots<15) { //if enemyy is less than half the height plus one and has shot less than 15 projectiles
      if (fired==false) { //if a bullet isn't being fired
        fired=true; //a bullet is fired
        shotadd=true; //enables a boolean to add one to the total shots once
        position=new PVector(enemyx, enemyy); //starting position of the bullet is reset to the x and y coordinates of the enemy car
        target = new PVector(playercode.px, playercode.py); //target position of the bullet is updated to the current x and y coordinate of the player vehicle
        velocity = PVector.sub(target, position); //sets the velocity of the bullet to the target pvector minus the position pvector
        velocity.normalize(); //normalizes the velocity, so that it moves to the new point but only at a speed of one pixel
        velocity.mult(bulletspeed); //multiplies the velocity by bulletspeed (initially 12) so that it now (initially) moves at a speed of 12 pixels
      }
    }
    if (fired) { //if a bullet is being fired
      position.add(velocity); //the position of the bullet is equal to itself plus the velocity
      stroke(0); 
      strokeWeight(8);
      fill(55);
      if (timerover) ellipse(position.x, position.y, bulletsize, bulletsize); //if the timer is not active, draws the bullet as the current position pvector coordinates
      if (shotadd) { //if the shotadd boolean is true
        shots++; //add one to the total shots counter
        shotadd=false; //shotadd boolean is false (stops from adding to counter over and over)
      }
    }
    if (position.x<0||position.x>width||position.y<0||position.y>height) { //if the bullet goes off screen
      position=new PVector(enemyx+(playercode.psizex/2), enemyy+(playercode.psizey/3)); //reset the bullet's coordinates to the enemy car
      velocity=new PVector(); //set the bullet's velocity to 0, as it is no longer supposed to move
      fired=false; //the bullet is no longer counted as being fired
    }
    if (shots>14) { //if the enemy car has shot 15 times
      enemyy-=4; //continue moving upwards at a speed of 4 (enemy-=4 over and over)
    }

    if (enemyy<0-playercode.psizey) { //if the y position of the enemy car is less than 0 minus psizey
      enemyy=height+playercode.psizey; //the enemy y coordinate is equal to the height of the screen plus psizey (so that it doesn't start half onsreen)
      carchase=false; //there is no longer a carchase event happening
      shots=0; //total shot count is reset to 0
    }
  }

  void playerhit() {
    if (dist(position.x, position.y, playercode.px, playercode.py)<bulletsize/2+playercode.psizex/2) { //if the distance between the bullet and the player is less than the radius of the bullet plus half of psizex (player width)
      position=new PVector(enemyx,enemyy); //reset the bullet's coordinates to the enemy car
      velocity=new PVector(); //set the bullet's velocity to 0, as it is no longer supposed to move
      lives--; //take away one life from the total amount of lives
      timerstart=true; //cooldown timer is true
      starttime=true; //boolean to set the start of the timer once is true
      timerover=false; //timer is not off
    }
    if (timerstart==true) { //if the timer has been triggered (player hit)
      if (starttime) { //if the boolean to set start of timer is true
      start = millis(); //start is equal to the current millis count
      starttime=false; //boolean to set start of timer is false (prevents start from constantly changing)
      }
    current=millis(); //current is equal to the current millis count
    if (current-start>end) { //if the current millis value minus the starting millis value is greater than the set ending of the timer (1.5 seconds)
      timerstart=false; //timer has not been started
      timerover=true; //timer is over
      fired=false; //the bullet is no longer counted as being fired
    }
  }
}
  
  void collision () {
    if (playercode.px>enemyx) { //if the player x coordinate is greater than the enemy x coordinate
      if (dist(playercode.px,playercode.py,enemyx,enemyy)<playercode.psizex) { //if the distance between player x and enemy x is less than the player width
        playercode.px+=playercode.pspeedx; //player x is equal to itself plus player x speed (pushed away from the enemy car)
      }
    }
    if (playercode.px<enemyx) { //if the player x coordinate is less than the enemy x coordinate
      if (dist(playercode.px,playercode.py,enemyx,enemyy)<playercode.psizex) { //if the distance between player x and enemy x is less than the player width
        playercode.px-=playercode.pspeedx; //player x is equal to itself minus player x speed (pushed away from the enemy car)
      }
    }
    if (playercode.py>enemyy) { //if the player y coordinate is greater than the enemy y coordinate
      if (dist(playercode.px,playercode.py,enemyx,enemyy)<playercode.psizex) { //if the distance between player y and enemy y is less than the player width
        playercode.py+=playercode.pspeedy; //player y is equal to itself plus player y speed (pushed away from the enemy car)
      }
    }
    if (playercode.py<enemyy) { //if the player y coordinate is less than the enemy y coordinate
      if (dist(playercode.px,playercode.py,enemyx,enemyy)<playercode.psizex) { //if the distance between player y and enemy y is less than the player width
        playercode.py-=playercode.pspeedy; //player y is equal to itself minus player y speed (pushed away from the enemy car)
      }
    }
  }
}
