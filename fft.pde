import ddf.minim.analysis.*;
import ddf.minim.*;

AudioPlayer jingle;

FFT fftLog;

void initSounds() {
  minim = new Minim(this);
  jingle = minim.loadFile(song, 1024);
  jingle.loop();
  fftLog = new FFT( jingle.bufferSize(), jingle.sampleRate() );
  fftLog.logAverages( 22, 5 );
  n = fftLog.avgSize();
  println(n);
}

void updateSound() {
  fftLog.forward( jingle.mix );
  for(int i=0; i < n;i++) {
 //  print(fftLog.getAvg(i)+" "); 
 float acc = constrain(fftLog.getAvg(i)*.5f,0,1);
   flock.get(i).maxforce = max(0.2f,acc);
   flock.get(i).maxspeed = max(1f,acc*3);
  }
 // println(" ");
}


