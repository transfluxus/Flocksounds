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

int colorRange= 180;
int toneClr = colorRange/12;
int strongColor= (int)(colorRange*0.9);

//PGraphics flockGraphic;

PImage boidImage;

SoundForm selected;
AudioRecorder recorder;

void setup() {
//  size(displayWidth, displayHeight, P2D);
  size(800,600 , P2D);
  if(randomSeed != -1)
    randomSeed(randomSeed);
  // try-out drawinng the flock on an graphic, with fade, no background
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
  if (boidsMode==GRADIANTS) {
    boidImage= loadImage("a.png");
    blendMode(MULTIPLY);
  }
  smooth();
  frameRate(25);
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
    Boid b = new Boid(width/2, height/2, flock.nextID++);
    flock.addBoid(b);
  }
}

void initForms() {
  forms.clear();
  for (int i=0; i < ss;i++)
    forms.add(new SoundForm(i, tones[i]));
}

void draw() {
  background(0);
  flock.run();
  noStroke();
  for (int i=0; i < ss;i++) {
    forms.get(i).draw();
  }
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
//  println(frameRate);
}



void mousePressed() {
  if (mouseButton==RIGHT) {
    for (int i=0; i < ss;i++)
      if (forms.get(i).location.dist(new PVector(mouseX, mouseY)) <forms.get(i).r ) {
        println(hue(forms.get(i).clr)+ " "+forms.get(i).tone);
        break;
      }
  } 
  else
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

