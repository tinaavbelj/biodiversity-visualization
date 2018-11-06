import java.util.*;

PImage mapImage;
Table parksTable;
Table speciesTable;
Park[] parks;
Species[] species;
String[] speciesColumnNames;
String[] parksColumnNames;
int parksRowCount;
int parksColumnCount;
int speciesRowCount;
int speciesColumnCount;
Point[] points;
float maxPointSize = 350;
float minPointSize = 15;
float maxAcres = 0;
float usaXstart = 70;
float usaXend = 120;
float usaYstart = 20;
float usaYend = 50;
float usaXdistance = usaXend - usaXstart;
float usaYdistance = usaYend - usaYstart;
float usaDistanceRatio = usaYdistance / usaXdistance;
int screenX = 1000;
int screenY = int(usaDistanceRatio * screenX);
float e2 = screenX / usaXdistance;

//10 selected parks and their positions
String[] selectedParksCodes = new String[]{"GUMO", "YOSE", "YELL", "BADL", "EVER", "PEFO", "VOYA", "ZION", "CRLA", "MACA", "SHEN"};
int[] selectedParksX = new int[]{391, 230, 337, 441, 761, 248, 541, 291, 199, 622, 752};
int[] selectedParksY = new int[]{407, 330, 191, 196, 495, 362, 132, 341, 202, 308, 245};
int selectedParksRowCount = selectedParksCodes.length;

//category groups and images
String[] animalsGroup = {"Mammal", "Bird", "Reptile", "Amphibian", "Fish", "Invertebrate", "Crab/Lobster/Shrimp", "Slug/Snail", "Spider/Scorpion", "Insect"};
Map<String, String> animalsGroupDictionary = new HashMap<String, String>() 
{{ 
  put("Mammal", "Mammals");
  put("Bird", "Birds");
  put("Reptile", "Reptiles");
  put("Amphibian", "Amphibians");
  put("Fish", "Fish");
  put("Invertebrate", "Invertebrates");
  put("Crab/Lobster/Shrimp", "Crabs\nShrimps");
  put("Slug/Snail", "Snails\nSlugs");
  put("Spider/Scorpion", "Spiders\nScorpions");
  put("Insect", "Insects");
}};
String[] animalsGroupImagesPath = {"data/images/mammals.svg", "data/images/birds.svg", "data/images/reptiles.svg", "data/images/amphibians.svg",
  "data/images/fish.svg", "data/images/invertebrates.svg", "data/images/crab.svg", "data/images/snails.svg", "data/images/spiders.svg", "data/images/insects.svg"};
PShape[] animalsGroupImages = new PShape[animalsGroupImagesPath.length];
String[] plantsGroup = {"Vascular Plant", "Nonvascular Plant"};
Map<String, String> plantsGroupDictionary = new HashMap<String, String>() 
{{ 
  put("Vascular Plant", "Vascular\nPlants");
  put("Nonvascular Plant", "Nonvascular\nPlants");
}};
String[] plantsGroupImagesPath = {"data/images/vascular-plants.svg", "data/images/nonvascular-plants.svg"};
PShape[] plantsGroupImages = new PShape[plantsGroupImagesPath.length];
String[] fungiGroup = {"Fungi"};

//colors
color darkGray = color(48, 48, 48);
color lightGray = color(170, 170, 170);
color mediumGray = color(66, 66, 66);
color mediumGrayMap = color(91, 91, 91);
color red0 = color(238, 57, 55);
color darkRed = color(120, 48, 48);
color red1 = color(240, 90, 89);
color red2 = color(240, 134, 134);
color red3 = color(239, 184, 184);
color orange0 = color(240, 90, 34);
color orange1 = color(244, 125, 42);
color orange2 = color(247, 155, 91);
color orange3 = color(248, 196, 166);

//number of species legend
color[] parksNumberOfSpeciesColors = new color[] {
  red3,
  red2,
  red1,
  red0
};
String[] numberOfSpeciesText = new String[] {"<1000", "1001-2000", "2001-3000", ">3001"};
int[] numberOfSpeciesBreakPoints = new int[] {1000, 2000, 3000};

