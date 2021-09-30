/*class Location {
  LocationData({
    this.key,
    this.name,
    this.address,
    this.type,
  });

  String key;
  String name;
  String address;
  String type;

  Map<String, Object> toMap() {
    return {
      'key': key,
      'nomLocation': name,
      'addressLocation': address,
      'type': type,
    };
  }

  static LocationData fromMap(Map value) {
    if (value == null) {
      return null;
    }

    return LocationData(
      key: value['id'],
      name: value['nomLocation'],
      address: value['addressLocation'],
      type: value['status'],
    );
  }

  @override
  String toString() {
    return ('{key: $key, nomLocation: $name, addressLocation:$address status: $type}');
  }
}
*/
