import 'dart:developer';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/constants/constants.dart';
import 'package:flutter_dashboard/logic/models/weather_model.dart';
import 'package:flutter_dashboard/logic/services/call_to_api.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // Call a service to use weather API and get a response.
  Future<WeatherModel> getData(bool isCurrentCity, String cityName) async {
    return await CallToApi().callWeatherAPi(isCurrentCity, cityName);
  }

  TextEditingController textController = TextEditingController(text: "");
  // define a function to fetch weather data from the API
  Future<WeatherModel>? _myData;
  @override
  void initState() {
    setState(() {
      // initialize the weather data with the user's current location
      _myData = getData(true, "");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Weather',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          // check the connection state of the future
          if (snapshot.connectionState == ConnectionState.done) {
            // If error occured
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error.toString()} occurred',
                  style: TextStyle(fontSize: 18),
                ),
              );

              // if data has no errors
            } else if (snapshot.hasData) {
              // Extracting data from snapshot object
              final data = snapshot.data as WeatherModel;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color.fromRGBO(151, 185, 239, 1),
                      Color.fromRGBO(165, 178, 238, 1),
                      Color.fromRGBO(179, 172, 237, 1),
                      Color.fromRGBO(192, 165, 237, 1),
                      Color.fromRGBO(206, 158, 236, 1),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
                width: double.infinity,
                height: double.infinity,
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Clear button
                          ElevatedButton(
                            onPressed: () => context.go('/calculator'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.all(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calculate,
                                    size: 48, color: Colors.orange),
                                SizedBox(width: 8),
                                Text(
                                  'Calculator',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      height25,
                      // Add search bar with styling and functionality
                      AnimSearchBar(
                        rtl: false,
                        width: 400,
                        color: Color.fromRGBO(83, 219, 242, 1),
                        textController: textController,
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 20,
                        ),
                        onSuffixTap: () async {
                          textController.text == ""
                              ? log("No city entered")
                              : setState(() {
                                  _myData = getData(false, textController.text);
                                });

                          FocusScope.of(context).unfocus();
                          textController.clear();
                        },
                        style: f14RblackLetterSpacing2,
                        onSubmitted: (String) {},
                      ),
                      Text(
                        "To get started, type the name of a city in the search bar and click on the search icon.",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data.city,
                              style: f48Rwhitebold,
                            ),
                            SizedBox(height: 32.0),
                            Text(
                              "${data.temp}°C",
                              style: f32Rwhitebold,
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_upward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Text(
                                  '${data.tempMin}°C',
                                  style: f16PW,
                                ),
                                SizedBox(width: 16.0),
                                Icon(
                                  Icons.arrow_downward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Text(
                                  '${data.tempMax}°C',
                                  style: f16PW,
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              data.desc,
                              style: f24PW,
                            ),
                            SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                      Text(
                        'Stay informed and plan your day with confidence!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text("${snapshot.connectionState} occured"),
            );
          }
          return Center(
            child: Text("Server timed out!"),
          );
        },
        future: _myData!,
      ),
    );
  }
}
