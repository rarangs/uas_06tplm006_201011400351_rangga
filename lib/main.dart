import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WeatherData>(
          create: (context) => WeatherData(),
        ),
      ],
      child: WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Cuaca',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<WeatherData>(context, listen: false).fetchWeather();
  }

  String capitalizeFirstLetter(String text) {
    if (text == null || text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final double mediaquery_height_normal = MediaQuery.of(context).size.height;
    final double mediaquery_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: mediaquery_height_normal,
              width: mediaquery_width,
              child: Image.network(
                "https://4.bp.blogspot.com/-SO0vg1YlqbY/WAkCGLx4zQI/AAAAAAAAAug/Ilna_tKqeTUyTrfLUBMEt7-n0oYuTg9YgCLcB/s1600/langit%2Bmalam%2B5.jpg",
                fit: BoxFit.fitHeight,
              )),
          Center(
            child: Consumer<WeatherData>(
              builder: (context, weatherState, _) {
                String cuaca = weatherState.city;
                cuaca = cuaca[0].toUpperCase() + cuaca.substring(1);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: mediaquery_height_normal * 0.15,
                      child: Text(
                        '${cuaca}',
                        style: GoogleFonts.poppins(
                            fontSize: mediaquery_width * 0.05,
                            color: Colors.white),
                      ),
                    ),
                    Text(
                      '${DateFormat('EEEE, dd MMMM yyyy').format(weatherState.currentDate)}',
                      style: GoogleFonts.poppins(
                          fontSize: mediaquery_width * 0.05,
                          color: Colors.white),
                    ),
                    Container(
                      height: mediaquery_height_normal * 0.3,
                      alignment: Alignment.center,
                      child: Text(
                        '${weatherState.temperature}°C',
                        style: GoogleFonts.poppins(
                            fontSize: mediaquery_width * 0.1,
                            color: Colors.white),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "Rangga Rakhazona Pamungkas - 201011400351",
                          style: GoogleFonts.poppins(
                              fontSize: mediaquery_width * 0.025,
                              color: Colors.white),
                        ),
                        Text(
                          "---------------",
                          style: GoogleFonts.poppins(
                              fontSize: mediaquery_width * 0.03,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Container(
                      height: mediaquery_height_normal * 0.02,
                      alignment: Alignment.center,
                      child: Text(
                        '${weatherState.weather}',
                        style: GoogleFonts.poppins(
                            fontSize: mediaquery_width * 0.05,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      height: mediaquery_height_normal * 0.1,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            "",
                            style: GoogleFonts.poppins(
                                fontSize: mediaquery_width * 0.03,
                                color: Colors.white),
                          ),
                          Text(
                            '${weatherState.temperature} / ${weatherState.temperature} °C',
                            style: GoogleFonts.poppins(
                                fontSize: mediaquery_width * 0.04,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherData extends ChangeNotifier {
  String apiKey = 'b5bedb63d4f648d38784f1b284518479';
  String city = 'Larangan Indah';
  String weather = '';
  String temperature = '';
  double windSpeed = 0.0;
  DateTime currentDate = DateTime.now();

  Future<void> fetchWeather() async {
    String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        weather = jsonData['weather'][0]['main'];
        temperature = jsonData['main']['temp'].toString();
        windSpeed = jsonData['wind']['speed'].toDouble();
      } else {
        weather = 'Error: ${response.statusCode}';
        temperature = 'N/A';
        windSpeed = 0.0;
      }
    } catch (e) {
      weather = 'Error: $e';
      temperature = 'N/A';
      windSpeed = 0.0;
    }

    notifyListeners();
  }
}
