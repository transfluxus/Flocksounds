void keyPressed() {
  switch(key) {
  case 's': 
    initForms();
    break;
  case 'a': 
    renderForms = !renderForms;
    break;
  case 'f':
    initFlock();
    break;
  }
}

