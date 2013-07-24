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
  case '+':
    flock.edit(10);
    break;
  case '-':
    flock.edit(-10);
    break;
  }
  switch(keyCode) {
  case UP:
    flock.applyForce(new PVector(0, -3));
    break;
      case DOWN:
    flock.applyForce(new PVector(0, 3));
    break;
     case LEFT:
    flock.applyForce(new PVector(-3, 0));
    break;
      case RIGHT:
    flock.applyForce(new PVector(3, 0));
    break; 
  }
}