//number of species subcategory level
color[] numberOfSpeciesSubcategoriesColors = new color[] {
  orange3,
  orange2,
  orange1,
  orange0
};

String[] numberOfSpeciesSubcategoryText = new String[] {"<50", "51-100", "100-150", ">151"};
int[] numberOfSpeciesSubcategoriesBreakPoints = new int[] {50, 100, 150};

int clickedParkIndex;
boolean parkSelected;
int closeButtonSize = 25;
int closeButtonY = 50;
int closeButtonX = screenX - closeButtonY - closeButtonSize;
PShape closeButton;
String closeButtonPath = "data/images/close.svg";
int maxCategoryCircleSize = 200;
int categoryDistanceRadius = 150;
int maxSubcategoryCircleSize = 150;
int minSubcategoryCircleSize = 100;
int subcategoryCircleSize = 70;
boolean subcategoryHover = false;
SubcategoryPoint subcategoryHoverPoint;
SubcategoryPoint[] currentSubcategoriesAnimals;
SubcategoryPoint[] currentSubcategoriesPlants;

PGraphics pointsPanel;
PGraphics backgroundPanel;
PGraphics legendPanel;
PShape bg;
PShape bgGray;
String bgPath = "data/images/map.svg";
String bgGrayPath = "data/images/mapGray.svg";
PFont fontBold;
PFont fontBoldSmall;
PFont fontBoldExtraSmall;
PFont fontBoldExtraExtraSmall;
String fontPathBold = "data/fonts/Montserrat-SemiBold.otf";

