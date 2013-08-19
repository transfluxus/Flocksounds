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

void initSounds() {
  minim = new Minim(this);
  jingle = minim.loadFile(song, 1024);
  jingle.loop();
  fftLog = new FFT( jingle.bufferSize(), jingle.sampleRate() );
  fftLog.logAverages( 22, 30 );
  n = fftLog.avgSize();
}

void initFlock() {  
  for (int i = 0; i < n; i++) {
    Boid b = new Boid(width/2, height/2, i);
    flock.addBoid(b);
  }
}

void draw() {
if(clearFrameScreen)
background(bgClr);
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

