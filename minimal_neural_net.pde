import java.util.ArrayList;

ArrayList<ParticleSystem> systems;

void setup() {
  size(800, 800);
  background(20, 20, 40);
  smooth();
  
  systems = new ArrayList<ParticleSystem>();
  systems.add(new ParticleSystem(color(0, 180, 255, 220)));
}

void draw() {
  background(20, 20, 40);
  
  translate(width/2, height/2);
  
  for (ParticleSystem sys : systems) {
    sys.update();
    sys.display();
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("minimal_neural_net-####.png");
    println("Bild gespeichert!");
  }
  if (key == 'o' || key == 'O') {
    float hue = random(360);
    colorMode(HSB, 360, 255, 255);
    color newCol = color(hue, random(160, 240), random(200, 255), 200);
    colorMode(RGB);
    systems.add(new ParticleSystem(newCol));
    println("Neues minimalistisches Netz hinzugefügt!");
  }
  if (key == 'n' || key == 'N') {
    systems.clear();
    systems.add(new ParticleSystem(color(0, 180, 255, 220)));
    println("Reset – frisches Netz");
  }
}

class ParticleSystem {
  ArrayList<PVector> particles;
  color col;
  int maxParticles = 30;  // Deine perfekte Wahl – extrem reduziert

  ParticleSystem(color c) {
    particles = new ArrayList<PVector>();
    col = c;
  }

  void update() {
    // Noch sparsamer: 1 Partikel alle 15–20 Frames für langsames, bewusstes Wachstum
    if (frameCount % 18 == 0 && particles.size() < maxParticles) {
      float offsetAngle = random(TWO_PI);
      float offsetDist = random(5, 40);  // Etwas weiter vom Kern für offeneren Start
      float sx = cos(offsetAngle) * offsetDist;
      float sy = sin(offsetAngle) * offsetDist;
      particles.add(new PVector(sx, sy));
    }

    for (int i = particles.size() - 1; i >= 0; i--) {
      PVector p = particles.get(i);
      
      float angle = random(TWO_PI);
      float speed = random(0.8, 2.2);  // Langsam und organisch
      p.x += cos(angle) * speed;
      p.y += sin(angle) * speed;

      // Deine dynamische Grenze: 90% des kleineren Fensterrands
      float maxRadius = min(width, height) * 0.9;
      if (dist(0, 0, p.x, p.y) > maxRadius) {
        particles.remove(i);
      }
    }
  }

  void display() {
    // Linien: dünn, elegant, mit sanfter Transparenz
    strokeCap(ROUND);
    for (int i = 0; i < particles.size(); i++) {
      PVector p1 = particles.get(i);
      
      for (int j = i + 1; j < particles.size(); j++) {
        PVector p2 = particles.get(j);
        float d = dist(p1.x, p1.y, p2.x, p2.y);
        
        if (d < 140) {  // Etwas größere Reichweite für Verbindung bei nur 30 Knoten
          float lineAlpha = map(d, 0, 140, 180, 20);
          float lineWeight = map(d, 0, 140, 1.8, 0.3);
          
          stroke(red(col), green(col), blue(col), lineAlpha);
          strokeWeight(lineWeight);
          line(p1.x, p1.y, p2.x, p2.y);
        }
      }
    }
    
    // Minimalistische Knoten mit leichtem Glow
    noStroke();
    for (PVector p : particles) {
      // Äußere Glow-Schicht
      fill(red(col), green(col), blue(col), 40);
      ellipse(p.x, p.y, 10, 10);
      // Innerer Kern
      fill(red(col), green(col), blue(col), 220);
      ellipse(p.x, p.y, 4, 4);
    }
  }
}
