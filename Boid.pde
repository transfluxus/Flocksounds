
// for line to soundform blink animation
float lineSpeed = 10;

HashMap<Integer, ArrayList<Boid>> groups = new HashMap<Integer, ArrayList<Boid>>();

float neighbordist = 50;

class Boid {

  final int id;
  int groupID;

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  int type;
  color clr;
  boolean[] closeToBorder= new boolean[4];

  PVector sumVel=new PVector();
  PVector sumLoc=new PVector();
  int nbCount;
  // cohesion-center, for bezier curve to soundform
  PVector cohesionPoint;

  SoundForm minCircle, scnClosest;

  float minDist;
  float lineInvert = 0;

  Boid(float x, float y, int id) {
    this.id = id;
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    location = new PVector(x, y);
    r = 5.0;
    maxspeed = 3+random(- flock.maxspeed_Deriv, flock.maxspeed_Deriv);
    maxforce = 0.05;
    type = (int) random (0, 3);
  }

  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    // get the closest SoundForm
    calcSss();
    borders();
    if (renderFlock)
      render();
    lineInvert+=lineSpeed;
    //    println(lineInvert+ " "+minDist);
  }

  void initGroup() {
    ArrayList<Boid> myGroup = new ArrayList<Boid>();
    myGroup.add(this);
    groupID = id;
    groups.put(groupID, myGroup);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    getNeighbours(boids);
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

  void applyForce(PVector force) {
    acceleration.add(force);
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
    checkCloseToBorder();
  }

  void calcSss() {
    minDist = 30000;
    float min2Dist = 30000;
    SoundForm minCircle = null;

    for (int i=0; i < ss; i++) {
      SoundForm c = forms.get(i);
      float distance = location.dist(c.location);
      if (distance < minDist) {
        minDist = distance;
        scnClosest = minCircle;
        minCircle = c;
      } 
      else       if (distance < min2Dist) {
        min2Dist = distance;
        scnClosest = c;
      }
    }
    if (this.minCircle != null && this.minCircle != minCircle)
      this.minCircle.removeBoid(this);
    this.minCircle = minCircle;
    minCircle.addBoid(this);
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

  PVector seek(PVector target, float force) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.setMag(force);  // Limit to maximum steering force
    return steer;
  }

  void render() {
    float theta = velocity.heading2D() + radians(90);
    color fillColor=closeFormColors();
    noStroke();
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    // nice blinking effect
    if (random_BoidScaleUp && random(1) < nbCount/(float)n) {
      scale(2+5*(nbCount/(float)n));
    }
    if (boidsMode == GRADIANTS) {
      tint(hue(fillColor), strongColor, strongColor, colorRange*0.2f);
      image(boidImage, 0, 0, 60, 60);
    } 
    else if (boidsMode == FORMS) {
      //    println(type + " "+fillColor);
      fill(fillColor);
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
    } 
    else if ( boidsMode == SIMPLE) {
      stroke(colorRange);
      //     if (closeToBorder != 0)
      //       stroke(0, colorRange, colorRange);
      line(0, 0, 0, 10);
    }
    popMatrix();
    noFill();
    //  curves to the soundforms
    if (showCurves_boidToForm) {
      if (lineInvert>minDist) { // line blink effect
        stroke((int)(colorRange*0.5+ hue(minCircle.clr))%colorRange, strongColor, strongColor);
        lineInvert =0;
      } 
      else 
        stroke(minCircle.clr);
      bezier(location.x, location.y, 
      cohesionPoint.x, cohesionPoint.y, 
      cohesionPoint.x, cohesionPoint.y, 
      minCircle.location.x, minCircle.location.y);
    }
  }

  color closeFormColors() {
    float minDist = location.dist(minCircle.location);
    float min_Scn_rel = minDist / (minDist+location.dist(scnClosest.location));
    float div =  hue(scnClosest.clr) - hue(minCircle.clr) ;
    boolean start1 = div < colorRange/2 && div >0;
    if (start1)
      return color((hue(minCircle.clr)+((hue(scnClosest.clr)-hue(minCircle.clr))*min_Scn_rel))%colorRange, strongColor, strongColor);
    else
      return color((hue(minCircle.clr)-((hue(scnClosest.clr)-hue(minCircle.clr))*min_Scn_rel)+colorRange)%colorRange, strongColor, strongColor);
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

  void getNeighbours(ArrayList<Boid> boids) {
    sumVel.mult(0);    
    sumLoc.mult(0);
    nbCount = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sumVel.add(other.velocity);
        sumLoc.add(other.location);
        nbCount++;
        if (other.groupID < groupID) 
          integrateGroupInto(groupID, other.groupID);
      }
    }
    //    print(sum + " "+nbCount);
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    PVector dir = new PVector(sumVel.x, sumVel.y);
    if (nbCount > 0) {
      dir.div((float)nbCount);
      dir.setMag(maxspeed);
      dir.sub(velocity);
      dir.limit(maxforce);
      return dir;
    } 
    else 
      return new PVector(0, 0);
  }

  PVector cohesion (ArrayList<Boid> boids) {
    PVector center = new PVector(sumLoc.x, sumLoc.y); // Start with empty vector to accumulate all locations
    if (nbCount > 0) {
      center.div((float) nbCount);
      cohesionPoint = center;
      return seek(center); // Steer towards the location
    }
    else {
      cohesionPoint = location;
      return new PVector(0, 0);
    }
  }

  void checkCloseToBorder() {
    java.util.Arrays.fill(closeToBorder, false);
    if (location.x <  neighbordist)
      closeToBorder[0] = true;
    else if (location.x > width-neighbordist)
      closeToBorder[2] = true;
    if (   location.y <  neighbordist)
      closeToBorder[1] = true;
    else if (location.y > height-neighbordist)
      closeToBorder[3] = true;
  }

  boolean borderMatch(Boid other) {
    for (int i=0; i < 4;i++)
      if (closeToBorder[i] & other.closeToBorder[(i+2)%4])
        return true;
    return false;
  }

  PVector shiftToMe(Boid other) {
    PVector loc = new PVector(other.location.x, other.location.y);
    if (closeToBorder[0])
      loc.sub(width, 0, 0);
    else if (closeToBorder[1])
      loc.sub(0, height, 0);
    if (closeToBorder[2])
      loc.add(width, 0, 0);
    else if (closeToBorder[3])
      loc.add(0, height, 0);
    return loc;
  }
}

void integrateGroupInto(int from, int into) {
  for (Boid b : groups.get(from))
    b.groupID= groups.get(into).get(0).groupID;
  groups.get(into).addAll(groups.remove(from));
}

