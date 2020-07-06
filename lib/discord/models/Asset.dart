class Asset {
  String largeImage;
  String largeText;
  String smallImage;
  String smallText;

  Asset(Map asset) {
    largeImage = asset['large_image'];
    largeText = asset['large_text'];
    smallImage = asset['small_image'];
    smallText = asset['small_text'];
  }
}