void setup() {
  //load fonts
  fontBold = createFont(fontPathBold, 26);
  fontBoldSmall = createFont(fontPathBold, 20);
  fontBoldExtraSmall = createFont(fontPathBold, 13);
  fontBoldExtraExtraSmall = createFont(fontPathBold, 10);
  
  //create PGraphics panels
  legendPanel = createGraphics(300, 100);
  
  //load close button
  closeButton = loadShape(closeButtonPath);
  
  //load background
  bg = loadShape(bgPath);
  bgGray = loadShape(bgGrayPath);  
  
  //load subgroup images
  for (int i=0; i<animalsGroupImagesPath.length; i++) {
    animalsGroupImages[i] = loadShape(animalsGroupImagesPath[i]);
  }
  for (int i=0; i<plantsGroupImagesPath.length; i++) {
    plantsGroupImages[i] = loadShape(plantsGroupImagesPath[i]);
  }
  
  //read data
  parksTable = new Table("data/parks.csv");
  speciesTable = new Table("data/species.csv");
  parksRowCount = parksTable.getRowCount();
  speciesRowCount = speciesTable.getRowCount();
  parksColumnCount = parksTable.data[0].length;
  speciesColumnCount = speciesTable.data[0].length;
  
  //Convert parks Table to Parks array
  //Parks column names
  parksColumnNames = new String[parksColumnCount];
  for (int i=0; i<parksColumnCount; i++) {
    parksColumnNames[i] = parksTable.data[0][i];
  }
  //fill parks array & find max park acres
  parks = new Park[parksRowCount-1];
  for (int i=1; i<parksRowCount; i++) {
    //divide states string to array
    String[] states = split(parksTable.data[i][2], ';');
    parks[i-1] = new Park(parksTable.data[i][0], parksTable.data[i][1], states, join(states, ", "), float(parksTable.data[i][3]), float(parksTable.data[i][4]), float(parksTable.data[i][5]));
    
    if (parks[i-1].acres >= maxAcres) {
      maxAcres = parks[i-1].acres;
    }
  }
  
  //subtract 1 because of header row
  parksRowCount = parksRowCount-1;
  
  //keep only 10 parks for demo and find park with the biggest area
  Park[] selectedParks = new Park[selectedParksRowCount];
  for (int i=0; i<parksRowCount; i++) {
    for (int j=0; j<selectedParksRowCount; j++) {
      if (parks[i].parkCode.equals(selectedParksCodes[j])) {
        selectedParks[j] = parks[i];
        if (selectedParks[j].acres >= maxAcres) {
          maxAcres = selectedParks[j].acres;
        }
      }
    }
  }
  
  parks = selectedParks;
  parksRowCount = selectedParksRowCount;
  
  //Convert species Table to Species array
  //Species column names
  speciesColumnNames = new String[speciesColumnCount];
  for (int i=0; i<speciesColumnCount; i++) {
    speciesColumnNames[i] = speciesTable.data[0][i];
  }
  
  species = new Species[speciesRowCount-1];
  for (int i=1; i<speciesRowCount; i++) {
    //divide common names string to array
    String[] commonNames = split(speciesTable.data[i][6], ';');    
    species[i-1] = new Species(speciesTable.data[i][0], speciesTable.data[i][1], speciesTable.data[i][2], speciesTable.data[i][3], speciesTable.data[i][4], 
    speciesTable.data[i][5], commonNames, speciesTable.data[i][7], speciesTable.data[i][8], speciesTable.data[i][9], speciesTable.data[i][10], 
    speciesTable.data[i][11], speciesTable.data[i][12]);
  }
   
  speciesRowCount = speciesRowCount-1;
  
  //add species and category details to parks array
  for (int p=0; p<parksRowCount; p++) {
    List<Category> categories = new ArrayList<Category>();
    List<Species> speciesInPark = getSpeciesInPark(parks[p].parkName);
    boolean animalsGroupBool = false;
    boolean plantsGroupBool = false;
    boolean fungiGroupBool = false;
    
    for (int i=0; i<speciesInPark.size(); i++) {
      boolean addNewCategory = true;
      
      //check if the category already exists in the list
      for (int j=0; j<categories.size(); j++) {
        if (speciesInPark.get(i).category.equals(categories.get(j).categoryName)) {
          addNewCategory = false;
          Category c = categories.get(j);
          c.speciesNumber ++;
          if (speciesInPark.get(i).conservationStatus.equals("Endangered")) {
            c.endangered ++;
          }
          else if (speciesInPark.get(i).conservationStatus.equals("Species Of Concern")) {
            c.speciesOfConcern ++;
          }
          else if (speciesInPark.get(i).conservationStatus.equals("Threatened")) {
            c.threatened ++;
          }
          continue;
        }
      }
      if (addNewCategory) {
        int pictureIndex = 0;
        int e = 0;
        int t = 0;
        int s = 0;
        if (speciesInPark.get(i).conservationStatus.equals("Endangered")) {
          e = 1;
        }
        else if (speciesInPark.get(i).conservationStatus.equals("Species Of Concern")) {
          s = 1;
        }
        else if (speciesInPark.get(i).conservationStatus.equals("Threatened")) {
          t = 1;
        }
        
        //select category group
        String group = "";
        for (int a=0; a<animalsGroup.length; a++) {
          if (speciesInPark.get(i).category.equals(animalsGroup[a])) {
            group = "Animals";
            animalsGroupBool = true;
            pictureIndex = a;
          }
        }
        if (!group.equals("Animals")) {
          for (int a=0; a<plantsGroup.length; a++) {
            if (speciesInPark.get(i).category.equals(plantsGroup[a])) {
              group = "Plants";
              plantsGroupBool = true;
              pictureIndex = a;
            }
          }
        }
        else if (!group.equals("Animals") && !group.equals("Plants")) {
          for (int a=0; a<fungiGroup.length; a++) {
            if (speciesInPark.get(i).category.equals(fungiGroup[a])) {
              group = "Fungi";
              fungiGroupBool = true;
              pictureIndex = a;
            }
          }
        }

        Category newCategory = new Category(parks[p].parkName, speciesInPark.get(i).category, group, 1, s, t, e, pictureIndex);
        categories.add(newCategory);
      }
    }
    int differentGroups = 0;
    
    if (animalsGroupBool && plantsGroupBool && fungiGroupBool) {
      differentGroups = 3;
    }
    else if (animalsGroupBool && plantsGroupBool || animalsGroupBool && fungiGroupBool || plantsGroupBool && fungiGroupBool) {
      differentGroups = 2;
    }
    else if (animalsGroupBool || plantsGroupBool || fungiGroupBool) {
      differentGroups = 1;
    }
    
    parks[p].addSpeciesInfo(categories, speciesInPark.size(), speciesInPark, differentGroups, animalsGroupBool, plantsGroupBool, fungiGroupBool);
    parks[p].countSpeciesInGroup();
  }
  
  // Save points to points array
  points = new Point[parksRowCount];
  for (int i=0; i<parksRowCount; i++) {
    int x = selectedParksX[i];
    int y = selectedParksY[i];
    color c = red0;
    //calculate color
    if (parks[i].allSpeciesNumber < numberOfSpeciesBreakPoints[0]) {
      c = parksNumberOfSpeciesColors[0];
    }
    else if (parks[i].allSpeciesNumber < numberOfSpeciesBreakPoints[1]) {
      c = parksNumberOfSpeciesColors[1];
    }
    else if (parks[i].allSpeciesNumber < numberOfSpeciesBreakPoints[2]) {
      c = parksNumberOfSpeciesColors[2];
    }
    else {
      c = parksNumberOfSpeciesColors[3];
    }

    int s = (int)((parks[i].acres * maxPointSize) / maxAcres);
    if (s < minPointSize) {
      s = (int)minPointSize;
    }
    points[i] = new Point(s, x, y, i, c);
  }

  //canvas size
  size(1000, 600);
   
}

