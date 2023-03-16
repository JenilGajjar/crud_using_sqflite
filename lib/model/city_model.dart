class CityModel{
  late int _CityID;
  late String _CityName;

  String get CityName => _CityName;

  set CityName(String value) {
    _CityName = value;
  }
  int get CityID => _CityID;

  set CityID(int value) {
    _CityID = value;
  }
}