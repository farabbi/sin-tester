/* Sin Tester - A game to test your dealy sin
 * Made by Jiuxin Zhu and Tamanda Msosa
 * A mini program in Costumes as Game Controllers course
 */
 
import processing.serial.*;
import processing.sound.*;

Serial myPort;

/*  SET TAB = 4 SPACES
 *  stage    scene
 *  0        ready...go
 *  1        pride
 *  2        greed
 *  3        lust
 *  4        envy
 *  5        gluttony
 *  6        wrath
 *  7        sloth
 *  8        game finished
 */
int stage = 0;
int old_stage = 0;
boolean is_game_over = false; // game over flag
long start_time = 0; // used for timer (animation)
long game_time = 0;

// images
PImage charactor_stop;
PImage charactor_move;
float xpos = 0; // charactor's x position
float ypos = 0; // charactor's y position
PImage ready;
PImage pride;
PImage greed;
PImage lust;
PImage envy;
PImage gluttony;
PImage wrath;
PImage sloth;
PImage finish;

// soundfiles
SoundFile ready_bgm;
SoundFile pride_bgm;
SoundFile greed_bgm;
SoundFile lust_bgm;
SoundFile envy_bgm;
SoundFile gluttony_bgm;
SoundFile wrath_bgm;
SoundFile sloth_bgm;
SoundFile game_finish;
SoundFile game_over;

void setup() {
  size(800, 600);
  
  // set the serial port
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  // don't generate a serialEvent() unless you get a newline character
  myPort.bufferUntil('\n');
  
  // Images must be in the "data" directory to load correctly
  charactor_stop = loadImage("data/charactor_stop.png");
  charactor_move = loadImage("data/charactor_move.png");
  ready = loadImage("data/ready.png");
  pride = loadImage("data/pride.png");
  greed = loadImage("data/greed.png");
  lust = loadImage("data/lust.png");
  envy = loadImage("data/envy.png");
  gluttony = loadImage("data/gluttony.png");
  wrath = loadImage("data/wrath.png");
  sloth = loadImage("data/sloth.png");
  finish = loadImage("data/finish.png");
  
  // load sound files
  ready_bgm = new SoundFile(this, "pacman.mp3");
  pride_bgm = new SoundFile(this, "olympic.mp3");
  greed_bgm = new SoundFile(this, "money.mp3");
  lust_bgm = new SoundFile(this, "for_lust.mp3");
  envy_bgm = new SoundFile(this, "for_envy.mp3");
  gluttony_bgm = new SoundFile(this, "mccas.mp3");
  wrath_bgm = new SoundFile(this, "for_wrath.mp3");
  sloth_bgm = new SoundFile(this, "lazy.mp3");
  game_finish = new SoundFile(this, "mario_finish.mp3");
  game_over = new SoundFile(this, "mario_die.mp3");
  
  play_bgm();
  start_time = millis();
}

void draw() {
  if (!is_game_over) {
    timer();
    draw_background();
    draw_road();
    draw_charactor();
  } else {
    // game over effect
    draw_background();
    draw_road();
    if (ypos < 700) {
      ypos = ypos + 5;
    }
    draw_charactor();
  }
}

void draw_background() {
  // background pictures
  imageMode(CORNER);
  if (stage == 0) {
    image(ready, 0, 0);
  } else if (stage == 1) {
    image(pride, 0, 0);
  } else if (stage == 2) {
    image(greed, 0, 0);
  } else if (stage == 3) {
    image(lust, 0, 0);
  } else if (stage == 4) {
    image(envy, 0, 0);
  } else if (stage == 5) {
    image(gluttony, 0, 0);
  } else if (stage == 6) {
    image(wrath, 0, 0);
  } else if (stage == 7) {
    image(sloth, 0, 0);
  } else if (stage == 8) {
    image(finish, 0, 0);
  }
}

