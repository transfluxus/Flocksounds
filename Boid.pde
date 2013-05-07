// From The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Boid class
// Methods for Separation, Cohesion, Alignment added


class Boid {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  int type;
  boolean filtering;
  color clr;
  IIRFilter filt;
  // is set in the align method, see render for effect
  int nbsSz;
  
  // cohesion-center;
  PVector cohesionPoint;
  
  SoundCircle minCircle, scnClosest;

  Boid(float x, float y) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    location = new PVector(x, y);
    r = 3.0;
    maxspeed = 3;
    maxforce = 0.05;

    type = (int) random (0, 3);
  }

  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    // get the closest soundcircle
    calcSss();
    println(minCircle);
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void calcSss() {
    float minDist = 30000;
    minCircle = null;

    for (int i=0; i < ss; i++) {
      SoundCircle c = circles.get(i);
      float distance = location.dist(c.location);
      if (distance < minDist) {
        minDist = distance;
        scnClosest = minCircle;
        minCircle = c;
      }
    }
    minCircle.addBoid(type);
  }
  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    if (minCircle != null) {
      // not working yet: colorLerp between 1st and 2nd closest
      //      if (scnClosest != null) {
      //        float min_Scn_rel = location.dist(scnClosest.location) / location.dist(minCircle.location);
      //        fill(map(min_Scn_rel, 0, 1, hue(minCircle.clr), 2*hue(minCircle.clr)-hue(scnClosest.clr)) , 12, 12);
      //      }
      //      else
      fill(hue(minCircle.clr), 12, 12);
    }
    else 
      fill(12, 0, 12);
    //stroke(0);
    noStroke();
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    if (random(1) < nbsSz/(float)n) {
      scale(2+5*(nbsSz/(float)n));
    }
    switch (type) {
    case 0:
      beginShape(TRIANGLES);
      vertex(0, -r*2);
      vertex(-r, r*2);
      vertex(r, r*2);
      endShape();
      break;
    case 1:
      ellipse (0, 0, r, r);
      break;
    case 2:
      rect (-r, -r, 2*r, 2*r);
      break;
    }
    popMatrix();
    noFill();
    stroke(minCircle.clr);
//    line(location.x, location.y, minCircle.location.x, minCircle.location.y);
 // cohesionPoint is calculated in cohesion.
  bezier(location.x, location.y,
  cohesionPoint.x,cohesionPoint.y,
  cohesionPoint.x,cohesionPoint.y,
  minCircle.location.x, minCircle.location.y);
  }

  // Wraparound
  void borders() {
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      nbsSz = count;
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      cohesionPoint = sum;
      return seek(sum);  // Steer towards the location
    } 
    else {
      cohesionPoint = location;
      return new PVector(0, 0);
    }
  }
}

