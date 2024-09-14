import 'package:http/http.dart' as http;

class GoogleMapsUrlExtractor {
  /// Expands a shortened Google Maps URL to its full form.
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

  /// Extracts latitude and longitude from a Google Maps URL.
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

  /// Processes a Google Maps URL, expanding it if necessary, and extracts coordinates.
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
