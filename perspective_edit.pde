float vpX, vpY;            
float horizonY;            
float angle = 0;           
int depthSteps = 40;       
int widthSteps = 20;       
float tileStep = 30;       
int columnCount = 10;      
float columnHeight = 300;  
float columnBaseX = 200;   
boolean showColumns = true;
boolean showCapitals = true; 
int columnRows = 1;        
float buildingWidth = 300; 
float buildingHeight = 400;
float buildingZ = 600;     
boolean showRoof = true;   
boolean showWindows = true;
color gridColor = color(100, 60, 20, 120);
color columnColor = color(80, 40, 20, 180);
color bgColor = color(245, 235, 210);
boolean showShadows = true;
float animSpeed = 0.008;   
boolean animPaused = false;
boolean nightMode = false; 
int currentMode = 0;       
boolean showHelp = false;  
// float globalZoom = 1.0;

String[] modes = {
  "Kein Modus",
  "Fluchtpunkt X/Y (Maus drag)",
  "Horizont Y (Maus vertikal)",
  "Tiefenstufen (Maus horizontal)",
  "Breitenstufen (Maus horizontal)",
  "Fliesenschritt (Maus horizontal)",
  "Säulenanzahl (Maus horizontal)",
  "Säulenhöhe (Maus vertikal)",
  "Säulenbasis (Maus horizontal)",
  "Gebäudebreite (Maus horizontal)",
  "Gebäudehöhe (Maus vertikal)",
  "Gebäudetiefe (Maus horizontal)",
  "Farben (Maus pos: X=Hue, Y=Brightness)",
  "Animationsgeschwindigkeit (Maus horizontal)"
};

void setup() {
  size(800, 800);  // <--- Hier: Standard-2D-Renderer statt P3D
  resetAll();
  smooth();
}

void draw() {
  background(bgColor);
  
  if (!animPaused) {
    float pulseX = sin(angle) * 30;
    float pulseY = cos(angle * 1.3) * 20;
    vpX = vpX + pulseX - sin(angle - animSpeed) * 30;  // Korrigiert den vorherigen Puls
    vpY = vpY + pulseY - cos((angle - animSpeed) * 1.3) * 20;
    angle += animSpeed;
  }
  
  // horizonY = vpY;
  
  drawPerspectiveFloor(depthSteps, widthSteps);
 if (showColumns) {
  for (int row = 0; row < columnRows; row++) {
    // Kein Y-offset – alle Reihen auf gleicher Höhe
    drawColumnRow(-columnBaseX, columnCount, columnHeight);
    drawColumnRow(columnBaseX, columnCount, columnHeight);
  }
}
  drawPerspectiveBuilding();
  
  stroke(200, 0, 0, 150);
  strokeWeight(1);
  line(0, horizonY, width, horizonY);
  
  noStroke();
  fill(255, 0, 0, 200);
  ellipse(vpX, vpY, 12, 12);
  fill(255);
  ellipse(vpX, vpY, 6, 6);
  
  if (showHelp) {
    drawHelpOverlay();
  }
  
  fill(0);
  textSize(14);
  text("Modus: " + modes[currentMode], 10, height - 10);
  
}

// Der Rest des Codes bleibt EXAKT gleich wie in meiner vorherigen Version
// (keyPressed, mouseDragged, mouseWheel, resetAll, drawPerspectiveFloor, 
// drawColumnRow, drawPerspectiveBuilding, projectX/projectY, etc.)

// ... [hier den gesamten restlichen Code aus der vorherigen Nachricht einfügen] ...

