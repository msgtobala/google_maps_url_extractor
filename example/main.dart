import 'package:google_maps_url_extractor/google_maps_url_extractor.dart';

void main() async {
  print('=== Google Maps URL Extractor v2.0.0 Demo ===\n');

  // Example URLs for demonstration
  const shortUrl = 'https://maps.app.goo.gl/mWtb4a1cUE9zMWya7';
  const placeUrl =
      'https://www.google.com/maps/place/Eiffel+Tower/@48.8583701,2.2922926,17z';
  const mapUrl = 'https://www.google.com/maps/@37.7749,-122.4194,15z';
  const searchUrl =
      'https://www.google.com/maps/search/?api=1&query=48.8583701,2.2922926';

  // 1. Basic coordinate extraction
  print('1. Basic Coordinate Extraction:');
  print('   URL: $mapUrl');
  final coordinates = GoogleMapsUrlExtractor.extractCoordinates(mapUrl);
  if (coordinates != null) {
    print('   Latitude: ${coordinates['latitude']}');
    print('   Longitude: ${coordinates['longitude']}');
  }
  print('');

  // 2. Zoom level extraction
  print('2. Zoom Level Extraction:');
  print('   URL: $mapUrl');
  final zoom = GoogleMapsUrlExtractor.extractZoomLevel(mapUrl);
  print('   Zoom Level: ${zoom ?? 'Not found'}');
  print('');

  // 3. Place name extraction
  print('3. Place Name Extraction:');
  print('   URL: $placeUrl');
  final placeName = GoogleMapsUrlExtractor.extractPlaceName(placeUrl);
  print('   Place Name: ${placeName ?? 'Not found'}');
  print('');

  // 4. Comprehensive location info
  print('4. Comprehensive Location Information:');
  print('   URL: $placeUrl');
  final locationInfo = GoogleMapsUrlExtractor.extractLocationInfo(placeUrl);
  if (locationInfo != null) {
    print('   Latitude: ${locationInfo['latitude']}');
    print('   Longitude: ${locationInfo['longitude']}');
    print('   Zoom: ${locationInfo['zoom'] ?? 'Not available'}');
    print('   Place Name: ${locationInfo['placeName'] ?? 'Not available'}');
    print('   URL Type: ${locationInfo['urlType']}');
  }
  print('');

  // 5. URL validation
  print('5. URL Validation:');
  final testUrls = [
    mapUrl,
    'https://www.example.com',
    'https://maps.yahoo.com',
  ];
  for (final url in testUrls) {
    final isValid = GoogleMapsUrlExtractor.isValidGoogleMapsUrl(url);
    print('   $url: ${isValid ? 'Valid' : 'Invalid'}');
  }
  print('');

  // 6. Coordinate validation
  print('6. Coordinate Validation:');
  final testCoords = [
    [37.7749, -122.4194],
    [91.0, 0.0],
    [0.0, 181.0],
  ];
  for (final coord in testCoords) {
    final isValid =
        GoogleMapsUrlExtractor.isValidCoordinates(coord[0], coord[1]);
    print('   (${coord[0]}, ${coord[1]}): ${isValid ? 'Valid' : 'Invalid'}');
  }
  print('');

  // 7. Batch processing
  print('7. Batch Processing:');
  final urls = [mapUrl, placeUrl, searchUrl];
  print('   Processing ${urls.length} URLs...');
  final batchResults = await GoogleMapsUrlExtractor.processBatch(urls);
  for (int i = 0; i < batchResults.length; i++) {
    final result = batchResults[i];
    if (result != null) {
      print(
          '   URL ${i + 1}: Lat=${result['latitude']}, Lng=${result['longitude']}');
    } else {
      print('   URL ${i + 1}: Failed to process');
    }
  }
  print('');

  // 8. Cache management
  print('8. Cache Management:');
  print('   Cache size: ${GoogleMapsUrlExtractor.getCacheSize()}');
  GoogleMapsUrlExtractor.clearCache();
  print('   Cache cleared. New size: ${GoogleMapsUrlExtractor.getCacheSize()}');
  print('');

  // 9. Error handling example
  print('9. Error Handling:');
  try {
    await GoogleMapsUrlExtractor.processGoogleMapsUrl(
        'https://www.example.com');
  } catch (e) {
    print('   Caught exception: $e');
  }
  print('');

  // 10. Short URL expansion with caching
  print('10. Short URL Expansion (with caching):');
  print('   Original URL: $shortUrl');
  try {
    final expandedUrl = await GoogleMapsUrlExtractor.expandShortUrl(shortUrl);
    print('   Expanded URL: ${expandedUrl ?? 'Failed to expand'}');

    // Second call should use cache
    final cachedUrl = await GoogleMapsUrlExtractor.expandShortUrl(shortUrl);
    print('   Cached URL: ${cachedUrl ?? 'Not cached'}');
  } catch (e) {
    print('   Error: $e');
  }

  print('\n=== Demo Complete ===');
}
