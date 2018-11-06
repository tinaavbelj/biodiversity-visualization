class Category {
  String parkName;
  String categoryName;
  String group; //Animals, Plants, Fungi
  int speciesNumber;
  int speciesOfConcern;
  int threatened;
  int endangered;
  int pictureIndex;

  public Category(String parkName, String categoryName, String group, int speciesNumber, int speciesOfConcern, int threatened, int endangered, int pictureIndex) {
    this.parkName = parkName;
    this.categoryName = categoryName;
    this.group = group;
    this.speciesNumber = speciesNumber;
    this.speciesOfConcern = speciesOfConcern;
    this.threatened = threatened;
    this.endangered = endangered;
    this.pictureIndex = pictureIndex;
  }
}