void draw() {
  background(darkGray);
  fill(lightGray);
  textFont(fontBold);
  textAlign(CENTER);
  text("Biodiversity of national parks", screenX / 2, 50);
  
  //draw background map
  shape(bg, 125, 50, screenX-250, screenY-100);
  
  drawPoints();
  
  drawNumberOfSpeciesLegend();
  drawParkAreaLegend(false);
  
  if (!parkSelected) {
    int hoveredPark = hoveredPark(mouseX, mouseY);
    
    if (hoveredPark != -1) {
      onHoveredPark(points[hoveredPark]);
    }
  }
  
  //if park is selected blur bg and show park details
  if (parkSelected) {
    
    //darken bg image
    bg.disableStyle();
    fill(mediumGrayMap);
    shape(bg, 125, 50, screenX-250, screenY-100);
    
    drawPointsBlur();
    drawNumberOfSpeciesLegendBlur();
    drawParkAreaLegend(true);
    fill(mediumGrayMap);
    text("Biodiversity of national parks", screenX / 2, 50);
    
    //blur backrgound, map, points and title
    filter(BLUR, 5);
    
    //close button
    shape(closeButton, closeButtonX, closeButtonY, closeButtonSize, closeButtonSize);
    
    showParkDetails();
    
    checkSubcategoryHover();
    
  }
}

//--------------------------------------------------------
//ALL PARKS SCREEN
//--------------------------------------------------------

void drawPoints() {
    for (int i = 0; i < parksRowCount; i++) {
      fill(points[i].pointColor);
      ellipse(int(points[i].x), int(points[i].y), int(points[i].size), int(points[i].size));
      smooth();
      noStroke();
  }
}

void drawPointsBlur() {
    for (int i = 0; i < parksRowCount; i++) { //<>//
      ellipse(int(points[i].x), int(points[i].y), int(points[i].size), int(points[i].size));
      smooth();
      fill(darkRed);
      noStroke();
  }
}
 //<>//
void drawHoveredPoint(SubcategoryPoint point, String group) {
    int border = 5;
    fill(darkGray);
    strokeWeight(border);
    stroke(point.pointColor);
    ellipse(point.x, point.y, subcategoryCircleSize+3*border, subcategoryCircleSize+3*border);
    noStroke();
    fill(point.pointColor);
    text(point.subcategoryNumber, point.x, point.y-5);
    textFont(fontBoldExtraSmall);
    textAlign(CENTER);
    textFont(fontBoldExtraExtraSmall);
    
    if (group.equals("Animals")) {
      text(animalsGroupDictionary.get(point.subcategoryName), point.x, point.y+8);
    }
    if (group.equals("Plants")) {
      text(plantsGroupDictionary.get(point.subcategoryName), point.x, point.y+8);
    }
}

