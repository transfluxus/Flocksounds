
float getFreq(int n) {
  return pow(2, (n-49)/12f)*440f;
}

int jazzchord(int i ) {
  int[] c = { 
    0, 4, 7, 9
  };
  return c[i];
}

UGen filter(SoundForm form) {
  UGen  osc = form.wave;
  IIRFilter filt;

  Oscil cutOsc;
  Constant cutoff;

  filt = new BandPass(form.freq, 100, out.sampleRate());
  cutOsc = new Oscil(1, 200, Waves.SINE);
  // offset the center value of the Oscil by 1000
  cutOsc.offset.setLastValue( 1000+random(1000) );
  // patch the oscil to the cutoff frequency of the filter
  cutOsc.patch(filt.cutoff);
  // patch the sawtooth oscil through the filter and then to the output
  return osc.patch(filt);
}

UGen noiseFilter(SoundForm sf) {
  IIRFilter  filt = new BandPass(sf.freq, 50, out.sampleRate());
  return sf.wave.patch(filt);
}

