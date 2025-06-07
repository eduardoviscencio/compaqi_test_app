class Environment {
  static String get mapsApiKey =>
      const String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue: 'api_key_not_found');
}
