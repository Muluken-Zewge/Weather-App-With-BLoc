part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

final class WeatherInitialState extends WeatherState {}

final class WeatherLoadingState extends WeatherState {}

final class WeatherLoadingFailureState extends WeatherState {}

final class WeatherLoadingSuccessState extends WeatherState {
  final Weather deviceLocationWeather;

  const WeatherLoadingSuccessState(this.deviceLocationWeather);

  @override
  List<Object> get props => [deviceLocationWeather];
}

final class FetchWeatherForSelectedCityLoadingState extends WeatherState {}

final class FetchWeatherForSelectedCityLoadingFaliureState
    extends WeatherState {}

final class FetchWeatherForSelectedCityLoadingSuccessState
    extends WeatherState {
  final Weather searchedCityWeather;

  const FetchWeatherForSelectedCityLoadingSuccessState(
      this.searchedCityWeather);
}
