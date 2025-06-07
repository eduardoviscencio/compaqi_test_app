class FavoritesPlacesApi {
  Future<List<String>> fetchFavoritePlaces() async {
    await Future.delayed(Duration(seconds: 2));
    return ['Place 1', 'Place 2', 'Place 3'];
  }
}
