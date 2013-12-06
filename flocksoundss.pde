import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim       minim;
AudioOutput out;

int n=400;
Flock flock;

int ss;
ArrayList<SoundForm> forms = new ArrayList<SoundForm>();

int baseOctave = 1;
int octaves = 5;
int[] tones;

int colorRange= 36;
int toneClr = colorRange/12;

void setup() {
  size(500, 500, P2D);

  flock = new Flock();
  colorMode(HSB, colorRange);

  minim = new Minim(this);
  out = minim.getLineOut();
  ellipseMode(RADIUS);
  rectMode(CENTER);
  initSounds();
  // Add an initial set of boids into the system
  initFlock();
  initForms();
  smooth();
}

void initSounds() {
  int baseTone = (int) random(baseOctave*12, (baseOctave+1)*12);
  // get the tones from the function jazzchord, in the notes tab
  tones = new int[octaves*4];
  for (int oct = 0; oct <octaves;oct++) {
    for (int i=0; i < 4; i++) { //chord 
      tones[oct*4+i] = baseTone + 12*oct +jazzchord(i);
    }
  }
  ss = tones.length;
}

void initFlock() {  
  for (int i = 0; i < n; i++) {
    Boid b = new Boid(width/2, height/2);
    flock.addBoid(b);
  }
}

void initForms() {
  for (SoundForm sf: forms)
    sf.unPatch();
  forms.clear();
  for (int i=0; i < ss;i++)
    forms.add(new SoundForm(i, tones[i]));
}

void draw() {
  background(0);
  flock.run();
  fill(0);

  noStroke();
  for (int i=0; i < ss;i++) {
    forms.get(i).draw();
  }
}

void keyPressed() {
  switch(key) {
  case 's': 
    initForms();
    break;
  case 'f':
    initFlock();
    break;
  case 'g': 
    {
      gifExport.setDelay(1);
      gifExport.addFrame();
      break;
    } case 'e' : {
      gifExport.finish();
      break;
    }
    //else if (
  }
}

// bugs
// bezierpoints btw. boid and soundforms
// falsche farben der bezierkurven
// falsche drehrichtung der sf

// ideen:
// klaviertasten

