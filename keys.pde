void keyPressed() {
  switch(key) {
  case 'f':
    initFlock();
    break;
  case 's':
    saveFrame("img-##"); 
    break;
  }
}