void keyPressed() {
  // Modus-Auswahl per Taste
  switch(key) {
    case 'v': 
  currentMode = 1;
  animPaused = true;  // Automatisch pausieren für Edit
  println("Fluchtpunkt-Modus aktiv – Animation pausiert!");
  break;
    case 'h': animPaused = true; currentMode = 2; break; // Horizont
    case 'f': animPaused = true; currentMode = 3; break; // Tiefenstufen
    case 'g': animPaused = true; currentMode = 4; break; // Breitenstufen
    case 'd': animPaused = true; currentMode = 5; break; // Fliesenschritt
    case 's': animPaused = true; currentMode = 6; break; // Säulenanzahl
    case 'a': animPaused = true; currentMode = 7; break; // Säulenhöhe
    case 'p': animPaused = true; currentMode = 8; break; // Säulenbasis
    case 'u': animPaused = true; currentMode = 9; break; // Gebäudebreite
    case 'i': animPaused = true; currentMode = 10; break; // Gebäudehöhe
    case 'o': animPaused = true; currentMode = 11; break; // Gebäudetiefe
    case 'z': animPaused = true; currentMode = 12; break; // Farben
    case 'w': animPaused = true; currentMode = 13; break; // Anim-Speed
    case 't': animPaused = true; showColumns = !showColumns; break; // Toggle Raster? (Aber Raster ist Boden, korrigiert zu Säulen)
    case 'k': animPaused = true; showCapitals = !showCapitals; break;
    case 'j': animPaused = true; showRoof = !showRoof; break;
    case 'l': animPaused = true; showWindows = !showWindows; break;
    case 'e': animPaused = true; showShadows = !showShadows; break;
    case 'y':
  animPaused = !animPaused;
  if (!animPaused) {
    // Starte Animation neu, ohne Werte zu überschreiben
    angle = 0;  // Nur Reset der Phase, nicht der Parameter
    println("Animation wieder gestartet!");
  } else {
    println("Animation pausiert!");
  }
  break;
    case 'n': case 'N':
  nightMode = !nightMode;
  if (nightMode) {
    bgColor = color(10, 10, 30);
    gridColor = color(50, 100, 150, 120);
    columnColor = color(100, 150, 200, 180);
    println("Nachtmodus aktiviert – dunkler Hintergrund, blaue Töne");
  } else {
    bgColor = color(245, 235, 210);
    gridColor = color(100, 60, 20, 120);
    columnColor = color(80, 40, 20, 180);
    println("Nachtmodus deaktiviert – Renaissance-Pergament");
  }
  break;
  case 'm':
  showColumns = !showColumns;
  columnRows = max(1, columnRows - 1);
  println("Säulenreihen: " + columnRows);
  break;
case 'M':
showColumns = !showColumns;
  columnRows = min(5, columnRows + 1);
  println("Säulenreihen: " + columnRows);
  break;
    case 'q': animPaused = true; cycleBgColor(); break; // Zyklus BG-Farben
    case '1': animPaused = true; loadPreset(1); break; // Presets
    case '2': animPaused = true; loadPreset(2); break;
    case '3': animPaused = true; loadPreset(3); break;
    case '+': animPaused = true; globalZoom += 0.1; break;
    case '-': animPaused = true; globalZoom -= 0.1; break;
    case '?': animPaused = true; showHelp = !showHelp; break;
    case 'S': animPaused = true; saveFrame("perspective_edit-####.png"); println("Gespeichert!"); break;
    case ' ':
  currentMode = 0;
  animPaused = false;
  println("Modus verlassen – Animation startet wieder um deinen aktuellen Fluchtpunkt!");
  break;

case 'r': case 'R':
  vpX = width/2;
  vpY = height/2;
  horizonY = vpY;
  currentMode = 0;
  animPaused = false;
  angle = 0;
  println("Fluchtpunkt zentriert – Animation startet wieder!");
  break;
    
  }
}

