import processing.sound.*;
SoundFile racemusic;

Player playercode; //runs one instance of the Player class
Enemy enemycode; //runs one instance of the Enemy class
Heal healcode; //runs one instance of the Heal class
PImage titlescreen,endscreen,endscreenlock,menucar1,menucar2,cararrow,diffarrow; //pimage variables for all parts of the start and end screens
PImage player,oilimage,medkit,healthbar,traffic,enemy; //pimage variables of the objects used in the game (including the player)
PFont gamefont; //font used for score numbers in endscreen and timer in-game
float[] linex=new float[2]; //x coordinates of the moving road parts
float[] liney=new float[3]; //y coordinates of the moving road parts
float ly1=-50,ly2,ly3; //initial y spawns of the three moving lines in each column
float lwidth=16,llength=100; //width and length of the moving parts of the road
float miscspeed=10; //general speed used for road pieces and static objects on the road (medkits and oil)
float rotation; //float variable for rotating the player
float carselect,diffselect; //changable x/y coordinate for the car/difficulty selection arrows respectively
int starttime,currenttime,newscore,highscore=0; //variables used to keep track of the current game's score, and the highest score achieved while program is opened
int startdifftime,currentdifftime,enddifftime=30000; //variables used to raise speed of multiple in-game objects after increments of time (ramping difficulty)
int lives=3,howmany=4; //maximum lives of player, how many of both oncoming cars and oil are being called at once
int whichcar=1,unlocked=3; //unlocked displays the second car as locked (image3.png) until being changed to 2 when unlocked (image2.png), whichcar is to stop car selection arrow from going too far left or right 
int musiccounter=0; //counter to determine whether music is allowed to play or not
boolean wPressed,aPressed,sPressed,dPressed; //booleans that activate when a direction on the controls is pressed, moving the player in said direction
boolean gamestart,gameover; //booleans that activate when the game either starts or ends
boolean carunlocked,hardmode,hardcheck,normalcheck; //carunlocked is to tell the game when the second car is playable, hardmode for when the harder difficulty is selected, and hardcheck/normalcheck are to reset the speed of everything in both difficulties
boolean difftimer=true,diffstart,difffinish; //starts difficulty increase increments when game is started, diffstart and difffinish are to apply the speed changes, and then reset the timer
Traffic[] carcode = new Traffic[howmany]; //array of how many times the Traffic class will be run
Oil[] oilcode = new Oil[howmany]; //array of how many times the Oil class will be run
void setup() {
  imageMode(CENTER); // set x,y coordinates of an image to the middle of the image instead of the top left corner
  size(800,800);
  enemy=loadImage("enemy.png");
  oilimage=loadImage("oil.png");
  medkit=loadImage("medkit.png");
  titlescreen=loadImage("titlescreen.png");
  endscreen=loadImage("endscreen.png");
  endscreenlock=loadImage("endscreenlock.png");
  menucar1=loadImage("player1.png");
  diffarrow=loadImage("arrow0.png");
  cararrow=loadImage("arrow1.png"); //load all unchanging images used in the game
  racemusic=new SoundFile(this, "racemusic.wav"); //loads the sound file for the game music
  gamefont=createFont("arcade.TTF",30); //loads the font file used for the imer and endscreen score
  ly2=height/2-50;
  ly3=height-50;
  linex[0]=(width/4);
  linex[1]=(width/4)*3; //both x and y coordinates of moving road parts that couldn't be declared until a size was set
  playercode=new Player(); //playercode calls and draws one instance of the Player class
  enemycode=new Enemy(); //enemycode calls and draws one instance of the Enemy class
  healcode=new Heal(); //healcode calls and draws one instance of the Heal class
  spilloil(); //calls and runs the void spilloil() script to initialize Oil class array
  rushhour(); //calls and runs the void rushhour() script to initialize Traffic class array
  carselect=(width/4*3)-playercode.psizex/2; //starting position of the carselect arrow (above default car)
  diffselect=height/2+20; //starting position of the difficulty select arrow (beside normal mode)
}

