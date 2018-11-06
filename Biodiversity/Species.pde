class Species {
  String speciesId;
  String parkName;
  String category;
  String order;
  String family;
  String scientificName;
  String[] commonNames;
  String recordStatus;
  String occurence;
  String nativeness;
  String abundance;
  String seasonality;
  String conservationStatus;

  public Species(String speciesId, String parkName, String category, String order, String family, String scientificName,
                 String[] commonNames, String recordStatus, String occurence, String nativeness, String abundance,
                 String seasonality, String conservationStatus) {
    this.speciesId = speciesId;
    this.parkName = parkName;
    this.category = category;
    this.order = order;
    this.family = family;
    this.scientificName = scientificName;
    this.commonNames = commonNames;
    this.recordStatus = recordStatus;
    this.occurence = occurence;
    this.nativeness = nativeness;
    this.abundance = abundance;
    this.seasonality = seasonality;
    this.conservationStatus = conservationStatus;
  }
}