void drawNumberOfSpeciesLegend() {
  fill(darkGray);
  int h = 80;
  int w = 275;
  int margin = 30;
  rect(margin, screenY-(margin + h), w, h, 7);
  fill(lightGray);
  textFont(fontBoldSmall);
  textAlign(LEFT);
  int textYposition = screenY-(margin + h)+25;
  text("Number of species", margin, textYposition);
  
  //draw small squares and write text
  int squareXpadding = 10;
  int squareYpadding = 10;
  int squareW = 30;
  int squareXbetweenSpace = (int)((w - 2*squareXpadding - parksNumberOfSpeciesColors.length*squareW) / (parksNumberOfSpeciesColors.length-1));
  int squareYposition = textYposition + squareYpadding;
  int squareXposition = margin + squareXpadding;
  
  for (int i=0; i<parksNumberOfSpeciesColors.length; i++) {
    
    fill(parksNumberOfSpeciesColors[i]);
    rect(squareXposition, squareYposition, squareW, squareW, 5);
    textAlign(CENTER);
    textFont(fontBoldExtraSmall);
    fill(lightGray);
    text(numberOfSpeciesText[i], squareXposition + (squareW/2), squareYposition + squareW + 15);
    squareXposition = squareXposition + squareXbetweenSpace + squareW;
  }
}

void drawNumberOfSpeciesLegendBlur() {
  fill(darkGray);
  int h = 80;
  int w = 275;
  int margin = 30;
  rect(margin, screenY-(margin + h), w, h, 7);
}

void drawParkAreaLegend(boolean blur) {
  int h = 100;
  int margin = 30;
  int textYposition = screenY-h-margin-20;
  int textXposition = screenX - margin;
  
  if (blur) {
    fill(mediumGray);
  }
  else {
    fill(lightGray);
  }
  
  textFont(fontBoldSmall);
  textAlign(RIGHT);
  text("Park area", textXposition, textYposition);
  
  fill(darkGray);
  strokeWeight(2);
  
  if (blur) {
    stroke(mediumGray);
  }
  else {
    stroke(lightGray);
  }
  
  ellipseMode(CORNER);
  ellipse(textXposition-90, textYposition + 10, 90, 90);
  ellipse(textXposition-90-50, textYposition + 90-15, 15, 15);
  ellipseMode(CENTER);
  noStroke();
  textAlign(CENTER);
  textFont(fontBoldExtraSmall);
  
  if (blur) {
    fill(mediumGray);
  }
  else {
    fill(lightGray);
  }
  text("> 1000k ac", screenX-margin-90/2, textYposition + 120);
  text("< 250k ac", screenX-margin-90-margin-15/2, textYposition + 120);
  noStroke();
}


//-----------------------------------------------------------------
//PARK DETAILS SCREEN
//-----------------------------------------------------------------