void draw() {
  backgroundmusic(); //cals and runs the void backgroundmusic() script to play the game music while the game is started and not ended
  if(gamestart==false) { //if the game hasn't been started
   titlescreen(); //calls and runs the void titlescreen() script to display the titlescreen and enable the selection of difficulty and car sprite
  }
  if(gamestart && gameover==false) { //if the game has been started, but hasn't finished
  background(155);
  liney[0]=ly1;
  liney[1]=ly2;
  liney[2]=ly3; //assigns the original coordinates of each moving road part in a column to a value of the array to be used altogether
  bkground(); //calls and runs the void bkground() script to draw both the static and moving parts of the road
  if (hardmode==false) {difficultyramp();} //if hardmode is disabled, call and run the void difficultyramp() script, which increases the speed of objects and projectiles ingame in small increments throughout the game
  if (hardmode) {difficultyhard();} //if hardmode is enabled, call and run the void difficultyhard() script which increases the speed drastically all at once instead of increments throughout the game
  playercode.boundaries(); //calls and runs the void boundaries() script from the Player class for stopping the player from driving offscreen
  playercode.movement(); //calls and runs the void movement() script from the Player class for moving the player in a direction when the corresponding key is pressed
  for (int i=0;i<oilcode.length;i++) { //i has an initial value of 0, while i has a value less than the length of the oilcode array, i=i+1
    oilcode[i].oil(); //calls and runs the void oil() script from the Oil class (as many times as the length of the array) for displaying and moving the oil spills
    oilcode[i].oilspin(); //calls and runs the void oilspin() script from the Oil class (as many times as the length of the array) for spinning and dragging the player vehicle downwards upon contact
  }
  healcode.medkit(); //calls and runs the void medkit() script from the Heal class for displaying and moving the medkit
  healcode.healthgain(); //calls and runs the void healthgain() script from the Heal class for affecting the player's health on contact
  playercode.player(); //calls and runs the void player() script from the Player class for spinning and affecting the health of the player vehicle
  for (int i=0;i<carcode.length;i++) { //i has an initial value of 0, while i has a value less than the length of the carcode array, i=i+1
    carcode[i].traffic(); //calls and runs the void traffic() script from the Traffic class (as many times as the length of the array) for displaying and moving the oncoming vehicles
    carcode[i].carcrash(); //calls and runs the void carcrash() script from the Traffic class (as many times as the length of the array) for the collision of the oncoming and player vehicles, affecting player health and position 
  }
  enemycode.enemy(); //calls and runs the void enemy() script from the Enemy class for displaying and moving the enemy vehicle
  healcode.healthbar(); //calls and runs the void healthbar() script from the Heal class for displaying and affecting the player's healthbar
  enemycode.playerhit(); //calls and runs the void playerhit() script from the Enemy class for resetting the bullet and losing health when the player is hit
  enemycode.collision(); //calls and runs the void collision() script from the Enemy class for the collision of the enemy and player vehicles
  enemycode.bullet(); //calls and runs the void bullet() script from the Enemy class for displaying and firing the projectile
  }
  if(gameover) { //if the game has finished
   endscreen();  //calls and runs the void endscreen() script for displaying the end screen
  }
  timer(); //calls and runs the void timer() script for the in-game timer
}

void spilloil() {
  for (int i=0;i<oilcode.length;i++) { //i has an initial value of 0, while i has a value less than the length of the oilcode array, i=i+1
    oilcode[i] = new Oil(); //each value of the array calls and runs an instance of the Oil class
  }
}

void rushhour() {
  for (int i=0;i<carcode.length;i++) { //i has an initial value of 0, while i has a value less than the length of the oilcode array, i=i+1
    carcode[i] = new Traffic(); //each value of the array calls and runs an instance of the Traffic class
  }
}

void titlescreen() {
  if (carunlocked==false) {unlocked=3;} //if the second car hasn't been unlocked, display second car as locked
  else {unlocked=2;} //if the second car has been unlocked, display second car as the second car
  menucar2=loadImage("player"+str(unlocked)+".png"); //image of second choosable car on the menu is changed depending on whether it is locked or unlocked
  image(titlescreen,width/2,height/2,width,height); //draws title screen
  image(menucar1,(width/4*3)-playercode.psizex/2,(height/2)+playercode.psizey/4); //draws the default car
  image(menucar2,(width/4*3)+playercode.psizex/2,(height/2)+playercode.psizey/4); //draws the second choosable car (either as locked or unlocked)
  image(cararrow,carselect,(height/2)-playercode.psizey/2,playercode.psizex/2,playercode.psizex/2); //draws arrow above the default car to show which vehicle is selected
  image(diffarrow,(width/6)-20,diffselect,20,20); //draws arrow beside normal difficulty to show which difficulty is selected
}

