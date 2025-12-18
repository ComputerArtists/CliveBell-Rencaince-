float phi = (1 + sqrt(5)) / 2;  // Goldener Schnitt ≈ 1.618
float angle = 0;
int depth = 8;
boolean showSpiral = true;
float spiralSpeed = 0.02;
int colorMode = 0;

void setup() {
  size(800, 800);
  smooth();
  rectMode(CORNERS);
}

void draw() {
  background(245, 235, 210);  // Pergament
  translate(width/2, height/2);
  rotate(map(mouseX, 0, width, -PI/4, PI/4));  // Maus-Rotation
  
  depth = int(map(mouseY, 0, height, 4, 12));  // Maus-Tiefe
  
  float w = 400;
  float h = w / phi;
  
  drawGoldenRect(-w/2, -h/2, w/2, h/2, depth);
  
  if (showSpiral) {
    drawGoldenSpiral(-w/2, -h/2, w/2, h/2, angle);
    angle += spiralSpeed;
  }
  
  fill(0);
  textSize(14);
  text("Tiefe: " + depth + " | Spirale: " + (showSpiral ? "an" : "aus"), -width/2 + 10, -height/2 + 20);
}

void drawGoldenRect(float x1, float y1, float x2, float y2, int level) {
  if (level == 0) return;
  
  // Farbe je nach Tiefe und Modus
  colorMode(RGB);
  float alpha = map(level, 1, depth, 100, 255);
  if (colorMode == 0) { // Renaissance-Gold
    fill(200, 160, 80, alpha);
    stroke(150, 100, 30, alpha);
  } else if (colorMode == 1) { // Modern
    fill(map(level, 1, depth, 100, 255), 100, map(level, 1, depth, 255, 50), alpha);
    stroke(0, alpha);
  } else { // Monochrom
    fill(240, alpha);
    stroke(50, alpha);
  }
  strokeWeight(map(level, 1, depth, 1, 4));
  
  rect(x1, y1, x2, y2);
  
  float w = x2 - x1;
  float h = y2 - y1;
  
  if (w > h) { // Horizontal teilen
    float newW = w / phi;
    drawGoldenRect(x1, y1, x1 + newW, y2, level - 1);
    drawGoldenRect(x1 + newW, y1, x2, y2, level - 1);
  } else { // Vertikal teilen
    float newH = h / phi;
    drawGoldenRect(x1, y1, x2, y1 + newH, level - 1);
    drawGoldenRect(x1, y1 + newH, x2, y2, level - 1);
  }
}

void drawGoldenSpiral(float x1, float y1, float x2, float y2, float startAngle) {
  noFill();
  stroke(200, 50, 50, 180);
  strokeWeight(3);
  
  beginShape();
  float a = 0.1;
  float b = 0.15;
  for (float t = 0; t < TWO_PI * depth; t += 0.1) {
    float r = a * exp(b * t);
    float cx = (x1 + x2) / 2;
    float cy = (y1 + y2) / 2;
    float px = cx + r * cos(t + startAngle);
    float py = cy + r * sin(t + startAngle);
    vertex(px, py);
  }
  endShape();
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  showSpiral = !showSpiral;  // Klick für Toggle
  spiralSpeed += e * 0.005;
  spiralSpeed = constrain(spiralSpeed, 0.005, 0.1);
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("golden_ratio-####.png");
    println("Bild gespeichert!");
  }
  if (key == 'r' || key == 'R') {
    angle = 0;
    println("Reset");
  }
  if (key == 'c' || key == 'C') {
    colorMode = (colorMode + 1) % 3;
    println("Farbschema gewechselt");
  }
}
