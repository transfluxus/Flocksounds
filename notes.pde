float getFreq(int n) {
 return pow(2,(n-49)/12f)*440f;
} 

int jazzchord(int i ) {
  int[] c = { 0, 4,7,9};
 return c[i]; 
}
