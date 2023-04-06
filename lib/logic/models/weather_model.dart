class WeatherModel {
  final String temp;
  final String city;
  final String desc;
  final String tempMin;
  final String tempMax;

  WeatherModel.fromMap(Map<String, dynamic> json)
      : temp = json['main']['temp'].toString(),
        tempMax = json['main']['temp_max'].toString(),
        tempMin = json['main']['temp_min'].toString(),
        city = json['name'],
        desc = json['weather'][0]['description'];
}
