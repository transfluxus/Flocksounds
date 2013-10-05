// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flock class
// Does very little, simply manages the ArrayList of all the boids

void initFlock() {  
  for (int i = 0; i < n; i++) {
    Boid b = new Boid(width/2, height/2, i);
    flock.addBoid(b);
  }
}

class Flock {

  ArrayList<Boid> boids; // An ArrayList for all the boids


    Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  void run() {
    for (Boid b : boids) 
      b.run(boids);    
    for (Boid b : boids) 
      b.renderNbs();     
    for (Boid b : boids) 
      b.renderBoid();
  }



  void addBoid(Boid b) {
    boids.add(b);
  }

  Boid get(int i) {
    return boids.get(i);
  }
}