void difficultyramp() {
  if (normalcheck==false) { //if the speeds weren't already set to their default values
    miscspeed=10; //sets miscspeed to 10
    enemycode.bulletspeed=12; //sets speed of the enemy bullets to 12
    for (int i=0;i<carcode.length;i++) { //i has an initial value of 0, while i has a value less than the length of the carcode array, i=i+1
      carcode[i].minspeed=11; //sets minimum value of oncoming car speed to 11
      carcode[i].maxspeed=15; //sets maximum value of oncoming car speed to 15
    } //set all speeds to their original/default values
    normalcheck=true; //speeds have been set to their default values
    hardcheck=false; //speeds are not set to their hardmode values
  }
  if (difftimer) { //if the difficulty timer has been started
    if (diffstart==false) { //if a starting time hasn't been assigned
      startdifftime=millis(); //start of the timer is equal to the current time since the program opened in milliseconds
      diffstart=true; //starting time has been assigned
    }
    currentdifftime=millis(); //current timer is equal to the current time since the program openedin milliseconds
  if (currentdifftime-startdifftime>enddifftime) { //if the current time minus the start of the timer is greater than the decided timer length
    difftimer=false; //timer hasn't been started
  }
    
    if (difftimer==false) {
      for (int i=0;i<carcode.length;i++) { //i has an initial value of 0, while i has a value less than the length of the carcode array, i=i+1
        carcode[i].maxspeed+=2;
        carcode[i].minspeed+=2;
      }
    miscspeed+=2;
    enemycode.bulletspeed+=2; //increase all speeds by a small amount each increment
    diffstart=false; //starting time hasn't been assigned
    difftimer=true; //start the timer
    }
  }
}

void difficultyhard() {
  if (hardcheck==false) { //if the speeds weren't already set to their hardmode values
    miscspeed+=50;
    enemycode.bulletspeed+=enemycode.bulletspeed;
    for (int i=0;i<carcode.length;i++) {
      carcode[i].minspeed+=50;
      carcode[i].maxspeed+=50;
    } //set all speeds to their hardmode values
    hardcheck=true; //speeds have been set to their hardmode values
    normalcheck=false; //speeds are not set to their default values
  }
}

