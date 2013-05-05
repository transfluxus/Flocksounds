import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim       minim;
AudioOutput out;

int n=200;
Flock flock;

int ss;
ArrayList<SoundCircle> circles = new ArrayList<SoundCircle>();


void setup() {
  size(800, 600);
  flock = new Flock();
  colorMode(HSB, 12);
  minim = new Minim(this);
  out = minim.getLineOut();
  ellipseMode(RADIUS);
  rectMode(CORNER);
  int baseTone = (int) random(28, 40);
  int[] tones = {
    baseTone, baseTone+4, baseTone+7, baseTone+9, baseTone+12, baseTone+16, baseTone+19, baseTone+22, baseTone +24, baseTone +28, baseTone +31, 
    baseTone +33
  };
  ss = tones.length;
  for (int i=0; i < ss;i++)
    circles.add(new SoundCircle(tones[i]));
  // Add an initial set of boids into the system
  for (int i = 0; i < n; i++) {
    Boid b = new Boid(width/2, height/2);
    flock.addBoid(b);
  }
  smooth();
}

void draw() {
  background(12, 0, 0);
  flock.run();

  // Instructions
  fill(0);
  for (int i=0; i < ss;i++) {
    circles.get(i).draw();
//    circles.get(i).freq++;
  }
}

