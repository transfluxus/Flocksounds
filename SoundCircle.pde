//float[] tones = {130.813f,164.814f,195.998f,261.626f,329.628f,391.995f};
//import ddf.minim.effects.*;

class SoundCircle {

  PVector location;
  color clr;
  float r;

  float freq;
  float amp =0;

  Oscil       wave;
  int tone;

  int simpleType;
  Wavetable type;

  int boidsInMyArea [] = new int [3];
  ArrayList<IIRFilter> filters = new ArrayList<IIRFilter>();


  public SoundCircle(int tone) {
    this.tone = tone;
    location = new PVector((int) random(width), (int) random(height));
    clr = color(tone%12, 8, 10);//color((int) random(255),(int) random(255),(int) random(255));
    r = 30;//random(20,50);
    freq = getFreq(tone);//tones[tone];//(int) random(50,5000);
    println(tone + " "+freq);
    simpleType = (int) random(3);
    switch(simpleType) {
    case 0: 
      type = Waves.SINE;
      break;
    case 1:
      type= Waves.SAW;
      break;
    case 2:
      type = Waves.SQUARE;
    }
    wave = new Oscil( freq, amp, type);
    wave.patch( out );
  } 

  void draw() {

    int domType = -1;
    int type = -1;
    int sum = 0;

    for (int i=0; i < 3; i++) {
      if ( boidsInMyArea [i] > domType &&  boidsInMyArea [i]!= 0) {
        domType =  boidsInMyArea [i];
        type = i;
      }
      sum +=  boidsInMyArea [i];
    }

    float rel = sum/ (float)n;

    //    if (type != -1) {
    //
    //
    //
    //      Wavetable table=null;
    //      switch(type) {
    //      case 0: 
    //        table = Waves.SINE;
    //        break;
    //      case 1:
    //        table= Waves.SAW;
    //        break;
    //      case 2:
    //        table = Waves.SQUARE;
    //      }
    //      wave = new Oscil( freq, rel, table);
    //      // patch the Oscil to the output
    //      wave.patch( out );
    //    } 
    //    else 
    wave.setAmplitude (rel);

    int opa = (int) map(rel, 0, 1, 6, 12);
    clr = color(tone%12, 12-rel*12, 12-rel*12, opa );
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
    for (int i = 0; i<3; i ++) { 
      boidsInMyArea [i] = 0;
    }
  }

  void addBoid(int type) {
    boidsInMyArea [type]++;
  }

}