void drawCategories(Park selectedPark) {
  fill(red0);
  int i=0;
  int xEllipse;
  int yEllipse;
  int categorySize = 100;

  if (selectedPark.animalsGroupCount > 0) {
    xEllipse = screenX / 4 + 80;
    yEllipse = screenY / 2; 
    drawSubcategories((int)(xEllipse), (int)(yEllipse), selectedPark, "Animals");
    fill(lightGray);
    ellipse(xEllipse, yEllipse, categorySize, categorySize); 
    smooth();
    noStroke();
    fill(darkGray);
    textFont(fontBoldExtraSmall);
    textAlign(CENTER);
    text("ANIMALS", xEllipse, yEllipse + 5);
    i++;
  }
  
  if (selectedPark.plantsGroupCount > 0) {
    int xEllipseP = screenX - screenX / 4 - 80;
    int yEllipseP = screenY / 2;
    drawSubcategories((int)(xEllipseP), (int)(yEllipseP), selectedPark, "Plants");
    fill(lightGray);
    ellipse(xEllipseP, yEllipseP, categorySize, categorySize); 
    fill(darkGray);
    textFont(fontBoldExtraSmall);
    textAlign(CENTER);
    text("PLANTS", xEllipseP, yEllipseP + 5);
    i++;
  }
  
  if (selectedPark.fungiGroupCount > 0) {
    int size = Math.round(maxCategoryCircleSize * selectedPark.fungiGroupCount / selectedPark.allSpeciesNumber);
    fill(red0);
    ellipse(screenX / selectedPark.differentGroups / 2 + i * screenX / selectedPark.differentGroups, screenY / 2, size , size);   
    i++;
  }
  animalsPlantsRatio(selectedPark);
}

void drawSubcategories(int centerX, int centerY, Park selectedPark, String selectedGroup) {
  List<Category> selectedCategories = new ArrayList<Category>();

  int n = 0;
  for (int i=0; i<selectedPark.categories.size(); i++) {
    Category currentCategory = selectedPark.categories.get(i);
    if (currentCategory.group.equals(selectedGroup)) {
      selectedCategories.add(currentCategory);
      n++;
    }
  }
  
  int[] xPoints = calculateX(centerX, categoryDistanceRadius, n);
  int[] yPoints = calculateY(centerY, categoryDistanceRadius, n);
  
  //draw circles 
  if (selectedGroup.equals("Animals")){
    currentSubcategoriesAnimals = new SubcategoryPoint[n];
  }
  else {
    currentSubcategoriesPlants = new SubcategoryPoint[n];
  }
  
  for (int i=0; i<n; i++) {
    color c;
    PShape picture;
    //choose color
    if (selectedCategories.get(i).speciesNumber < numberOfSpeciesSubcategoriesBreakPoints[0]) {
      c = numberOfSpeciesSubcategoriesColors[0];
    }
    else if (selectedCategories.get(i).speciesNumber < numberOfSpeciesSubcategoriesBreakPoints[1]) {
      c = numberOfSpeciesSubcategoriesColors[1];
    }
    else if (selectedCategories.get(i).speciesNumber < numberOfSpeciesSubcategoriesBreakPoints[2]) {
      c = numberOfSpeciesSubcategoriesColors[2];
    }
    else {
      c = numberOfSpeciesSubcategoriesColors[3];
    }
    
    //fill currentSubcategoriesAnimals or Plants array and picture
    if (selectedGroup.equals("Animals")){
      picture = animalsGroupImages[selectedCategories.get(i).pictureIndex];
      currentSubcategoriesAnimals[i] = new SubcategoryPoint(subcategoryCircleSize, xPoints[i], yPoints[i], c, 
          selectedCategories.get(i).categoryName, selectedCategories.get(i).speciesNumber, selectedCategories.get(i).pictureIndex, animalsGroupImages[selectedCategories.get(i).pictureIndex]);
    }
    else {
      picture = plantsGroupImages[selectedCategories.get(i).pictureIndex];
      currentSubcategoriesPlants[i] = new SubcategoryPoint(subcategoryCircleSize, xPoints[i], yPoints[i], c, 
        selectedCategories.get(i).categoryName, selectedCategories.get(i).speciesNumber, selectedCategories.get(i).pictureIndex, plantsGroupImages[selectedCategories.get(i).pictureIndex]);
    }
   
    stroke(lightGray);
    strokeWeight(4);
    line(xPoints[i], yPoints[i], centerX, centerY);
    noStroke();
    fill(c);
    ellipse(xPoints[i], yPoints[i], subcategoryCircleSize, subcategoryCircleSize);
    fill(lightGray);
    shapeMode(CENTER);
    // Ignore the colors in the SVG
    picture.disableStyle();  
    fill(darkGray);
    shape(picture, xPoints[i], yPoints[i], 50, 50);
    shapeMode(CORNER);
  }
}

