import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim       minim;
AudioOutput out;

Flock flock;

PImage boidImage;

void setup() {
  size(displayWidth, displayHeight, P2D);
  ellipseMode(RADIUS);  
  rectMode(CENTER);
  initSounds();
  colorMode(HSB, n); 

  flock = new Flock();
  // Add an initial set of boids into the system
  initFlock();
  if (boidsMode==GRADIANTS) {
    imageMode(CENTER);
    boidImage= loadImage("a.png");
    blendMode(ADD);
  }
  smooth();
  background(bgClr);
}

void draw() {
if(clearFrameScreen)
background(bgClr);
else if(screenFade) {
  
 fill(red(bgClr),green(bgClr),blue(bgClr),fadeStrength);
rect(width/2,height/2,width+10,height+10); 
}
  flock.run();
  if (captureImages)
    saveFrame("pics/frame-##.bmp");
  if (autoEnd>0 && frameCount == autoEnd) {
    exit();
  }
  updateSound();
}


// bugs
// bezierpoints btw. boid and soundforms
// falsche farben der bezierkurven
// falsche drehrichtung der sf

// ideen:
// klaviertasten