void timer() {
  if (gamestart==false) { //if the game hasn't started
    starttime=millis(); //start of the in-game timer is equal to the current time since the program startedin milliseconds
  }
  if (gamestart&&gameover==false) { //if the game has been started but hasn't finished
  currenttime=millis()-starttime; //the current in-game time is equal to the current time since the program started in milliseconds minus the time the game was started at
 fill(#F06363);
 textFont(gamefont);
 textSize(30);
 text(str(currenttime/1000)+" Seconds",25,30); //displays the in-game timer in the top left corner
  }
}

void bkground() {
  for (int x=0;x<linex.length;x++) { //x has an initial value of 0, while i has a value less than the length of the linex array, x=x+1
    for (int y=0; y<liney.length;y++) { //y has an initial value of 0, while i has a value less than the length of the liney array, y=y+1
      fill(255);
      noStroke();
      rect(0,0-lwidth,lwidth,height+lwidth);
      rect(width-lwidth,0-lwidth,lwidth,height+lwidth);
      fill(#FFDB0D);
      rect((width/2)-lwidth/2,0,lwidth,height);
      rect(linex[x]-(lwidth/2),liney[y],lwidth,llength); //all rect lines together draw all of both the static and moving pieces of the road
    }
  }

  ly1+=miscspeed; ly2+=miscspeed; ly3+=miscspeed; //all moving parts of the road are moving downwards by the miscspeed
  if (ly1>height) { //if line1 reaches the bottom of the screen
    ly1=300*-1; //reset to above the top of the screen
  }
  if (ly2>height) { //if line2 reaches the bottom of the screen
    ly2=300*-1; //reset to above the top of the screen
  }
  if (ly3>height) { //if line3 reaches the bottom of the screen
    ly3=300*-1; //reset to above the top of the screen
  } 
}

void backgroundmusic() {
  if(gamestart && gameover==false) //if the game has started and hasn't finished
  musiccounter++; //musiccounter is set to 1, and music is allowed to play
  if(musiccounter==1) { //if the game has started and music is allowed to play
  racemusic.amp(0.5);
  racemusic.play(); //play the music
  racemusic.loop(); //loop the music, so that if it runs out it will start from the beginning
  }
  if(gamestart==false || gameover) { //if the game hasn't started or the game has ended
  racemusic.stop(); //stop the music
  musiccounter=0; //musiccounter is set to 0, and music is no allowed to play
  }
}

void endscreen() { 
  newscore=currenttime; //score of the current match is equal to the current time of the finished game
  if (newscore>highscore) {highscore=newscore;} //if the new score reached is higher than the previous highest score, the new score is now the new highscore
  if (highscore/1000>120) {carunlocked=true;} //if the highscore is higher than 120 seconds/2 minutes, the second playable car is unlocked
  if (carunlocked) //if the second car has been unlocked
  image(endscreen,width/2,height/2,width,height); //draws the end screen without the unlock reminder
  if (carunlocked==false) //if the second car hasn't been unlocked
  image(endscreenlock,width/2,height/2,width,height); //draws the end screen with the unlock reminder
  textSize(28);
  fill(255);
  text(newscore/1000+" Seconds",width/2,height/4*3); //draws the text of the new current score
  text(highscore/1000+" Seconds",width/2,(height/8*7)-20); //draws the text of the highscore
}

void keyPressed() {
  if (gamestart==false) { //if the game hasn't started
    if(key==ENTER) gamestart=true; //if the enter key is pressed, start the game
    if(key=='a') { //if the a key is pressed
      if (whichcar>1) {whichcar--; carselect-=playercode.psizex;} //if the currently selected car isn't the furthest left car, move car select arrow left, and select that car as the car being played
    }
    if(key=='d') { //if the d key is pressed
      if (whichcar<3) {whichcar++; carselect+=playercode.psizex;} //if the currently selected car isn't the furthest right car, move car select arrow right, and select that car as the car being played (purposely goes one too far right for a secret)
    }
    if(key=='w') { //if the w key is pressed
      if (hardmode) {hardmode=false; diffselect-=(playercode.psizex/4)*3;} //if the hard difficulty was selected, hardmode is no longer selected, move difficulty select arrow to normal difficulty
    }
    if(key=='s') { //if the s key is pressed
      if (hardmode==false) {hardmode=true; diffselect+=(playercode.psizex/4)*3;} //if the hard difficulty isn't selected, harmode is selected, move difficulty select arrow to hard difficulty
    }
  }
  if (gameover) { //if the game has ended
    if(key=='r') { //if the r key is pressed
      lives=3; //reset lives
      playercode.px=width/2;
      playercode.py=height/3*2; //reset player location 
      gameover=false; //game hasn't ended
      gamestart=false; //game hasn't started
      diffstart=false; //reset difficulty increase increments
      enemycode.carchase=false; //no enemy car is spawned
      enemycode.fired=false; //no enemy bullet is spawned
      enemycode.enemyy=height+playercode.psizey; //reset enemy position
      healcode.medspawned=false; //no medkit is spawned
      healcode.kity=0; //reset medkit position
      playercode.spinning=false; //player is not spinning
      for (int i=0;i<oilcode.length;i++) { //i has an initial value of 0, while i is less than the length of the oilcode array, i++
        oilcode[i].oilspawned=false; //no oils are spawned
        oilcode[i].oily=0; //reset all oil positions
        carcode[i].carspawned=false; //no oncoming cars are spawned
        carcode[i].cary=0; //reset all oncoming car positions
      }
      miscspeed=10; //sets miscspeed to 10
      enemycode.bulletspeed=12; //sets speed of the enemy bullets to 12
      enemycode.shots=0; //resets amount of bullets fired from enemy to 0 so it doesn't carry over games
      for (int i=0;i<carcode.length;i++) { //i has an initial value of 0, while i has a value less than the length of the carcode array, i=i+1
        carcode[i].minspeed=11; //sets minimum value of oncoming car speed to 11
        carcode[i].maxspeed=15; //sets maximum value of oncoming car speed to 15
      } //set all speeds to their original/default values
    }
  }
  if(key=='w') wPressed=true; //if the w key is pressed, boolean to enable player movement upwards is true
  if(key=='a') aPressed=true; //if the a key is pressed, boolean to enable player movement to the left is true
  if(key=='s') sPressed=true; //if the s key is pressed, boolean to enable player movement downwards is true
  if(key=='d') dPressed=true; //if the d key is pressed, boolean to enable player movement to the right is true
}

void keyReleased() {
  if(key=='w') wPressed=false; //if the w key is pressed, boolean to enable player movement upwards is false
  if(key=='a') aPressed=false; //if the a key is pressed, boolean to enable player movement to the left is false
  if(key=='s') sPressed=false; //if the s key is pressed, boolean to enable player movement downwards is false
  if(key=='d') dPressed=false; //if the d key is pressed, boolean to enable player movement to the right is false
}