void checkSubcategoryHover() {
  int x = mouseX;
  int y = mouseY;
  
  //check animals category points
  int hovered = hoveredSubcategory(x, y, currentSubcategoriesAnimals);
  if (hovered != -1) {
    subcategoryHoverPoint = currentSubcategoriesAnimals[hovered];
    drawHoveredPoint(subcategoryHoverPoint, "Animals");
  }
  //check plants category points 
  else {
    hovered = hoveredSubcategory(x, y, currentSubcategoriesPlants);
    if (hovered != -1) {
      subcategoryHoverPoint = currentSubcategoriesPlants[hovered];
      drawHoveredPoint(subcategoryHoverPoint, "Plants");
    }
    //show normal point
    else {
      if (subcategoryHoverPoint != null) {
        //draw subcategory normal point
        fill(subcategoryHoverPoint.pointColor);
        ellipse(subcategoryHoverPoint.x, subcategoryHoverPoint.y, subcategoryCircleSize, subcategoryCircleSize);
        fill(lightGray);
        PShape picture = subcategoryHoverPoint.picture;
        shapeMode(CENTER);
        // Ignore the colors in the SVG
        picture.disableStyle();
        fill(darkGray);
        shape(picture, subcategoryHoverPoint.x, subcategoryHoverPoint.y, 50, 50);
        shapeMode(CORNER);
        
        //set subcategory hover point to null
        subcategoryHoverPoint = null;
      }
    }
  }
}

int hoveredSubcategory(int x_mouse, int y_mouse, SubcategoryPoint[] points) {
  //returns index of the hovered category
  for (int i=0; i<points.length; i++) {
    if (abs(x_mouse - points[i].x) < points[i].size) {
      if (abs(y_mouse - points[i].y) < points[i].size) {
        return i;
      }
    }
  }
  return -1;
}

void animalsPlantsRatio(Park p) {
  int allSpecies = p.animalsGroupCount + p.plantsGroupCount;
  int allW = 250;
  int allH = 30;
  int animalsW = (int)((p.animalsGroupCount * allW) / allSpecies);
  int plantsW = (int)((p.plantsGroupCount * allW) / allSpecies);
  fill(lightGray);
  strokeWeight(3);
  stroke(darkGray);
  int margin = 30;
  rect(screenX - margin - plantsW, screenY-(margin + allH), plantsW, allH);
  fill(lightGray);
  rect(screenX - margin - animalsW - plantsW, screenY-(margin + allH), animalsW, allH);
  noStroke();
  fill(lightGray);
  textFont(fontBoldSmall);
  //textAlign(CENTER);
  textAlign(RIGHT);
  int textYposition = screenY- margin - allH - 13;
  textAlign(LEFT);
  text("Animals", screenX - margin - plantsW - animalsW, textYposition);
  textAlign(CENTER);
  text(":", screenX - margin - ((plantsW+animalsW)/2), textYposition);
  textAlign(RIGHT);
  text("Plants", screenX - margin, textYposition);
}

void drawNumberOfSpeciesLegendParkDetails() {
  fill(darkGray);
  int h = 80;
  int w = 275;
  int margin = 30;
  fill(lightGray);
  textFont(fontBoldSmall);
  textAlign(LEFT);
  int textYposition = screenY-(margin + h)+25;
  text("Number of species", margin, textYposition);
  
  //draw small squares and write text
  int squareXpadding = 10;
  int squareYpadding = 10;
  int squareW = 30;
  int squareXbetweenSpace = (int)((w - 2*squareXpadding - parksNumberOfSpeciesColors.length*squareW) / (parksNumberOfSpeciesColors.length-1));
  int squareYposition = textYposition + squareYpadding;
  int squareXposition = margin + squareXpadding;

  for (int i=0; i<numberOfSpeciesSubcategoriesColors.length; i++) {    
    fill(numberOfSpeciesSubcategoriesColors[i]);
    rect(squareXposition, squareYposition, squareW, squareW, 5);
    textAlign(CENTER);
    textFont(fontBoldExtraSmall);
    fill(lightGray);
    text(numberOfSpeciesSubcategoryText[i], squareXposition + (squareW/2), squareYposition + squareW + 15);
    squareXposition = squareXposition + squareXbetweenSpace + squareW;
  }
}

