class SoundForm {

  int index;
  PVector location;
  color clr;
  float r;

  float freq;
  float amp =0;

  Oscil       wave;

  int tone, oct;

  int simpleType;
  Wavetable type;

  ArrayList<Boid> boidsInMyArea = new ArrayList<Boid>();

  public SoundForm(int index, int tone) {
    this.index = index;
    this.tone = tone;
    oct = tone%12;
    location = new PVector((int) random(width), (int) random(height));
    clr = color(tone%12, 8, 10);//color((int) random(255),(int) random(255),(int) random(255));
    r = 30;//random(20,50);
    freq = getFreq(tone);//tones[tone];//(int) random(50,5000);
    //   println(tone + " "+freq);
    simpleType = (int) random(4);
    switch(simpleType) {
    case 0: 
      type = Waves.SINE;
      break;
    case 1:
      type= Waves.SAW;
      break;
    case 2:
      type = Waves.SQUARE;
      break;
    case 3:
      type =Waves.randomNoise();
    }
    wave = new Oscil( freq, amp, type);
    wave.patch( out );
  } 

  void draw() {

    int domType = -1;
    int type = -1;
    int sum = boidsInMyArea.size();

    float rel = sum/ (float)n;

    wave.setAmplitude (rel);

    int opa = (int) map(rel, 0, 1, colorRange/2, colorRange);
    //clr = color(tone%12, 12-octaves+oct, 12-rel*12, opa );
    clr = color((tone%toneClr)*toneClr, (toneClr-octaves+oct)*toneClr, (toneClr-rel*toneClr)*toneClr, opa );

    fill(clr);
    noStroke();
    r = map(rel, 0, 1, 20, 60);

    switch(simpleType) {
    case 0: 
      ellipse(location.x, location.y, 2*r, 2*r); 
      break;
    case 1:
      triangle(location.x+cos(0)*r, location.y+sin(0)*r, 
      location.x+cos(radians(120))*r, location.y+sin(radians(120))*r, 
      location.x+cos(radians(240))*r, location.y+sin(radians(240))*r);
      break;
    case 2:
      //type = Waves.SQUARE;
      rect(location.x-r, location.y-r, 2*r, 2*r);
    }
  }

  void addBoid(Boid b) {
    boidsInMyArea.add(b);
  }
  
  void removeBoid(Boid b) {
      boidsInMyArea.remove(b);
  }
}

