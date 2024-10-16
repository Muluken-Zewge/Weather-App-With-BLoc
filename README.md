# weather App With Bloc State Management

## Overview

A Flutter-based weather application that fetches current weather data from the OpenWeatherMap API. The app utilizes geolocation to show weather information for the user's location and provides a search feature to check weather conditions for any city worldwide. BLoC state management is used to handle the various states of the app.

## Feature

- **Current Location Weather**: Fetches weather data based on the device's geolocation using the Geolocator Plugin.
- **Search Weather by City**: Allows users to search for any city in the world and view its weather conditions. Features an autocomplete search functionality that displays city names as the user types.
- **BLoC State Management**: Manages different states of the app (loading, success, error, etc.)

## Teck Stack

- **Flutter**: Cross-platform mobile development framework.
- **OpenWeatherMap API**: Provides real-time weather data.
- **Geolocator Plugin**: Fetches the device's current location.
- **Weather Package**: Interfaces with the OpenWeatherMap API for weather information.
- **BLoC**: State management for controlling the flow of data within the app.

## API Key Setup

To fetch weather data, you'll need an API key from OpenWeatherMap:

### 1. Sign up on OpenWeatherMap and get your API key.

### 2. Add your API key to the project

## Permissions

The app requires the following permissions:

- **Location**: To fetch weather data for the user's current location.
