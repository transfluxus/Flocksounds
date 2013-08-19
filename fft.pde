import ddf.minim.analysis.*;
import ddf.minim.*;

AudioPlayer jingle;

FFT fftLog;

void updateSound() {
  fftLog.forward( jingle.mix );
  for(int i=0; i < n;i++) {
 //  print(fftLog.getAvg(i)+" "); 
 float acc = constrain(fftLog.getAvg(i)*.5f,0,1);
   flock.get(i).maxforce =acc;
   flock.get(i).maxspeed = max(0.1f,acc*3);
  }
 // println(" ");
}


