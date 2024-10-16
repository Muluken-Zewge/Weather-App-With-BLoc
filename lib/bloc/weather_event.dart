part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class FetchweatherEvent extends WeatherEvent {
  final Position position;

  const FetchweatherEvent(this.position);

  @override
  List<Object> get props => [position];
}

class FetchWeatherForSelectedCityEvent extends WeatherEvent {
  final City selectedCity;

  const FetchWeatherForSelectedCityEvent(this.selectedCity);
}

class ResetWeatherEvent extends WeatherEvent {}
