class Party {
  String id;
  PartySize size;

  Party(Map party) {
    id = party['id'];
    size = PartySize(party['size']);
  }
}

class PartySize {
  int current;
  int max;

  PartySize(List<int> size) {
    if (size.length > 2) {
      throw PartySizeException();
    }
    current = size[0];
    max = size[1];
  }
}

class PartySizeException implements Exception {
  PartySizeException();
}
