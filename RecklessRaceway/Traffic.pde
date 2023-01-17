class Traffic {
  float carx, cary; //x and y coordinate of the oncoming vehicle
  int[] carspawns; //array of the x coordinates of the 4 lanes (oncoming car is randonly spawned in one)
  int carchance;  //variable used as the random chance for the oncoming car spawning
  int carsizex, carsizey; //width and height of the oncoming car
  int carmodel; //variable used to randomize the look of the car
  int carspeed, minspeed, maxspeed; //carspeed is the randomly selected speed for the car to move at, minspeed is the slowest the car can move while maxspeed is the fastest it can move
  boolean carspawned, carcheck; //carspawned is whether or not an oncoming car is currently spawned, and carcheck is whether or not the spawned oncoming car has been assigned an x coordinate

  Traffic() { //constructor for Traffic class
    carspawns=new int[]{width/8, (width/8)*3, (width/8)*5, (width/8)*7}; //carspawns array contrains all 4 of the lane x coordinates
    carsizex=88; //width of the car is 88 pixels
    carsizey=155; //height of the car is 155 pixels
    minspeed=11; //initial minimum speed of the oncoming car is 11 pixels
    maxspeed=15; //initial maximum speed of the oncoming car is 15 pixels
  }

  void traffic() {
    traffic=loadImage(str(carmodel)+"passcar.png"); //the oncoming car has a random model out of 5 selectable images
    if (carspawned==false) { //if an oncoming car hasn't been spawned
      carchance=int(random(4000)); //carchance is constantly changing to a number between 0 and 4000
      if (carchance<10) { //if carchance is less than 10
        carspawned=true; //an oncoming car is spawned
        carcheck=true; //enables code to assign an x coordinate to the oncoming car
      }
    }
    if (carspawned) { //if an oncoming car has been spawned
      if (carcheck) { //if the oncoming car hasn't been assigned an x coordinate
      playercode.crashable=true; //player car is now crashable
        carmodel=int(random(5)); //carmodel is a random number between zero and four (used to randomize look of car)
        carspeed=int(random(minspeed, maxspeed)); //speed of the car is random between the minimum and maximum speed
        if (enemycode.carchase) { //if a carchase is occurring
          if (enemycode.enemyx==width/8) { //if the enemy car is in the furthest left lane
            carx = carspawns[int(random(1, carspawns.length))]; //x coordinate of the oncoming car can be any lane except the furthest left lane
          } else if (enemycode.enemyx==(width/8)*7) { //if the enemy car is in the furthest right lane
            carx = carspawns[int(random(healcode.shortlength))]; //x coordinate of the oncoming car can be any lane except the furthest right lane
          }
        }
        if (enemycode.carchase==false) { //if there isn't a carchase occurring
          carx = carspawns[int(random(carspawns.length))]; //x coordinate of the oncomign car can be any of the 4 lanes
        }
        carcheck=false; //the oncoming car has been assigned an x coordinate
      }
      image(traffic, carx, cary, carsizex, carsizey); //draws the oncoming car at the assigned x coordinate and current y coordinate
      cary+=carspeed; //y coordinate of the oncoming car equals itself plus the miscspeed (initially 10) (moves the oncoming car downwards)
      if (cary>height+(carsizey/2)) { //if the y coordinate of the oncoming car is equal to the window height plus half the oncoming car's length
        carspawned=false; //the oncoming car is no longer spawned
        cary=0; //y coordinate of the oncoming car is reset to 0
      }
    }
  }
  
  void carcrash() {
      if (dist(carx, cary, playercode.px, playercode.py)<carsizex/2+playercode.psizex/2) { //if the distance between the player vehicle and oncoming car is less than half the player width plus half the oncoming car width
        if (playercode.crashable) { //if the player is able to crash/take damage from the oncoming car
          lives--; //minuses one from the life counter
          playercode.crashable=false; //player is no longer able to take damage to prevent taking more than one damage
        }
        playercode.py+=carspeed; //player vehicle is dragged downwards with the oncoming car at the same speed while still in contact
    }
  }
}
