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

PGraphics flockGraphic;



void setup() {
  size(displayWidth, displayHeight, P2D);
  // try-out drawinng the flock on an graphic, with fade, no background
  /*  flockGraphic = createGraphics(displayWidth, displayHeight);
   flockGraphic.beginDraw();
   flockGraphic.colorMode(HSB);
   flockGraphic.endDraw(); */
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
//  oscInit();
//  soundFormInfo_Send();
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
    forms.add(new SoundForm(i,tones[i]));
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
    //else if (
  }
}

void mousePressed() {
 if(mouseButton==RIGHT) {
   for (int i=0; i < ss;i++)
 if (forms.get(i).location.dist(new PVector(mouseX, mouseY)) <forms.get(i).r ) {
  println(hue(forms.get(i).clr)+ " "+forms.get(i).tone);
   break;
 }
 } 
}

// bugs
// bezierpoints btw. boid and soundforms
// falsche farben der bezierkurven
// falsche drehrichtung der sf

// ideen:
// klaviertasten


