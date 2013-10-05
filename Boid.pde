// From The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Boid class
// Methods for Separation, Cohesion, Alignment added

int nbDist = 100;


class Boid {

  int id;

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

    color clr;

  // is set in the align method, see render for effect
  int nbsSz;

  // cohesion-center;
  PVector cohesionPoint;


  Boid(float x, float y, int id) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    location = new PVector(x, y);
    r = 5.0;
    maxspeed = 3;
    maxforce = 0.05;
    this.id = id;
    clr = color(id);
  }

  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    // get the closest SoundForm
    borders();
    if (renderFlock)
      render();
    //    println(lineInvert+ " "+minDist);
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
    sep.mult(1.0);
    ali.mult(1.5);
    coh.mult(1.1);
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
    if (!renderOrder) {
      renderNbs();
      renderBoid();
    }
  }

  void renderBoid() {
    if (renderBoid) {
      float theta = velocity.heading2D() + radians(90);
      noStroke();
      pushMatrix();
      translate(location.x, location.y);
      rotate(theta);
      if (boidsMode == GRADIANTS) {
        tint(id, n*GradiantTint);
        image(boidImage, 0, 0, gradiantSize, gradiantSize);
      } 
      else if (boidsMode == FORMS) {
        fill(clr);
        beginShape(TRIANGLES);
        vertex(0, -r*2);
        vertex(-r, r*2);
        vertex(r, r*2);
        endShape();
      }
      popMatrix();
    }
  }

  void renderNbs() {
    if (renderNbs) {
      for (int i=1; i <= lineConnect;i++) {     
        strokeWeight(maxConnectStrokeWeight/i);
        if (id-i>=0) {
          Boid b = flock.boids.get(id-i);
          stroke(id, 2*n*max(0, nbDist-location.dist(b.location)));
          line(location.x, location.y, b.location.x, b.location.y);
        }
        if (id+i<n) {
          Boid b = flock.boids.get(id+i);
          stroke(id, 2*n*max(0, nbDist-location.dist(b.location)));
          line(location.x, location.y, b.location.x, b.location.y);
        }
      }
    }
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
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < nbDist) && (isNB(other) || !nbAlign)) {
        sum.add(PVector.mult(other.velocity, neighbourhoodStrength(other)));
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
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < nbDist) && (isNB(other) || !nbCohesion)) {
        PVector add = PVector.lerp(location, other.location, neighbourhoodStrength(other));
        sum.add(add); // Add location
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

  boolean isNB(Boid b) {
    return abs(id-b.id)< lineConnect;
  }

  float neighbourhoodStrength(Boid b) {
    if (abs(id-b.id)<=lineConnect)
      return  (exp(-sq(abs(id-b.id))/(sq(lineConnect))));
    else return 0;
  }
}

