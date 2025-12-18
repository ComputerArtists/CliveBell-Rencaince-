float angle = 0;

void setup() {
  size(800, 800);
  background(245, 230, 200);  // Pergament-Hintergrund für Renaissance-Feeling
  smooth();
}

void draw() {
  background(245, 230, 200);
  translate(width/2, height/2);
  rotate(angle);
  angle += 0.004;  // Langsame Rotation
  
  // Quadrat und Kreis
  noFill();
  stroke(100, 50, 0, 180);
  strokeWeight(3);
  rectMode(CENTER);
  rect(0, 0, 500, 500);
  ellipse(0, 0, 500, 500);
  
  // Proportionen-Linien
  stroke(200, 0, 0, 100);
  strokeWeight(1);
  line(-250, 0, 250, 0);
  line(0, -250, 0, 300);
  
  // Zentraler Kern
  fill(0, 100, 200, 80);
  stroke(0, 80, 150);
  strokeWeight(4);
  ellipse(0, 0, 80, 80);
  
  // 12 neuronale Ausstrahlungen
  for (int i = 0; i < 12; i++) {
    float a = map(i, 0, 12, 0, TWO_PI);
    line(0, 0, 60 * cos(a), 60 * sin(a));
  }
  
  // Animierte Spreizung (zwischen geschlossen und gespreizt)
  float spread = sin(angle * 3) * 0.5 + 0.5;  // 0 bis 1
  
  // Vier Hauptäste: links/rechts Arm, links/rechts Bein
  pushMatrix();
  rotate(-0.3 + spread * 0.8);  // Linker Arm
  drawBranch(0, 0, 180, 5, color(0, 120, 220));
  popMatrix();
  
  pushMatrix();
  rotate(0.3 - spread * 0.8);  // Rechter Arm
  drawBranch(0, 0, 180, 5, color(0, 120, 220));
  popMatrix();
  
  pushMatrix();
  rotate(PI + 0.4 - spread * 0.6);  // Linkes Bein
  drawBranch(0, 0, 200, 5, color(0, 120, 220));
  popMatrix();
  
  pushMatrix();
  rotate(PI - 0.4 + spread * 0.6);  // Rechtes Bein
  drawBranch(0, 0, 200, 5, color(0, 120, 220));
  popMatrix();
}

void drawBranch(float x, float y, float len, int depth, color col) {
  if (depth == 0) return;
  
  float x2 = x + len * cos(0);  // Gerade nach vorne
  float y2 = y + len * sin(0);
  
  // Linie zeichnen mit abnehmender Dicke
  strokeWeight(map(depth, 1, 5, 1, 6));
  stroke(col, map(depth, 1, 5, 100, 255));
  line(x, y, x2, y2);
  
  // Kleine Endkugel
  noStroke();
  fill(col, 180);
  ellipse(x2, y2, map(depth, 1, 5, 4, 10), map(depth, 1, 5, 4, 10));
  
  // Rekursive Verzweigungen
  pushMatrix();
  translate(x2, y2);
  
  // Zwei Seitenzweige
  rotate(-0.4 - random(0.2));
  drawBranch(0, 0, len * 0.7, depth - 1, col);
  
  rotate(0.8 + random(0.4));  // Zurück und auf die andere Seite
  drawBranch(0, 0, len * 0.7, depth - 1, col);
  
  // Optional: kleinerer Hauptzweig weiter
  if (random(1) > 0.3) {
    rotate(-0.4 + random(0.2));
    drawBranch(0, 0, len * 0.8, depth - 1, col);
  }
  
  popMatrix();
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("vitruvian_grok_fractal-####.png");
    println("Bild gespeichert!");
  }
}
