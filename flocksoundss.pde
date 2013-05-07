import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim       minim;
AudioOutput out;

int n=200;
Flock flock;

int ss;
ArrayList<SoundCircle> circles = new ArrayList<SoundCircle>();

int octaves = 5;

int toneClr = 256/12;

PGraphics flockGraphic;

void setup() {
  size(displayWidth, displayHeight,P2D);
  // try-out drawinng the flock on an graphic, with fade, no background
  /*  flockGraphic = createGraphics(displayWidth, displayHeight);
   flockGraphic.beginDraw();
   flockGraphic.colorMode(HSB);
   flockGraphic.endDraw(); */
  flock = new Flock();
  colorMode(HSB, 12);

  minim = new Minim(this);
  out = minim.getLineOut();
  ellipseMode(RADIUS);
  rectMode(CORNER);
  int baseTone = (int) random(28, 40);
  // get the tones from the function jazzchord, in the notes tab
  int[] tones = new int[octaves*4];
  for (int oct = 0; oct <octaves;oct++) {
    for (int i=0; i < 4; i++) { //chord 
      tones[oct*4+i] = baseTone + 12*oct +jazzchord(i);
    }
  }
  ss = tones.length;
  // Add an initial set of boids into the system
  for (int i = 0; i < n; i++) {
    Boid b = new Boid(width/2, height/2);
    flock.addBoid(b);
  }
  for (int i=0; i < ss;i++)
    circles.add(new SoundCircle(tones[i]));
  smooth();
}

void draw() {
  background(0);
  flock.run();
  /*
  flockGraphic.beginDraw();
   flockGraphic.fill(255,255,255,255);
   flockGraphic.rect(-2,-2,width+5,height+5);
   flockGraphic.endDraw();
   //  image(flockGraphic, 0, 0);
   // Instructions
   //  fill(0);
   */
  for (int i=0; i < ss;i++) {
    circles.get(i).draw();
  }
}

