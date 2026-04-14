import 'package:http/http.dart' as http;
import 'cache_manager.dart';
import 'exceptions.dart';

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
  static final CacheManager _cache = CacheManager();

  /// Expands a shortened Google Maps URL with caching support.
  ///
  /// This method expands shortened URLs (like goo.gl or maps.app.goo.gl) to their
  /// full Google Maps URLs. Results are cached to improve performance for repeated
  /// requests.
  ///
  /// Returns the expanded URL if successful, null if expansion fails.
  ///
  /// Throws [UrlExpansionException] if the URL is invalid or expansion fails.
  ///
  /// Example usage:
  /// ```dart
  /// try {
  ///   final expandedUrl = await GoogleMapsUrlExtractor.expandShortUrl(shortUrl);
  ///   if (expandedUrl != null) {
  ///     print('Expanded URL: $expandedUrl');
  ///   }
  /// } catch (e) {
  ///   print('Error: $e');
  /// }
  /// ```
  static Future<String?> expandShortUrl(String shortUrl) async {
    // Check cache first
    final cachedUrl = _cache.get('expanded_$shortUrl');
    if (cachedUrl != null) {
      return cachedUrl as String;
    }

    try {
      // Validate URL format
      if (!_isValidShortUrl(shortUrl)) {
        throw const InvalidUrlException('Invalid short URL format');
      }

      final client = http.Client();
      try {
        final request = http.Request('GET', Uri.parse(shortUrl))
          ..followRedirects = false;
        final response = await client.send(request);

        if (response.statusCode == 301 || response.statusCode == 302) {
          final location = response.headers['location'];
          if (location != null) {
            // Cache the result
            _cache.put('expanded_$shortUrl', location);
            return location;
          } else {
            throw const UrlExpansionException(
                'No location header in redirect response');
          }
        } else {
          throw UrlExpansionException(
              'Unexpected response code: ${response.statusCode}');
        }
      } finally {
        client.close();
      }
    } on InvalidUrlException {
      rethrow;
    } on UrlExpansionException {
      rethrow;
    } catch (e) {
      throw UrlExpansionException('Failed to expand URL: $e');
    }
  }

  /// Validates if a URL is a valid short URL format.
  static bool _isValidShortUrl(String url) {
    return url.contains('goo.gl') || url.contains('maps.app.goo.gl');
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
    try {
      // Try multiple regex patterns to extract coordinates from different URL formats

      // Pattern 1: !3d and !4d format (most common in place URLs)
      var regex = RegExp(r'!3d(-?\d+\.?\d*)!4d(-?\d+\.?\d*)');
      var match = regex.firstMatch(url);
      if (match != null) {
        final lat = double.parse(match.group(1)!);
        final lng = double.parse(match.group(2)!);
        if (isValidCoordinates(lat, lng)) {
          return {'latitude': lat, 'longitude': lng};
        }
      }

      // Pattern 2: @lat,lng,zoom format (standard map URLs)
      regex = RegExp(r'@(-?\d+\.?\d*),(-?\d+\.?\d*),?\d*z?');
      match = regex.firstMatch(url);
      if (match != null) {
        final lat = double.parse(match.group(1)!);
        final lng = double.parse(match.group(2)!);
        if (isValidCoordinates(lat, lng)) {
          return {'latitude': lat, 'longitude': lng};
        }
      }

      // Pattern 3: ll parameter in query string
      regex = RegExp(r'[?&]ll=(-?\d+\.?\d*),(-?\d+\.?\d*)');
      match = regex.firstMatch(url);
      if (match != null) {
        final lat = double.parse(match.group(1)!);
        final lng = double.parse(match.group(2)!);
        if (isValidCoordinates(lat, lng)) {
          return {'latitude': lat, 'longitude': lng};
        }
      }

      // Pattern 4: center parameter in query string
      regex = RegExp(r'[?&]center=(-?\d+\.?\d*),(-?\d+\.?\d*)');
      match = regex.firstMatch(url);
      if (match != null) {
        final lat = double.parse(match.group(1)!);
        final lng = double.parse(match.group(2)!);
        if (isValidCoordinates(lat, lng)) {
          return {'latitude': lat, 'longitude': lng};
        }
      }

      // Pattern 5: destination parameter in query string
      regex = RegExp(r'[?&]destination=(-?\d+\.?\d*),(-?\d+\.?\d*)');
      match = regex.firstMatch(url);
      if (match != null) {
        final lat = double.parse(match.group(1)!);
        final lng = double.parse(match.group(2)!);
        if (isValidCoordinates(lat, lng)) {
          return {'latitude': lat, 'longitude': lng};
        }
      }

      // Pattern 6: query parameter with coordinates
      regex = RegExp(r'[?&]query=(-?\d+\.?\d*),(-?\d+\.?\d*)');
      match = regex.firstMatch(url);
      if (match != null) {
        final lat = double.parse(match.group(1)!);
        final lng = double.parse(match.group(2)!);
        if (isValidCoordinates(lat, lng)) {
          return {'latitude': lat, 'longitude': lng};
        }
      }

      // Pattern 7: q parameter with coordinates
      regex = RegExp(r'[?&]q=(-?\d+\.?\d*),(-?\d+\.?\d*)');
      match = regex.firstMatch(url);
      if (match != null) {
        final lat = double.parse(match.group(1)!);
        final lng = double.parse(match.group(2)!);
        if (isValidCoordinates(lat, lng)) {
          return {'latitude': lat, 'longitude': lng};
        }
      }

      return null;
    } catch (e) {
      throw CoordinateExtractionException('Failed to extract coordinates: $e');
    }
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
    try {
      // Validate URL first
      if (!isValidGoogleMapsUrl(url) && !_isValidShortUrl(url)) {
        throw const InvalidUrlException('Invalid Google Maps URL format');
      }

      if (url.contains('goo.gl') || url.contains('maps.app.goo.gl')) {
        final expandedUrl = await expandShortUrl(url);
        if (expandedUrl != null) {
          url = expandedUrl;
        } else {
          throw const UrlExpansionException('Failed to expand short URL');
        }
      }

      return extractCoordinates(url);
    } on InvalidUrlException {
      rethrow;
    } on UrlExpansionException {
      rethrow;
    } on CoordinateExtractionException {
      rethrow;
    } catch (e) {
      throw CoordinateExtractionException(
          'Failed to process Google Maps URL: $e');
    }
  }

  /// Extracts zoom level from a Google Maps URL.
  ///
  /// This method parses the given URL and attempts to extract the zoom level
  /// information embedded within it.
  ///
  /// Returns the zoom level as an integer if found, null otherwise.
  ///
  /// Example usage:
  /// ```dart
  /// final url = 'https://www.google.com/maps/@37.7749,-122.4194,15z';
  /// final zoom = GoogleMapsUrlExtractor.extractZoomLevel(url);
  /// if (zoom != null) {
  ///   print('Zoom level: $zoom');
  /// }
  /// ```
  static int? extractZoomLevel(String url) {
    // Pattern 1: @lat,lng,zoom format
    var regex = RegExp(r'@-?\d+\.?\d*,-?\d+\.?\d*,(\d+)z?');
    var match = regex.firstMatch(url);
    if (match != null) {
      return int.parse(match.group(1)!);
    }

    // Pattern 2: zoom parameter in query string
    regex = RegExp(r'[?&]z=(\d+)');
    match = regex.firstMatch(url);
    if (match != null) {
      return int.parse(match.group(1)!);
    }

    return null;
  }

  /// Extracts place name from a Google Maps URL.
  ///
  /// This method parses the given URL and attempts to extract the place name
  /// information embedded within it.
  ///
  /// Returns the place name as a string if found, null otherwise.
  ///
  /// Example usage:
  /// ```dart
  /// final url = 'https://www.google.com/maps/place/Eiffel+Tower/@48.8583701,2.2922926,17z';
  /// final placeName = GoogleMapsUrlExtractor.extractPlaceName(url);
  /// if (placeName != null) {
  ///   print('Place name: $placeName');
  /// }
  /// ```
  static String? extractPlaceName(String url) {
    // Pattern 1: /place/PlaceName/@ format
    var regex = RegExp(r'/place/([^/@]+)/@');
    var match = regex.firstMatch(url);
    if (match != null) {
      return Uri.decodeComponent(match.group(1)!.replaceAll('+', ' '));
    }

    // Pattern 2: /search/PlaceName format
    regex = RegExp(r'/search/([^/?]+)');
    match = regex.firstMatch(url);
    if (match != null) {
      return Uri.decodeComponent(match.group(1)!.replaceAll('+', ' '));
    }

    return null;
  }

  /// Extracts comprehensive location information from a Google Maps URL.
  ///
  /// This method combines multiple extraction methods to provide a complete
  /// set of location information from the URL.
  ///
  /// Returns a [Map] containing all available location information:
  /// - 'latitude': double
  /// - 'longitude': double
  /// - 'zoom': int (if available)
  /// - 'placeName': String (if available)
  /// - 'urlType': String (describes the type of URL)
  ///
  /// Example usage:
  /// ```dart
  /// final url = 'https://www.google.com/maps/place/Eiffel+Tower/@48.8583701,2.2922926,17z';
  /// final info = GoogleMapsUrlExtractor.extractLocationInfo(url);
  /// if (info != null) {
  ///   print('Latitude: ${info['latitude']}');
  ///   print('Longitude: ${info['longitude']}');
  ///   print('Zoom: ${info['zoom']}');
  ///   print('Place: ${info['placeName']}');
  ///   print('Type: ${info['urlType']}');
  /// }
  /// ```
  static Map<String, dynamic>? extractLocationInfo(String url) {
    final coordinates = extractCoordinates(url);
    if (coordinates == null) return null;

    final zoom = extractZoomLevel(url);
    final placeName = extractPlaceName(url);

    // Determine URL type
    String urlType = 'unknown';
    if (url.contains('/place/')) {
      urlType = 'place';
    } else if (url.contains('/search/')) {
      urlType = 'search';
    } else if (url.contains('/dir/')) {
      urlType = 'directions';
    } else if (url.contains('@')) {
      urlType = 'map';
    }

    final result = <String, dynamic>{
      'latitude': coordinates['latitude'],
      'longitude': coordinates['longitude'],
      'urlType': urlType,
    };

    if (zoom != null) result['zoom'] = zoom;
    if (placeName != null) result['placeName'] = placeName;

    return result;
  }

  /// Processes multiple Google Maps URLs in batch.
  ///
  /// This method processes a list of URLs and returns a list of results.
  /// Each result contains the location information for the corresponding URL,
  /// or null if the URL could not be processed.
  ///
  /// Example usage:
  /// ```dart
  /// final urls = [
  ///   'https://maps.app.goo.gl/mWtb4a1cUE9zMWya7',
  ///   'https://www.google.com/maps/@37.7749,-122.4194,15z',
  /// ];
  /// final results = await GoogleMapsUrlExtractor.processBatch(urls);
  /// for (int i = 0; i < results.length; i++) {
  ///   if (results[i] != null) {
  ///     print('URL ${i + 1}: ${results[i]}');
  ///   }
  /// }
  /// ```
  static Future<List<Map<String, dynamic>?>> processBatch(
      List<String> urls) async {
    final results = <Map<String, dynamic>?>[];

    for (final url in urls) {
      try {
        final expandedUrl = await processGoogleMapsUrl(url);
        if (expandedUrl != null) {
          // Re-extract full info from the expanded URL
          final fullUrl =
              url.contains('goo.gl') || url.contains('maps.app.goo.gl')
                  ? await expandShortUrl(url) ?? url
                  : url;
          results.add(extractLocationInfo(fullUrl));
        } else {
          results.add(null);
        }
      } catch (e) {
        results.add(null);
      }
    }

    return results;
  }

  /// Validates if a URL is a valid Google Maps URL.
  ///
  /// This method checks if the provided URL is a valid Google Maps URL
  /// by checking for common Google Maps domain patterns.
  ///
  /// Returns true if the URL appears to be a Google Maps URL, false otherwise.
  ///
  /// Example usage:
  /// ```dart
  /// final url = 'https://www.google.com/maps/@37.7749,-122.4194,15z';
  /// final isValid = GoogleMapsUrlExtractor.isValidGoogleMapsUrl(url);
  /// print('Is valid: $isValid');
  /// ```
  static bool isValidGoogleMapsUrl(String url) {
    final googleMapsPatterns = [
      'google.com/maps',
      'maps.google.com',
      'goo.gl/maps',
      'maps.app.goo.gl',
    ];

    return googleMapsPatterns.any((pattern) => url.contains(pattern));
  }

  /// Validates if coordinates are within valid ranges.
  ///
  /// This method checks if the provided latitude and longitude values
  /// are within valid geographic coordinate ranges.
  ///
  /// Returns true if coordinates are valid, false otherwise.
  ///
  /// Example usage:
  /// ```dart
  /// final isValid = GoogleMapsUrlExtractor.isValidCoordinates(37.7749, -122.4194);
  /// print('Coordinates valid: $isValid');
  /// ```
  static bool isValidCoordinates(double latitude, double longitude) {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  /// Clears the internal cache.
  ///
  /// This method removes all cached entries from the internal cache.
  /// Useful for freeing memory or forcing fresh data retrieval.
  ///
  /// Example usage:
  /// ```dart
  /// GoogleMapsUrlExtractor.clearCache();
  /// ```
  static void clearCache() {
    _cache.clear();
  }

  /// Gets the current cache size.
  ///
  /// Returns the number of entries currently stored in the cache.
  ///
  /// Example usage:
  /// ```dart
  /// final cacheSize = GoogleMapsUrlExtractor.getCacheSize();
  /// print('Cache contains $cacheSize entries');
  /// ```
  static int getCacheSize() {
    return _cache.size;
  }
}
