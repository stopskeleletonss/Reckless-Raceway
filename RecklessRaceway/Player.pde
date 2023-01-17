class Player {
  float pspeedx,pspeedy; //speed of the player vehicle on the left/right and up/down
  float px,py,psizex,psizey; //x and y coordinates of the player vehicle, width and height of the player vehicle
  boolean canspin,spinning; //if the player is able to spin, and if the player is spinning
  boolean canheal,healing; //if the player is able to heal, and if the player is healing
  boolean crashable; //if the player is able to take damage from an oncoming car
  
  Player() { //constructor of Player class
    px=width/2; //initial x coordinate of the player vehicle is half of the screen width
    py=height/3*2; //intial y coordinate of the player vehicle is two thirds of the screen height
    psizex=100; //width of the player vehicle is 100 pixels
    psizey=170; //height of the player vehicle is 170 pixels
    pspeedx=8; //speed at which the player vehicle moves left and right is 8
    pspeedy=7; //speed at which the player vehicle moves up and down is 7
  }

void player() {
  if (carunlocked) {player=loadImage("player"+str(whichcar)+".png");} //if the second car has been unlocked, the player car is whichever car is selected on the main menu
  else {player=loadImage("player1.png");} //if the second car hasn't been unlocked, the only playable car is the default one
  if (spinning==false){ //if the car is not spinning
    image(player,px,py,psizex,psizey); //draws the player vehicle normally, at the current player x and y coordinates
  }
  if (canspin) {spinning=true;} //if the car is able to spin, the car is spinning
  if (spinning&&rotation<TWO_PI) { //if the car is spinning and hasn't spun 360 degrees (two pi)
      pushMatrix(); //starts a pushmatrix to spin the player vehicle
      translate(px,py); //maintains the player vehicle at it's intended location
      rotate(rotation+=0.25); //rotates tge player vehicle at a speed of 0.25
      image(player,0,0); //player vehicle image to be rotated, replaces the normal player image while spinning is active
      popMatrix(); //ends pushmatrix affecting code above
  }
  if (rotation>TWO_PI) {spinning=false;} //if the car has spun more than 360 degrees, the car is no longer spinning
  if (lives<1) {gameover=true;} //if the life count reaches 0, the game is over
  if (canheal&&lives<3) {healing=true;} //if the player can heal and has less than 3 lives, the player is healing
  if (canheal&&lives==3) {canheal=false;} //if the player can heal and is already at 3 lives, cancel canheal (set it to false) (used to fix a bug)
  if (healing) { //if the player is healing
    lives++; //add one to the lives counter
    healcode.medspawned=false; //the medkit is no longer spawned
    healcode.kity=0; //y coordinate of the medkit is reset to 0
    canheal=false; //the player can no longer heal
    healing=false; //the player is no longer healing
  } 
}

void movement() {
 if(wPressed==true) py-=pspeedy; //if the boolean to move the player up is true, move the player up by the player y speed
 if(aPressed==true) px-=pspeedx; //if the boolean to move the player left is true, move the player left by the player x speed
 if(sPressed==true) py+=pspeedy; //if the boolean to move the player down is true, move the player town by the player y speed
 if(dPressed==true) px+=pspeedx; //if the boolean to move the player right is true, move the player right by the player x speed
}

void boundaries() {
  if(px<0+psizex/2) px+=pspeedx; //if the player car reaches the far left of the screen, push them to the right
  if(px>width-psizex/2) px-=pspeedx; //if the car reaches the far right of the screen, push them to the left
  if(py<0+psizey/2) py+=pspeedx; //if the car reaches the top of the screen, push them downwards
  if(py>height-psizey/2) py-=pspeedx; //if the car reaches the bottom of the screen, push them upwards
}
}
