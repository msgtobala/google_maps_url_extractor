import 'package:http/http.dart' as http;

class GoogleMapsUrlExtractor {
  /// A utility class for extracting location information from Google Maps URLs.
  ///
  /// This class provides methods to expand shortened Google Maps URLs,
  /// extract coordinates from full Google Maps URLs, and process URLs
  /// to retrieve location information.
  ///
  /// Example usage:
  /// ```dart
  /// final url = 'https://maps.app.goo.gl/mWtb4a1cUE9zMWya7';
  /// final coordinates = await GoogleMapsUrlExtractor.processGoogleMapsUrl(url);
  /// if (coordinates != null) {
  ///   print('Latitude: ${coordinates['latitude']}');
  ///   print('Longitude: ${coordinates['longitude']}');
  /// } else {
  ///   print('Failed to extract coordinates');
  /// }
  /// ```
  static Future<String?> expandShortUrl(String shortUrl) async {
    try {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(shortUrl))
        ..followRedirects = false;
      final response = await client.send(request);

      if (response.statusCode == 301 || response.statusCode == 302) {
        final location = response.headers['location'];
        client.close();
        return location;
      }
      client.close();
    } catch (e) {
      print('Error expanding URL: $e');
    }
    return null;
  }

  /// Extracts latitude and longitude coordinates from a Google Maps URL.
  ///
  /// This method parses the given URL and attempts to extract the latitude and longitude
  /// coordinates embedded within it. It supports various Google Maps URL formats,
  /// including standard map URLs, place URLs, search URLs, and direction URLs.
  ///
  /// Returns a [Map] containing 'latitude' and 'longitude' keys with their respective
  /// double values if coordinates are successfully extracted. Returns null if the URL
  /// is invalid or coordinates cannot be found.
  ///
  /// Example usage:
  /// ```dart
  /// final url = 'https://www.google.com/maps/@37.7749,-122.4194,15z';
  /// final coordinates = GoogleMapsUrlExtractor.extractCoordinates(url);
  /// if (coordinates != null) {
  ///   print('Latitude: ${coordinates['latitude']}');
  ///   print('Longitude: ${coordinates['longitude']}');
  /// } else {
  ///   print('Failed to extract coordinates');
  /// }
  /// ```
  static Map<String, double>? extractCoordinates(String url) {
    final regex = RegExp(r'!3d(-?\d+\.\d+)!4d(-?\d+\.\d+)');
    final match = regex.firstMatch(url);

    if (match != null) {
      return {
        'latitude': double.parse(match.group(1)!),
        'longitude': double.parse(match.group(2)!),
      };
    }
    return null;
  }

  /// Processes a Google Maps URL, expanding it if it's a short URL, and then extracts coordinates.
  ///
  /// This method combines the functionality of [expandShortUrl] and [extractCoordinates].
  /// It first checks if the URL is a shortened Google Maps URL (containing 'goo.gl' or 'maps.app.goo.gl').
  /// If it is, it expands the URL. Then, it attempts to extract coordinates from the resulting URL.
  ///
  /// Returns a [Map] containing 'latitude' and 'longitude' keys with their respective
  /// double values if coordinates are successfully extracted. Returns null if the URL
  /// is invalid, expansion fails, or coordinates cannot be found.
  ///
  /// Example usage:
  /// ```dart
  /// final shortUrl = 'https://goo.gl/maps/abcdefg';
  /// final coordinates = await GoogleMapsUrlExtractor.processGoogleMapsUrl(shortUrl);
  /// if (coordinates != null) {
  ///   print('Latitude: ${coordinates['latitude']}');
  ///   print('Longitude: ${coordinates['longitude']}');
  /// } else {
  ///   print('Failed to process URL');
  /// }
  /// ```
  static Future<Map<String, double>?> processGoogleMapsUrl(String url) async {
    if (url.contains('goo.gl') || url.contains('maps.app.goo.gl')) {
      final expandedUrl = await expandShortUrl(url);
      if (expandedUrl != null) {
        url = expandedUrl;
      } else {
        print('Failed to expand short URL');
        return null;
      }
    }

    return extractCoordinates(url);
  }
}