void showParkDetails() {
    Park selectedPark = parks[clickedParkIndex];
    textAlign(CENTER);
    fill(234, 121, 60);
    textFont(fontBold);
    text(selectedPark.parkName, screenX / 2, 70);
    textFont(fontBoldExtraSmall);
    fill(245, 181, 96);
    text("AREA: " + (int)selectedPark.acres + " ac | " + "SPECIES: " + selectedPark.allSpeciesNumber, screenX / 2, 90); 
    
    drawCategories(selectedPark);
    drawNumberOfSpeciesLegendParkDetails();
}

//------------------------------------------------------
//MOUSE PRESS AND HOVER EVENTS
//------------------------------------------------------

void mousePressed(){
  //find clicked park
  int clickedParkIndexNew = pressedPark(mouseX, mouseY);
  if (clickedParkIndexNew != -1) {
    clickedParkIndex = clickedParkIndexNew;
    parkSelected = true;
  }
  
  //back to homescreen if close button is clicked
  if(parkSelected && pressedClosedButton (mouseX, mouseY)) {
    parkSelected = false;
  }
}

int pressedPark(int x_mouse, int y_mouse) {
  //returns index of the clicked park
  for (int i=0; i<parksRowCount; i++) {
    if (abs(x_mouse - points[i].x) < points[i].size) {
      if (abs(y_mouse - points[i].y) < points[i].size) {
        return i;
      }
    }
  }
  return -1;
}

void onHoveredPark(Point p) {
  textFont(fontBoldSmall);
  fill(p.pointColor);
  text(parks[p.parkId].parkName, screenX/2, 85);
  textFont(fontBoldExtraSmall);
  text("AREA: " + (int)parks[p.parkId].acres + " ac | " + "SPECIES: " + parks[p.parkId].allSpeciesNumber, screenX/2, 100);
  stroke(mediumGray);
  strokeWeight(4);
  fill(p.pointColor);
  ellipse(int(p.x), int(p.y), int(p.size), int(p.size));
  noStroke();
}

int hoveredPark(int x_mouse, int y_mouse) {
  //returns index of the hovered park
  for (int i=0; i<points.length; i++) {
    if (abs(x_mouse - points[i].x) < points[i].size) {
      if (abs(y_mouse - points[i].y) < points[i].size) {
        return i;
      }
    }
  }
  return -1;
}

boolean pressedClosedButton(int x_mouse, int y_mouse) {
  //returns true if close button is clicked
  if ((abs(x_mouse - closeButtonX) < closeButtonSize) && (abs(y_mouse - closeButtonY) < closeButtonSize)) {
    return true;
  }
  return false;
}

//--------------------------------------------------------
//OTHER HELPER METHODS
//--------------------------------------------------------

public List<Species> getSpeciesInPark(String parkName) {
  List<Species> arr = new ArrayList<Species>();
  for (int i=0; i<species.length; i++) {
    if (species[i].parkName.equals(parkName)) {
      arr.add(species[i]);
    }
  }
  return arr;
}

public int[] calculateX (int centerX, int radius, int n) {
  int[] xPoints = new int[n];
  float delta = (float)(2*Math.PI / n);
  for (int i=0; i<n; i++) {
    xPoints[i] = centerX - (int)(radius * Math.cos(delta*i + (float)(Math.PI / 2)));
  } 
  return xPoints;
}

public int[] calculateY (int centerY, int radius, int n) {
  int[] yPoints = new int[n];
  float delta = (float)(2*Math.PI / n);
  for (int i=0; i<n; i++) {
    yPoints[i] = centerY - (int)(radius * Math.sin(delta*i + (float)(Math.PI / 2)));
  } 
  return yPoints;
}
