class Oil {
  int oilchance; //variable used as the random chance for the oil spawning
  int[] oilspawns; //
  float oilx, oily; //x and y position of the oil spill
  int oilsize; //array of the x coordinates of the 4 lanes (oil spill is randonly spawned in one)
  boolean oilspawned,oilxcheck; //oilspawned is whether or not an oilspill is currently spawned, and oilxcheck is whether or not the spawned oilspill has been assigned an x coordinate
  Oil() {
    oilsize = 120; //size of the oil spill is 120 pixels both high and wide
    oilspawns = new int[]{width/8, (width/8)*3, (width/8)*5, (width/8)*7}; //oilspawns array contrains all 4 of the lane x coordinates
  }

  void oil() { //constructor of Oil class
    if (oilspawned==false) { //if an oilspill hasn't been spawned
      oilchance=int(random(2000)); //oilchance is constantly changing to a number between 0 and 2000
      if (oilchance<10) { //if oilchance is less than 10
        oilspawned=true; //an oil spill has been spawned
        oilxcheck=true; //enables code to assign an x coordinate to the oilspill
      }
    }

    if (oilspawned) { //if an oilspill has been spawned
      if (oilxcheck) { //if the oilspill hasn't been assigned an x coordinate
      if (enemycode.carchase) { //if a carchase is occurring
          if (enemycode.enemyx==width/8) { //if the enemy car is in the furthest left lane
            oilx = oilspawns[int(random(1, oilspawns.length))]; //x coordinate of the oilspill can be any lane except the furthest left lane
          }
          else if (enemycode.enemyx==(width/8)*7) { //if the enemy car is in the furthest right lane
            oilx = oilspawns[int(random(healcode.shortlength))]; //x coordinate of the oilspill can be any lane except the furthest right lane
          }
        }
        if (enemycode.carchase==false) { //if a carchase isn't occurring
          oilx = oilspawns[int(random(oilspawns.length))]; //x coordinate of the oilspill can be any of the 4 lanes
        }
        oilxcheck=false; //the oilspill has been assigned an x coordinate
      }
      image(oilimage, oilx, oily, oilsize, oilsize); //draws the oilspill at the assigned oilx coordinate and the current oily coordinate
      oily+=miscspeed; //y coordinate of the oilspill equals itself plus the miscspeed (initially 10) (moves the oilspill downwards)
      if (oily>height) { //if the y coordinate of the oilspill is greater than the height
        oilspawned=false; //the oilspill is no longer spawned
        oily=0; //oilspill y coordinate is reset to 0
      }
    }
  }

  void oilspin() {
    if (dist(oilx, oily, playercode.px, playercode.py)<(oilsize/2+playercode.psizex/2)) { //if the distance between the oilspill and player is less than half the width of the oilspill plus half the width of the player
      if (playercode.spinning==false) { //if the player isn't currently spinning
        rotation=0; //rotation is reset to 0
        playercode.canspin=true; //the player is able to spin
      }
    playercode.py+=miscspeed; //when in contact with the oilspill, the player car is dragged downwards at the same speed that the oilspill is moving downwards
  }
}
}
