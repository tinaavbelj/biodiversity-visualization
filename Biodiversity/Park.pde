class Park {
  String parkCode;
  String parkName;
  String[] states;
  String statesString;
  float acres;
  float latitude;
  float longitude;
  List<Category> categories;
  List<Species> species;
  int allSpeciesNumber;
  int differentGroups;
  boolean animalGroup;
  boolean plantsGroup;
  boolean fungiGroup;
  int animalsGroupCount = 0;
  int plantsGroupCount = 0;
  int fungiGroupCount = 0;
  int animalsCount = 0;
  int plantsCount = 0;
  int fungiCount = 0;

  public Park(String parkCode, String parkName, String[] states, String statesString, float acres, float latitude, float longitude) {
    this.parkCode = parkCode;
    this.parkName = parkName;
    this.states = states;
    this.statesString = statesString;
    this.acres = acres;
    this.latitude = latitude;
    this.longitude = longitude;
  }

  public void addSpeciesInfo(List<Category> categories, int allSpeciesNumber, List<Species> species, int differentGroups,
                             boolean animalGroup, boolean plantsGroup, boolean fungiGroup) {
    this.categories = categories;
    this.allSpeciesNumber = allSpeciesNumber;
    this.species = species;
    this.differentGroups = differentGroups;
    this.animalGroup = animalGroup;
    this.plantsGroup = plantsGroup;
    this.fungiGroup = fungiGroup;
  }

  public String getParkCode() {
    return this.parkCode;
  }

  public String getParkName() {
    return this.parkName;
  }

  public String[] getStates() {
    return this.states;
  }

  public float getAcres() {
    return this.acres;
  }

  public float getLatitude() {
    return this.latitude;
  }

  public float getLongitude() {
    return this.longitude;
  }

  public void countSpeciesInGroup() {
    this.animalsGroupCount = 0;
    this.plantsGroupCount = 0;
    this.fungiGroupCount = 0;

    for (Category category : this.categories) {
      switch (category.group) {
        case "Animals":
          this.animalsGroupCount += category.speciesNumber;
          break;
        case "Plants":
          this.plantsGroupCount += category.speciesNumber;
          break;
        case "Fungi":
          this.fungiGroupCount += category.speciesNumber;
          break;
      }
    }
  }
}