import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_forcast/constants/api_key.dart';

import '../constants/colorConstants.dart';
import '../models/weather_model.dart';
import '../services/weather_services.dart';
import '../widgets/customWidget.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
  final _weatherService = WeatherServices(apiKey: API_KEY);

  // List to maintain searched cities and their weather data
  final List<Weather?> _weatherData = [];
  final List<String> _cities = [];

  // Fetch weather method with optional cityName parameter
  Future<void> _fetchWeather(String? cityName) async {
    try {
      if (cityName != null) {
        // Fetch weather for the entered city
        final weather = await _weatherService.getWeather(cityName);
        setState(() {
          _cities.add(cityName);
          _weatherData.add(weather);
        });
      } else {
        // Fetch weather for current location
        String currentCity = await _weatherService.getCurrentCity();
        final weather = await _weatherService.getWeather(currentCity);
        setState(() {
          _cities.add(currentCity);
          _weatherData.add(weather);
        });
      }
    } catch (e) {
      print(e);
    }
  }

// Animation according to weather conditions
  String _getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/lottie/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/lottie/cloud.json';
      case 'mist':
        return 'assets/lottie/mist.json';
      case 'smoke':
      case 'haze':
      case 'fog':
        return 'assets/lottie/mist.json';
      case 'drizzle':
      case 'shower rain':
        return 'assets/lottie/rain.json';
      case 'rain':
        return 'assets/lottie/rain.json';
      case 'thunderstorm':
        return 'assets/lottie/rain_thunder.json';
      case 'clear':
        return 'assets/lottie/sunny.json';
      default:
        return 'assets/lottie/sunny.json';
    }
  }

  @override
  void initState() {
    // Fetch weather for current location on app startup
    _fetchWeather(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      //==============================🔻 App Bar 🔻===============================//
      appBar: AppBar(
        elevation: 0,
        backgroundColor: TRANSPARENT_COLOR,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.blur_on,
              color: MAIN_COLOR,
              size: 45,
            ),
            Text(
              'Weather',
              style: TextStyle(
                fontSize: size.width * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.01),
            Expanded(
              //==========================🔻 PageView 🔻===========================//
              child: PageView.builder(
                controller: _pageController,
                itemCount: _weatherData.length,
                itemBuilder: (context, index) {
                  final weather = _weatherData[index];
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.03),
                        //====================🔻 Icon & Location 🔻===================//

                        const Icon(Icons.location_on),
                        Text(
                          weather?.cityName ?? "No location",
                          style: TextStyle(
                            fontSize: size.width * 0.1,
                            fontFamily: GoogleFonts.orbitron().fontFamily,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        //======================🔻 Animation 🔻=======================//
                        SizedBox(
                          height: size.height * 0.18,
                          child: Lottie.asset(
                            _getWeatherAnimation(weather?.mainCondition),
                          ),
                        ),
                        //================🔻 Temp & condition 🔻======================//
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: MAIN_COLOR,
                                ),
                                Text(
                                  '${weather?.min_temprature.round().toString()}',
                                  style: TextStyle(
                                    fontSize: size.width * 0.06,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.orbitron().fontFamily,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${weather?.temprature.round().toString()}°C',
                              style: TextStyle(
                                fontSize: size.width * 0.1,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.orbitron().fontFamily,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_up,
                                  color: MAX_TEMP_COLOR,
                                ),
                                Text(
                                  '${weather?.max_temprature.round().toString()}',
                                  style: TextStyle(
                                    fontSize: size.width * 0.06,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.orbitron().fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          weather?.mainCondition ?? " ",
                          style: TextStyle(
                            fontSize: size.width * 0.1,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.orbitron().fontFamily,
                            letterSpacing: 3,
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        //======================🔻 Other info 🔻======================//
                        SizedBox(
                          height: size.height * 0.2,
                          width: size.width,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              CustomSmallCard(
                                size: size,
                                icn: Icons.grain,
                                name: 'Humidity',
                                unit: '${weather?.humidity ?? "-"}%',
                              ),
                              CustomSmallCard(
                                size: size,
                                icn: Icons.ad_units_outlined,
                                name: 'Pressure',
                                unit: '${weather?.pressure ?? "-"} hPa',
                              ),
                              CustomSmallCard(
                                size: size,
                                icn: Icons.visibility,
                                name: 'Visibility',
                                unit: weather?.visibility != null
                                    ? '${(weather!.visibility / 1000).toStringAsFixed(1)} km'
                                    : '-',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: size.height * 0.01),
            //=======================🔻 Page indicator 🔻=======================//
            SmoothPageIndicator(
              controller: _pageController,
              count: _weatherData.isNotEmpty ? _weatherData.length : 1,
              axisDirection: Axis.horizontal,
              effect: SwapEffect(
                dotColor: SUBHEADING_COLOR,
                activeDotColor: MAIN_COLOR,
              ),
            ),
            //===========================🔻 City Search 🔻============================//
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 12,
                  ),
                  child: AnimSearchBar(
                    width: size.width * 0.9,
                    searchIconColor: WHITE_COLOR,
                    textFieldIconColor: WHITE_COLOR,
                    textController: _searchController,
                    onSuffixTap: () {},
                    onSubmitted: (cityName) {
                      _fetchWeather(cityName);
                    },
                    color: MAIN_COLOR,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