void draw_road() {
  noStroke();
  if (stage == 0) {
    fill(0, 0, 0); // black
  } else if (stage == 1) {
    fill(164, 31, 242); // purple
  } else if (stage == 2) {
    fill(30, 243, 15); // green
  } else if (stage == 3) {
    fill(255, 90, 184); // pink
  } else if (stage == 4) {
    fill(179, 106, 23); // brown
  } else if (stage == 5) {
    fill(255, 230, 0); // yellow
  } else if (stage == 6) {
    fill(255, 0, 17); // red
  } else if (stage == 7) {
    fill(255, 255, 255); // white
  } else if (stage == 8) {
    fill(164, 31, 242); // purple
  }
  rect(0, 250, 800, 100);
}

void draw_charactor() {
  if (game_time <= 3000) {
    // 0~3s, ready stage
    xpos = 0;
    ypos = 300;
  } else {
    xpos = ((game_time - 3000) % 10000) * 800 / 10000; // charactor should move from left to right of the screen in 10 seconds (10,000 ms)
    //ypos = 300; // should adjust according to the sensor
  }
  
  // in 200 ms time split, image remains same; between each split, change the image
  imageMode(CENTER);
  int split = (int)game_time / 200;
  if (split % 2 == 0) {
    image(charactor_stop, xpos, ypos);
  } else {
    image(charactor_move, xpos, ypos);
  }
}

void play_bgm() {
  // bgms
  if (stage == 0) {
    ready_bgm.play();
  } else if (stage == 1) {
    ready_bgm.stop();
    pride_bgm.play();
  } else if (stage == 2) {
    pride_bgm.stop();
    greed_bgm.play();
  } else if (stage == 3) {
    greed_bgm.stop();
    lust_bgm.play();
  } else if (stage == 4) {
    lust_bgm.stop();
    envy_bgm.play();
  } else if (stage == 5) {
    envy_bgm.stop();
    gluttony_bgm.play();
  } else if (stage == 6) {
    gluttony_bgm.stop();
    wrath_bgm.play();
  } else if (stage == 7) {
    wrath_bgm.stop();
    sloth_bgm.play();
  } else if (stage == 8) {
    sloth_bgm.stop();
    game_finish.play();
  }
}

void timer() {
  game_time = millis() - start_time;
  if (game_time <= 3000) {
    // 0~3s, ready stage
    stage = 0;
  } else if (game_time <= 13000) {
    // 3~13s, 1st stage: pride
    stage = 1;
  } else if (game_time <= 23000) {
    // 13~23s, 2nd stage: greed
    stage = 2;
  } else if (game_time <= 33000) {
    // 23~33s, 3rd stage: lust
    stage = 3;
  } else if (game_time <= 43000) {
    // 33~43s, 4th stage: envy
    stage = 4;
  } else if (game_time <= 53000) {
    // 43~53s, 5th stage: gluttony
    stage = 5;
  } else if (game_time <= 63000) {
    // 53~63s, 6th stage: wrath
    stage = 6;
  } else if (game_time <= 73000) {
    // 63~73s, 7th stage: sloth
    stage = 7;
  } else {
    // 73s~, game finished
    stage = 8;
  }
  if (stage != old_stage) {
    play_bgm();
    old_stage = stage;
  }
}

float highest = 0;
float lowest = 10e9;

void serialEvent(Serial myPort) {
  // get sensor values
  String str = myPort.readStringUntil('\n');
  float val = float(str);
  
  println(val);
  
  if (game_time <= 3000) {
    // record the highest and lowest emotion value of player
    if (val > highest) {
      highest = val;
    }
    if (val < lowest) {
      lowest = val;
    }
  } else if (!is_game_over) {
    // after ready stage
    ypos = map(val, lowest, highest, 350, 250);
    if ((ypos > 350 || ypos < 250) && stage < 8) {
      is_game_over = true;

      // stop whatever bgm which is playing and play game over sound
      pride_bgm.stop();
      greed_bgm.stop();
      lust_bgm.stop();
      envy_bgm.stop();
      gluttony_bgm.stop();
      wrath_bgm.stop();
      sloth_bgm.stop();
      game_over.play();
    }
  }
}
