class SubcategoryPoint {
  float size;
  float x;
  float y;
  color pointColor;
  String subcategoryName;
  int subcategoryNumber;
  int categoryPictureIndex;
  PShape picture;

  public SubcategoryPoint(float size, float x, float y, color pointColor, String subcategoryName, int subcategoryNumber, int categoryPictureIndex, PShape picture) {
    this.size = size;
    this.x = x;
    this.y = y;
    this.pointColor = pointColor;
    this.subcategoryName = subcategoryName;
    this.subcategoryNumber = subcategoryNumber;
    this.categoryPictureIndex = categoryPictureIndex;
    this.picture = picture;
  }
}
