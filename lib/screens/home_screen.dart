import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app_with_bloc/bloc/weather_bloc.dart';
import 'package:weather_app_with_bloc/model/city_model.dart';
import 'package:weather_app_with_bloc/screens/weather_detail_screen.dart';
import 'package:weather_app_with_bloc/services/city_service.dart';

class HomeScreen extends StatefulWidget {
  final Position currentPosition;
  const HomeScreen({super.key, required this.currentPosition});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  final CityService cityService = CityService();

  @override
  void initState() {
    super.initState();
    cityService.loadCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
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
                  decoration: const BoxDecoration(color: Colors.transparent),
                ),
              ),
              FutureBuilder(
                  future: cityService.loadCities(),
                  builder: (context, snapshot) {
                    return BlocBuilder<WeatherBloc, WeatherState>(
                      builder: (context, state) {
                        if (state is WeatherLoadingSuccessState ||
                            state
                                is FetchWeatherForSelectedCityLoadingSuccessState) {
                          final Weather weather = state
                                  is WeatherLoadingSuccessState
                              ? state.deviceLocationWeather
                              : (state
                                      as FetchWeatherForSelectedCityLoadingSuccessState)
                                  .searchedCityWeather;
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BlocListener<WeatherBloc, WeatherState>(
                                    listener: (context, state) {
                                      if (state
                                          is FetchWeatherForSelectedCityLoadingSuccessState) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WeatherDetailScreen(
                                                        seletedCityWeather: state
                                                            .searchedCityWeather,
                                                        currentPosition: widget
                                                            .currentPosition)));
                                      } else if (state
                                          is FetchWeatherForSelectedCityLoadingFaliureState) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Failed to load weather data')));
                                      }
                                    },
                                    child: Autocomplete<City>(
                                        optionsBuilder: (TextEditingValue
                                            textEditingValue) {
                                          if (textEditingValue.text.isEmpty) {
                                            return const Iterable.empty();
                                          }
                                          return cityService.searchCities(
                                              textEditingValue.text);
                                        },
                                        fieldViewBuilder: (context,
                                            textEditingController,
                                            focusNode,
                                            onFieldSubmitted) {
                                          return TextField(
                                            controller: textEditingController,
                                            focusNode: focusNode,
                                            decoration: InputDecoration(
                                                hintText: 'Search for a City',
                                                hintStyle: const TextStyle(
                                                    color: Colors.white38),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .blueGrey))),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          );
                                        },
                                        displayStringForOption: (options) =>
                                            '${options.name}, ${options.country}',
                                        onSelected: (City selectedCity) {
                                          BlocProvider.of<WeatherBloc>(context)
                                              .add(
                                                  FetchWeatherForSelectedCityEvent(
                                                      selectedCity));
                                        }),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(children: [
                                    const Icon(Icons.location_on_outlined,
                                        color: Colors.white),
                                    Text(
                                      '${weather.areaName}',
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
                                  getWeatherIcon(weather.weatherConditionCode!),
                                  Center(
                                    child: Text(
                                      '${weather.temperature!.celsius!.round()}\u00B0C',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 25),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      weather.weatherMain
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
                                          .format(weather.date!),
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
                                          Image.asset('assets/11.png',
                                              scale: 8),
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
                                                DateFormat()
                                                    .add_jm()
                                                    .format(weather.sunrise!),
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
                                          Image.asset('assets/12.png',
                                              scale: 8),
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
                                                DateFormat()
                                                    .add_jm()
                                                    .format(weather.sunset!),
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
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
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
                                          Image.asset('assets/13.png',
                                              scale: 8),
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
                                                '${weather.tempMax!.celsius!.round()} \u00B0C',
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
                                          Image.asset('assets/14.png',
                                              scale: 8),
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
                                                '${weather.tempMin!.celsius!.round()} \u00B0C',
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
                          );
                        } else {
                          return const Center(
                            child: Text('Failed to Load Weather Data'),
                          );
                        }
                      },
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
