import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weather_app_with_bloc/data/my_data.dart';
import 'package:weather_app_with_bloc/model/city_model.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitialState()) {
    on<FetchweatherEvent>((event, emit) async {
      emit(WeatherLoadingState());
      try {
        WeatherFactory wf = WeatherFactory(apiKey, language: Language.ENGLISH);

        Weather deviceLocationWeather = await wf.currentWeatherByLocation(
            event.position.latitude, event.position.longitude);
        emit(WeatherLoadingSuccessState(deviceLocationWeather));
      } catch (e) {
        emit(WeatherLoadingFailureState());
      }
    });
    on<FetchWeatherForSelectedCityEvent>(
      (event, emit) async {
        try {
          WeatherFactory wf = WeatherFactory(apiKey);

          Weather searchedCityWeather =
              await wf.currentWeatherByCityName(event.selectedCity.name);
          emit(FetchWeatherForSelectedCityLoadingSuccessState(
              searchedCityWeather));
        } catch (e) {
          emit(FetchWeatherForSelectedCityLoadingFaliureState());
        }
      },
    );
  }
}
