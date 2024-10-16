import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app_with_bloc/bloc/weather_bloc.dart';

class WeatherDetailScreen extends StatelessWidget {
  final Weather seletedCityWeather;
  final Position currentPosition;

  const WeatherDetailScreen(
      {super.key,
      required this.seletedCityWeather,
      required this.currentPosition});

  Widget getWeatherIcon(int code) {
    switch (code) {
      case >= 200 && < 300:
        return Image.asset('assets/1.png');
      case >= 300 && < 400:
        return Image.asset('assets/2.png');
      case >= 500 && < 600:
        return Image.asset('assets/3.png');
      case >= 600 && < 700:
        return Image.asset('assets/4.png');
      case >= 700 && < 800:
        return Image.asset('assets/5.png');
      case == 800:
        return Image.asset('assets/6.png');
      case > 800 && <= 804:
        return Image.asset('assets/7.png');

      default:
        return Image.asset('assets/7.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didpop, result) async {
        BlocProvider.of<WeatherBloc>(context)
            .add(FetchweatherEvent(currentPosition));
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: true,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark),
          ),
          body: Padding(
              padding:
                  const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(children: [
                    Align(
                      alignment: const AlignmentDirectional(3, -0.3),
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.deepPurple),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(-3, -0.3),
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xFF673AB7)),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(-3, -0.3),
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xFFFFAB40)),
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                      child: Container(
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                      ),
                    ),
                    BlocProvider(
                      create: (context) => WeatherBloc(),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                const Icon(Icons.location_on_outlined,
                                    color: Colors.white),
                                Text(
                                  '${seletedCityWeather.areaName}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                ),
                              ]),
                              const Text(
                                'Good Morning',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                              getWeatherIcon(
                                  seletedCityWeather.weatherConditionCode!),
                              Center(
                                child: Text(
                                  '${seletedCityWeather.temperature!.celsius!.round()}\u00B0C',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25),
                                ),
                              ),
                              Center(
                                child: Text(
                                  seletedCityWeather.weatherMain
                                      .toString()
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 25),
                                ),
                              ),
                              Center(
                                child: Text(
                                  DateFormat('EEEE dd ,')
                                      .add_jm()
                                      .format(seletedCityWeather.date!),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset('assets/11.png', scale: 8),
                                      const SizedBox(width: 5),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Sunrise",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            DateFormat().add_jm().format(
                                                seletedCityWeather.sunrise!),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Image.asset('assets/12.png', scale: 8),
                                      const SizedBox(width: 5),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Sunset",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            DateFormat().add_jm().format(
                                                seletedCityWeather.sunset!),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Divider(
                                  color: Colors.grey,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset('assets/13.png', scale: 8),
                                      const SizedBox(width: 5),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Temp Max",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            '${seletedCityWeather.tempMax!.celsius!.round()} \u00B0C',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Image.asset('assets/14.png', scale: 8),
                                      const SizedBox(width: 5),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Temp Min",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            '${seletedCityWeather.tempMin!.celsius!.round()} \u00B0C',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ])))),
    );
  }
}
