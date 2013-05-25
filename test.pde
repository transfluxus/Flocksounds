void mousePosToGetBoidColorTest() {
  SoundForm first, second;
  Boid b = new Boid(mouseX, mouseY);
  b.calcSss();
  color c = b.closeFormColors();
  stroke(colorRange);
  line(b.minCircle.location.x, b.minCircle.location.y, b.location.x, b.location.y);
  stroke(colorRange*.5f);
  line(b.scnClosest.location.x, b.scnClosest.location.y, b.location.x, b.location.y);
  noStroke();
  fill(hue(c), colorRange, colorRange);
  ellipse(mouseX, mouseY, 8, 8);
}