void mouseDragged() {
  if (mouseButton == LEFT) {
    
    switch(currentMode) {
      case 1:  // Fluchtpunkt X/Y
        println("Her"+mouseX);
        vpX = mouseX;
        vpY = mouseY;
        break;
        
      case 2:  // Horizont Y
        horizonY = mouseY;
        break;
        
     case 3:
  depthSteps = int(map(mouseX, 0, width, 10, 100));
  println("Tiefenstufen geändert zu: " + depthSteps); // Debug
  break;
        
      case 4:  // Breitenstufen
        widthSteps = int(map(mouseX, 0, width, 5, 50));
        break;
        
      case 5:  // Fliesenschritt
        tileStep = map(mouseX, 0, width, 10, 100);
        break;
        
      case 6:  // Säulenanzahl
        columnCount = int(map(mouseX, 0, width, 0, 12));
        break;
        
      case 7:  // Säulenhöhe
        columnHeight = map(mouseY, height, 0, 100, 800);  // Umgedreht: oben = klein, unten = groß
        break;
        
      case 8:  // Säulenbasis (Abstand)
        columnBaseX = map(mouseX, 0, width, 50, 400);
        break;
        
      case 9:  // Gebäudebreite
        buildingWidth = map(mouseX, 0, width, 100, 800);
        break;
        
      case 10: // Gebäudehöhe
        buildingHeight = map(mouseY, height, 0, 200, 1000);
        break;
        
      case 11: // Gebäudetiefe
        buildingZ = map(mouseX, 0, width, 300, 1500);
        break;
        
      case 12: // Farben (Hue mit X, Brightness mit Y)
        float hue = map(mouseX, 0, width, 0, 360);
        float bri = map(mouseY, height, 0, 100, 255);  // Oben dunkel, unten hell
        gridColor = color(hue, 200, bri, 150);
        columnColor = color((hue + 180) % 360, 180, bri - 30, 200);
        break;
        
      case 13: // Animationsgeschwindigkeit
        animSpeed = map(mouseX, 0, width, 0.001, 0.05);
        break;
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  // Feinjustierung für aktiven Modus (z. B. +1/-1 Schritte)
  switch(currentMode) {
    case 3: depthSteps -= int(e); depthSteps = constrain(depthSteps, 10, 100); break;
    case 4: widthSteps -= int(e); widthSteps = constrain(widthSteps, 5, 50); break;
    case 6: columnCount -= int(e); columnCount = constrain(columnCount, 5, 20); break;
    // ... erweiterbar für andere
  }
}

void resetAll() {
  vpX = width/2;
  vpY = height/2;
  horizonY = vpY;
  // ... restliche Resets ...
  angle = 0;  // Startet den Puls sauber
  horizonY = vpY;
  depthSteps = 40;
  widthSteps = 20;
  tileStep = 30;
  columnCount = 10;
  columnHeight = 300;
  columnBaseX = 200;
  showColumns = true;
  showCapitals = true;
  columnRows = 1;
  buildingWidth = 300;
  buildingHeight = 400;
  buildingZ = 600;
  showRoof = true;
  showWindows = true;
  gridColor = color(100, 60, 20, 120);
  columnColor = color(80, 40, 20, 180);
  bgColor = color(245, 235, 210);
  showShadows = true;
  animSpeed = 0.008;
  animPaused = false;
  nightMode = false;
  currentMode = 0;
  globalZoom = 1.0;
  println("Alles zurückgesetzt!");
}

float globalZoom = 1.0;  // Globaler Zoom

void drawPerspectiveFloor(int depthSteps, int widthSteps) {
  stroke(gridColor);
  strokeWeight(1);
  
  float groundY = height - 100 * globalZoom;
  float maxDepth = 2000 * globalZoom;
  
  // Array mit den X-Positionen der Längslinien (links bis rechts)
  float[] xPositions = new float[widthSteps * 2 + 1];
  for (int i = -widthSteps; i <= widthSteps; i++) {
    xPositions[i + widthSteps] = i * tileStep * globalZoom;
  }
  
  // 1. Längslinien zeichnen (volle Tiefe)
  for (float x : xPositions) {
    perspectiveLine(x, groundY, 0, x, groundY, maxDepth);
  }
  
  // 2. Querverbindungen – einfach zwischen den äußeren Längslinien bei jeder Tiefenstufe
  float stepZ = maxDepth / depthSteps;
  for (int i = 0; i <= depthSteps; i++) {
    float z = i * stepZ;
    
    // Linke äußere Linie
    float leftX = projectX(xPositions[0], z);
    // Rechte äußere Linie
    float rightX = projectX(xPositions[xPositions.length - 1], z);
    
    // Durchgezogene Querverbindung von links außen bis rechts außen
    line(leftX, projectY(groundY, z), rightX, projectY(groundY, z));
  }
}

void drawColumnRow(float baseX, int count, float height) {
  float maxDepth = 2000 * globalZoom;
  float stepZ = maxDepth / count;

  for (int i = 1; i <= count; i++) {
    float z = i * stepZ;
    float scale = map(z, 0, maxDepth, 1, 0.2);
    scale = pow(scale, 0.8);
    float colHeight = height * scale * globalZoom;
    float colWidth = 30 * scale * globalZoom;

    float groundY = height - 100 * globalZoom;  // Boden (unten im Bild)

    stroke(columnColor);
    strokeWeight(4 * scale);

    // Vertikale Linien – immer Boden unten, Kapitell oben
perspectiveLine(baseX - colWidth, groundY, z, baseX - colWidth, groundY - colHeight, z);
perspectiveLine(baseX + colWidth, groundY, z, baseX + colWidth, groundY - colHeight, z);

// Obere Querverbindung (Kapitell – immer oben)
perspectiveLine(baseX - colWidth, groundY - colHeight, z, baseX + colWidth, groundY - colHeight, z);

// Untere Querverbindung (Boden – immer unten)
perspectiveLine(baseX - colWidth, groundY, z, baseX + colWidth, groundY, z);

// Kapitell – immer oben (groundY - colHeight)
if (showCapitals) {
  float capY = groundY - colHeight;  // Kapitell oben
      fill(120, 80, 40, 150);
      noStroke();
      // float capY = groundY - colHeight;  // Kapitell oben
      beginShape();
      vertex(projectX(baseX - colWidth*1.5, z), projectY(capY, z));
      vertex(projectX(baseX + colWidth*1.5, z), projectY(capY, z));
      vertex(projectX(baseX + colWidth, z), projectY(capY - 20*scale, z));
      vertex(projectX(baseX - colWidth, z), projectY(capY - 20*scale, z));
      endShape(CLOSE);
    }
  }
}

void drawPerspectiveBuilding() {
  float z = buildingZ * globalZoom;
  float w = buildingWidth * globalZoom;
  float h = buildingHeight * globalZoom;
  
  stroke(150, 100, 50, 180);
  strokeWeight(3);
  
  perspectiveLine(-w, height - h, z, -w, height, z);
  perspectiveLine(w, height - h, z, w, height, z);
  perspectiveLine(-w, height - h, z, w, height - h, z);
  
  if (showRoof) {
    fill(180, 120, 60, 100);
    beginShape();
    vertex(projectX(-w, z), projectY(height - h, z));
    vertex(projectX(0, z), projectY(height - h - 150 * globalZoom, z));
    vertex(projectX(w, z), projectY(height - h, z));
    endShape(CLOSE);
  }
  
  if (showWindows) {
    // Einfache Fenster als Rechtecke
    for (int win = 0; win < 3; win++) {
      float winX = -w + (win + 1) * (2*w / 4);
      float winY = height - h + h/2;
      float winW = 50 * globalZoom;
      float winH = 80 * globalZoom;
      fill(200, 200, 255, 100);
      beginShape();
      vertex(projectX(winX - winW/2, z), projectY(winY - winH/2, z));
      vertex(projectX(winX + winW/2, z), projectY(winY - winH/2, z));
      vertex(projectX(winX + winW/2, z), projectY(winY + winH/2, z));
      vertex(projectX(winX - winW/2, z), projectY(winY + winH/2, z));
      endShape(CLOSE);
    }
  }
}

float projectX(float x, float z) {
  return map(z, 0, 1000 * globalZoom, x, vpX);
}

float projectY(float y, float z) {
  return map(z, 0, 1000 * globalZoom, y, horizonY);  // Hier muss horizonY sein!
}

void perspectiveLine(float x1, float y1, float z1, float x2, float y2, float z2) {
  float px1 = projectX(x1, z1);
  float py1 = projectY(y1, z1);
  float px2 = projectX(x2, z2);
  float py2 = projectY(y2, z2);
  line(px1, py1, px2, py2);
}

void cycleBgColor() {
  // Zyklus: Pergament -> Blau -> Dämmerung
  if (bgColor == color(245, 235, 210)) bgColor = color(200, 220, 255);
  else if (bgColor == color(200, 220, 255)) bgColor = color(100, 80, 120);
  else bgColor = color(245, 235, 210);
}

void loadPreset(int num) {
  // Beispiel-Presets
  if (num == 1) { vpY = height/2; horizonY = vpY; } // Zentral
  if (num == 2) { vpY = height/4; horizonY = vpY; } // Hoher Horizont
  if (num == 3) { vpX = width/4; vpY = height/3; } // Verzerrt
}

void drawHelpOverlay() {
  fill(0, 200);
  rect(10, 10, width-20, height-20);
  fill(255);
  textSize(12);
  text("Hilfe: Modi aktivieren mit Tasten, dann Maus drag/wheel:\n" +
       "v: Fluchtpunkt\nh: Horizont\nf: Tiefenstufen\ng: Breitenstufen\nd: Fliesenschritt\n" +
       "s: Säulenanzahl\na: Säulenhöhe\np: Säulenbasis\nu: Gebäudebreite\ni: Gebäudehöhe\n" +
       "o: Gebäudetiefe\nz: Farben\nw: Anim-Speed\nt: Toggle Raster (Säulen)\n" +
       "k: Toggle Kapitelle\nj: Toggle Dach\nl: Toggle Fenster\ne: Toggle Schatten\n" +
       "y: Pause Anim\nn: Nachtmodus\nm/M: Säulenreihen\nq: BG-Farben\n1-3: Presets\n" +
       "+/-: Zoom\nr: Reset\nS: Speichern\n?: Hilfe", 20, 30);
}
