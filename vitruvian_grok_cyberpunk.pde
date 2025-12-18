float angle = 0;
String[] binaryStrings;
ArrayList<NeonLayer> layers;  // Für multiple farbige Overlays

void setup() {
  size(800, 800);
  background(20, 20, 40);
  smooth();
  textAlign(CENTER);
  textSize(18);  // 50% größer als vorher (12 → 18)
  
  // Generiere längere Binärcode-Strings
  binaryStrings = new String[10];
  for (int i = 0; i < 10; i++) {
    StringBuilder sb = new StringBuilder();
    for (int j = 0; j < 25; j++) {  // Etwas länger für bessere Lesbarkeit
      sb.append(random(1) > 0.5 ? "1" : "0");
    }
    binaryStrings[i] = sb.toString();
  }
  
  layers = new ArrayList<NeonLayer>();
  // Start mit einer intensiven Neon-Farbe (Cyan-Blau)
  layers.add(new NeonLayer(color(0, 220, 255)));
}

void draw() {
  background(20, 20, 40);
  translate(width/2, height/2);
  rotate(angle);
  angle += 0.002;
  
  // Alle Schichten zeichnen
  for (NeonLayer layer : layers) {
    layer.display();
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("vitruvian_grok_cyberpunk-####.png");
    println("Bild gespeichert!");
  }
  if (key == 'o' || key == 'O') {
    // Neue zufällige Neon-Farbe: Hohe Sättigung und Helligkeit
    colorMode(HSB, 360, 255, 255);
    float hue = random(360);
    color newCol = color(hue, random(200, 255), random(220, 255));
    colorMode(RGB);
    layers.add(new NeonLayer(newCol));
    println("Neue Neon-Schicht hinzugefügt!");
  }
  if (key == 'n' || key == 'N') {
    layers.clear();
    layers.add(new NeonLayer(color(0, 220, 255)));
    println("Reset – zurück zur Basis-Neon-Schicht");
  }
}

// Klasse für eine einzelne farbige Schicht
class NeonLayer {
  color col;
  
  NeonLayer(color c) {
    col = c;
  }
  
  void display() {
    // Quadrat und Kreis
    drawNeonRect(0, 0, 500, 500, color(255, 100, 0, 180));
    drawNeonEllipse(0, 0, 500, 500, color(0, 255, 255, 180));
    
    // Kern
    drawNeonEllipse(0, 0, 80, 80, col);
    
    // Neuronale Verbindungen
    for (int i = 0; i < 12; i++) {
      float a = map(i, 0, 12, 0, TWO_PI);
      float x2 = 60 * cos(a);
      float y2 = 60 * sin(a);
      drawNeonLine(0, 0, x2, y2, col);
      drawBinaryAlongLine(0, 0, x2, y2, i % binaryStrings.length);
    }
    
    // Arme
    float armSpread = sin(angle * 4) * 0.5 + 0.5;
    float armY = lerp(0, 150, armSpread);
    
    drawNeonLine(0, 0, -200, armY, col);
    drawBinaryAlongLine(0, 0, -200, armY, 0);
    drawNeonLine(-200, armY, -250, armY + 100, col);
    drawBinaryAlongLine(-200, armY, -250, armY + 100, 1);
    drawNeonLine(-200, armY, -250, armY - 100, col);
    drawBinaryAlongLine(-200, armY, -250, armY - 100, 2);
    
    drawNeonLine(0, 0, 200, armY, col);
    drawBinaryAlongLine(0, 0, 200, armY, 3);
    drawNeonLine(200, armY, 250, armY + 100, col);
    drawBinaryAlongLine(200, armY, 250, armY + 100, 4);
    drawNeonLine(200, armY, 250, armY - 100, col);
    drawBinaryAlongLine(200, armY, 250, armY - 100, 5);
    
    // Beine
    drawNeonLine(0, 0, -100, 200, col);
    drawBinaryAlongLine(0, 0, -100, 200, 6);
    drawNeonLine(-100, 200, -150, 300 + armSpread * 50, col);
    drawBinaryAlongLine(-100, 200, -150, 300 + armSpread * 50, 7);
    
    drawNeonLine(0, 0, 100, 200, col);
    drawBinaryAlongLine(0, 0, 100, 200, 8);
    drawNeonLine(100, 200, 150, 300 + armSpread * 50, col);
    drawBinaryAlongLine(100, 200, 150, 300 + armSpread * 50, 9);
    
    // Proportionen-Linien
    drawNeonLine(-250, 0, 250, 0, color(255, 0, 100, 200));
    drawNeonLine(0, -250, 0, 300, color(255, 0, 100, 200));
  }
  
  // Neon-Line mit Glow
  void drawNeonLine(float x1, float y1, float x2, float y2, color c) {
    for (int i = 6; i > 0; i--) {
      strokeWeight(i * 2);
      stroke(red(c), green(c), blue(c), 255 / i);
      line(x1, y1, x2, y2);
    }
    strokeWeight(2);
    stroke(c);
    line(x1, y1, x2, y2);
  }
  
  // Neon-Ellipse
  void drawNeonEllipse(float x, float y, float w, float h, color c) {
    noFill();
    for (int i = 6; i > 0; i--) {
      strokeWeight(i * 2);
      stroke(red(c), green(c), blue(c), 255 / i);
      ellipse(x, y, w, h);
    }
  }
  
  // Neon-Rect
  void drawNeonRect(float x, float y, float w, float h, color c) {
    rectMode(CENTER);
    noFill();
    for (int i = 5; i > 0; i--) {
      strokeWeight(i * 2);
      stroke(red(c), green(c), blue(c), 255 / i);
      rect(x, y, w, h);
    }
  }
  
  // Binärcode mit Pulsation
  void drawBinaryAlongLine(float x1, float y1, float x2, float y2, int strIndex) {
    String bin = binaryStrings[strIndex];
    float dist = dist(x1, y1, x2, y2);
    float step = dist / (bin.length() + 2);
    float ang = atan2(y2 - y1, x2 - x1);
    
    pushMatrix();
    translate(x1, y1);
    rotate(ang);
    
    // Pulsierender grüner Matrix-Glow
    fill(0, 255, 100, 180 + sin(frameCount * 0.1 + strIndex) * 75);
    float offset = (frameCount * 1.2) % step;
    for (int i = 0; i < bin.length(); i++) {
      text(bin.charAt(i), i * step + offset, -8);  // Leicht versetzt für bessere Lesbarkeit
    }
    popMatrix();
  }
}
