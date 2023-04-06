import 'dart:convert';
import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import "package:http/http.dart" as http;
import 'package:flutter_dashboard/constants/api_key.dart';

import 'package:flutter_dashboard/logic/models/weather_model.dart';

class CallToApi {
  // This method is used to call the OpenWeatherMap API to get the weather data
  Future<WeatherModel> callWeatherAPi(bool current, String cityName) async {
    try {
      // If no city name is provided, set the default to 'Toronto'
      if (cityName.isEmpty) {
        cityName = 'Toronto';
      }
      // Construct the URL for the API call using the provided API key and city name
      var url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey');

      // Send the HTTP GET request to the API and await the response
      final http.Response response = await http.get(url);
      // Check if the response status code is OK (200)
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);
        return WeatherModel.fromMap(decodedJson);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Position> getCurrentPosition() async {
    // Check if location services are enabled on the device
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // If location services are not enabled, throw an error with a message indicating that location services are disabled
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check the location permission status for the app
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // If the app does not have permission to access location data, request permission
      permission = await Geolocator.requestPermission();
      // If permission is still denied, throw an error with a message indicating that location permissions are denied
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // If the user has permanently denied location permissions for the app, throw an error with a message indicating that location permissions are permanently denied
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // If location services are enabled and the app has permission to access location data, get the user's current position and return it
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }
}
