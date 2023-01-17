class Heal {
  float kitx,kity; //x and y position of the medkit
  int healsize; //size of the medkit
  int medchance;  //variable used as the random chance for the medkit spawning
  int shortlength; //usable values in healspawns array when the enemy car is in the right lane
  int[] healspawns; //array of the x coordinates of the 4 lanes (medkit is randonly spawned in one)
  int hbarx,hbary; //x and y coordinate of the healthbar
  boolean medspawned,medcheck; //medspawned is whether or not a medkit is currently spawned, and medcheck is whether or not the spawned medkit has been assigned an x coordinate
  
  Heal() { //constructor of Heal class
    healsize=80; //size of the medkits is 80 pixels both high and wide
    healspawns=new int[]{width/8,(width/8)*3,(width/8)*5,(width/8)*7}; //healspawns array contrains all 4 of the lane x coordinates
    shortlength=healspawns.length-1; //shortlength is equal to the length of the healspawns array minus 1
    hbarx=150; //width of the healthbar is 150 pixels
    hbary=50; //height of the healthbar is 50 pixels
  }
  
  void medkit() {
    if (medspawned==false) { //if a medkit hasn't been spawned
      medchance=int(random(10000)); //medchance is constantly changing to a number between 0 and 10000
      if (medchance<10) { //if medchance is less than 10
        medspawned=true; //the medkit is spawned
        medcheck=true; //enables code to assign an x coordinate to the medkit
      }
    }
    if (medspawned) { //if the medkit is spawned
      if (medcheck) { //if the medkit hasn't been assigned an x coordinate
        if (enemycode.carchase) { //if a carchase is occurring
          if (enemycode.enemyx==width/8) { //if the enemy car is in the furthest left lane
            kitx = healspawns[int(random(1,healspawns.length))]; //x coordinate of the medkit can be any lane except the furthest left lane
          }
          else if (enemycode.enemyx==width/8*7) { //if the enemy car is in the furthest right lane
            kitx = healspawns[int(random(shortlength))]; //x coordinate of the medkit can be any lane except the furthest right lane
          }
        }
          if (enemycode.carchase==false){ //if a carchase isn't occurring
            kitx = healspawns[int(random(healspawns.length))]; //x coordinate of the medkit can be any of the 4 lanes
          }
        medcheck=false; //an x coordinate has been assigned to the medkit
    }
    image(medkit,kitx,kity,healsize,healsize); //draws the medkit as the assigned kitx coordinate and current kity coordinate
    kity+=miscspeed; //y coordinate of the medkit equals itself plus the miscspeed (initially 10) (moves the medkit downwards)
  if (kity>height) { //if the ycoordinate of the medkit is greater than the height of the screen
    medspawned=false; //the medkit is no longer spawned 
    kity=0; //y coordinate of the medkit is reset to 0
    }
  }
  }
  
  void healthgain() {
    if (playercode.healing==false) { //if the player isn't being healed
      if (dist(kitx,kity,playercode.px,playercode.py)<healsize/2+playercode.psizex/2) { //if the distance between the medkit and player is less than half the width of the medkit plus half the width of the player
        playercode.canheal=true; //boolean to heal the player is true
      }
    }
  }
  void healthbar() {
   healthbar=loadImage(str(lives)+"health.png"); //healthbar image is equal to the image that corresponds with the current amount of lives
   image(healthbar,width-hbarx,height-hbary); //draws the healthbar in the bottom right of the screen
  }
}
