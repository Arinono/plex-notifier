class Metadata {
  String type;

  int librarySectionID;
  String librarySectionType;

  String ratingKey;
  int ratingCount;

  String key;
  String grandparentKey;
  String parentKey;
  String parentRatingKey;
  String grandparentRatingKey;

  String guid;
  String parentGuid;
  String grandparentGuid;

  String title;
  String grandparentTitle;
  String parentTitle;
  String contentRating;

  String summary;

  int index;
  int parentIndex;

  int year;

  String thumb;
  String art;
  String parentThumb;
  String grandparentThumb;
  String grandparentArt;

  int addedAt;
  int updatedAt;

  Metadata(Map meta) {
    type = meta['type'];
    librarySectionID = meta['librarySectionID'];
    librarySectionType = meta['librarySectionType'];
    ratingKey = meta['ratingKey'];
    ratingCount = meta['ratingCount'];
    key = meta['key'];
    grandparentKey = meta['grandparentKey'];
    parentKey = meta['parentKey'];
    parentRatingKey = meta['parentRatingKey'];
    grandparentRatingKey = meta['grandparentRatingKey'];
    guid = meta['guid'];
    parentGuid = meta['parentGuid'];
    grandparentGuid = meta['grandparentGuid'];
    title = meta['title'];
    grandparentTitle = meta['grandparentTitle'];
    parentTitle = meta['parentTitle'];
    contentRating = meta['contentRating'];
    summary = meta['summary'];
    index = meta['index'];
    parentIndex = meta['parentIndex'];
    year = meta['year'];
    thumb = meta['thumb'];
    art = meta['art'];
    parentThumb = meta['parentThumb'];
    grandparentThumb = meta['grandparentThumb'];
    grandparentArt = meta['grandparentArt'];
    addedAt = meta['addedAt'];
    updatedAt = meta['updatedAt'];
  }
}
