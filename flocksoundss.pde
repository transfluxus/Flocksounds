import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim       minim;
AudioOutput out;

Flock flock;

int ss;
ArrayList<SoundForm> forms = new ArrayList<SoundForm>();

int baseOctave = 1;
int octaves = 5;
int[] tones;

int colorRange= 36;
int toneClr = colorRange/12;
int strongColor= (int)(colorRange*0.9);

AudioRecorder recorder;
SoundForm selected;

void setup() {
  size(displayWidth, displayHeight, P2D);
  smooth();
  frameRate(25);
  ellipseMode(RADIUS);
  rectMode(CENTER);
  imageMode(CENTER);
  //  size(800,600 , P2D);
  if (randomSeed != -1)
    randomSeed(randomSeed);

  flock = new Flock();
  colorMode(HSB, colorRange);

  minim = new Minim(this);
  out = minim.getLineOut();

  initSounds();
  // Add an initial set of boids into the system
  initFlock();
  initForms();
  if (boidsMode==GRADIANTS) {
    boidImage= loadImage("a.png");
    blendMode(MULTIPLY);
  }

  if (recordSound) {
    recorder = minim.createRecorder(out, "myrecording.wav", true);
    recorder.beginRecord();
  }
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
    Boid b = new Boid(width/2, height/2,flock.nextID++);
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
  for (int i=0; i < ss;i++) 
    forms.get(i).draw();

  if (selected != null)
    selected.location.set(mouseX, mouseY, 0);
  if (captureImages)
    saveFrame("pics/frame-####.bmp");
  if (autoEnd>0 && frameCount == autoEnd) {
    if (recordSound) {
      recorder.endRecord();
      recorder.save();
    }   
    exit();
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
    for (int i=0; i < ss;i++)
      if (forms.get(i).location.dist(new PVector(mouseX, mouseY)) <forms.get(i).r ) {
        selected = forms.get(i);
        break;
      }
}

void mouseReleased() {
  selected = null;
}

// bugs
// bezierpoints btw. boid and soundforms
// falsche farben der bezierkurven
// falsche drehrichtung der sf

// ideen:
// klaviertasten

