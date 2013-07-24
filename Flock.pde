
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
    for (Boid b : boids)
      b.initGroup();
    for (Boid b : boids) 
      b.run(boids);  // Passing the entire list of boids to each boid individually
    println("flock.run: #groups: " + groups.size());
  }

  void addBoid(Boid b) {
    boids.add(b);
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

