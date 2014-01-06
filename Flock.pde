// original from The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flock class
// Does very little, simply manages the ArrayList of all the boids

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  float maxspeed_Deriv = 0.2;
  int nextID =0;

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  void run() {
    groups.clear();
    for (Boid b : boids)
      b.initGroup();
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }

  
  void applyForce(PVector force) {
      for (Boid b : boids) 
       b.applyForce(force);
  }
  
  void edit(int num) {
    if (num<0) {
      if (n<=0)
        return;
      n+= num;
      for (int i=0; i < abs(num);i++) 
        boids.remove(boids.size()-1);
    }
    else {
      for (int i=0; i < num;i++) 
        boids.add(new Boid(width/2, height/2, flock.nextID++));
      n+= num;
    }
    println("flocksize: "+n);
  }
}



