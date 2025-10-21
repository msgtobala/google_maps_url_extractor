import 'package:test/test.dart';
import 'package:google_maps_url_extractor/google_maps_url_extractor.dart';

void main() {
  group('GoogleMapsUrlExtractor', () {
    test('expandShortUrl expands a short URL', () async {
      const shortUrl = 'https://maps.app.goo.gl/mWtb4a1cUE9zMWya7';
      final expandedUrl = await GoogleMapsUrlExtractor.expandShortUrl(shortUrl);
      expect(expandedUrl, isNotNull);
      expect(expandedUrl, contains('google.com/maps'));
    });

    test('extractCoordinates returns correct coordinates', () {
      const url =
          'https://www.google.com/maps/place/Moonraft+Innovation+Labs/@12.9140057,77.6281936,17z/data=!3m1!4b1!4m6!3m5!1s0x3bae148db555a135:0xdf658e2653660ee6!8m2!3d12.9140057!4d77.6281936!16s%2Fg%2F1tg66jp9?entry=ttu&g_ep=EgoyMDI0MDkxMS4wIKXMDSoASAFQAw%3D%3D';
      final coordinates = GoogleMapsUrlExtractor.extractCoordinates(url);
      expect(coordinates!['latitude'], closeTo(12.9140057, 0.0001));
      expect(coordinates['longitude'], closeTo(77.6281936, 0.0001));
    });

    test('extractCoordinates returns null for invalid URL', () {
      const url = 'https://www.example.com';
      final coordinates = GoogleMapsUrlExtractor.extractCoordinates(url);
      expect(coordinates, isNull);
    });

    test('processGoogleMapsUrl handles short URL', () async {
      const shortUrl = 'https://maps.app.goo.gl/mWtb4a1cUE9zMWya7';
      final coordinates =
          await GoogleMapsUrlExtractor.processGoogleMapsUrl(shortUrl);
      expect(coordinates, isNotNull);
      expect(coordinates!['latitude'], isNotNull);
      expect(coordinates['longitude'], isNotNull);
    });

    test('processGoogleMapsUrl handles full URL', () async {
      const fullUrl =
          'https://www.google.com/maps/place/Moonraft+Innovation+Labs/@12.9140057,77.6281936,17z/data=!3m1!4b1!4m6!3m5!1s0x3bae148db555a135:0xdf658e2653660ee6!8m2!3d12.9140057!4d77.6281936!16s%2Fg%2F1tg66jp9?entry=ttu&g_ep=EgoyMDI0MDkxMS4wIKXMDSoASAFQAw%3D%3D';
      final coordinates =
          await GoogleMapsUrlExtractor.processGoogleMapsUrl(fullUrl);
      expect(coordinates, isNotNull);
      expect(coordinates!['latitude'], closeTo(12.9140057, 0.0001));
      expect(coordinates['longitude'], closeTo(77.6281936, 0.0001));
    });

    test('processGoogleMapsUrl throws exception for invalid URL', () async {
      const invalidUrl = 'https://www.example.com';
      expect(() => GoogleMapsUrlExtractor.processGoogleMapsUrl(invalidUrl),
          throwsA(isA<InvalidUrlException>()));
    });

    test('extractZoomLevel returns correct zoom level', () {
      const url = 'https://www.google.com/maps/@37.7749,-122.4194,15z';
      final zoom = GoogleMapsUrlExtractor.extractZoomLevel(url);
      expect(zoom, equals(15));
    });

    test('extractZoomLevel returns null when no zoom found', () {
      const url =
          'https://www.google.com/maps/place/Eiffel+Tower/@48.8583701,2.2922926';
      final zoom = GoogleMapsUrlExtractor.extractZoomLevel(url);
      expect(zoom, isNull);
    });

    test('extractPlaceName returns correct place name', () {
      const url =
          'https://www.google.com/maps/place/Eiffel+Tower/@48.8583701,2.2922926,17z';
      final placeName = GoogleMapsUrlExtractor.extractPlaceName(url);
      expect(placeName, equals('Eiffel Tower'));
    });

    test('extractPlaceName returns null when no place name found', () {
      const url = 'https://www.google.com/maps/@37.7749,-122.4194,15z';
      final placeName = GoogleMapsUrlExtractor.extractPlaceName(url);
      expect(placeName, isNull);
    });

    test('extractLocationInfo returns comprehensive location data', () {
      const url =
          'https://www.google.com/maps/place/Eiffel+Tower/@48.8583701,2.2922926,17z';
      final info = GoogleMapsUrlExtractor.extractLocationInfo(url);

      expect(info, isNotNull);
      expect(info!['latitude'], closeTo(48.8583701, 0.0001));
      expect(info['longitude'], closeTo(2.2922926, 0.0001));
      expect(info['zoom'], equals(17));
      expect(info['placeName'], equals('Eiffel Tower'));
      expect(info['urlType'], equals('place'));
    });

    test('isValidGoogleMapsUrl returns true for valid URLs', () {
      const validUrls = [
        'https://www.google.com/maps/@37.7749,-122.4194,15z',
        'https://maps.google.com/maps/@37.7749,-122.4194,15z',
        'https://goo.gl/maps/abcdefg',
        'https://maps.app.goo.gl/abcdefg',
      ];

      for (final url in validUrls) {
        expect(GoogleMapsUrlExtractor.isValidGoogleMapsUrl(url), isTrue);
      }
    });

    test('isValidGoogleMapsUrl returns false for invalid URLs', () {
      const invalidUrls = [
        'https://www.example.com',
        'https://maps.yahoo.com',
        'https://www.bing.com/maps',
      ];

      for (final url in invalidUrls) {
        expect(GoogleMapsUrlExtractor.isValidGoogleMapsUrl(url), isFalse);
      }
    });

    test('isValidCoordinates returns true for valid coordinates', () {
      expect(GoogleMapsUrlExtractor.isValidCoordinates(37.7749, -122.4194),
          isTrue);
      expect(GoogleMapsUrlExtractor.isValidCoordinates(0, 0), isTrue);
      expect(GoogleMapsUrlExtractor.isValidCoordinates(90, 180), isTrue);
      expect(GoogleMapsUrlExtractor.isValidCoordinates(-90, -180), isTrue);
    });

    test('isValidCoordinates returns false for invalid coordinates', () {
      expect(GoogleMapsUrlExtractor.isValidCoordinates(91, 0), isFalse);
      expect(GoogleMapsUrlExtractor.isValidCoordinates(-91, 0), isFalse);
      expect(GoogleMapsUrlExtractor.isValidCoordinates(0, 181), isFalse);
      expect(GoogleMapsUrlExtractor.isValidCoordinates(0, -181), isFalse);
    });

    test('processBatch processes multiple URLs', () async {
      const urls = [
        'https://www.google.com/maps/@37.7749,-122.4194,15z',
        'https://www.google.com/maps/place/Eiffel+Tower/@48.8583701,2.2922926,17z',
      ];

      final results = await GoogleMapsUrlExtractor.processBatch(urls);

      expect(results, hasLength(2));
      expect(results[0], isNotNull);
      expect(results[1], isNotNull);
      expect(results[0]!['latitude'], closeTo(37.7749, 0.0001));
      expect(results[1]!['latitude'], closeTo(48.8583701, 0.0001));
    });

    test('cache management works correctly', () {
      // Clear cache first
      GoogleMapsUrlExtractor.clearCache();
      expect(GoogleMapsUrlExtractor.getCacheSize(), equals(0));
    });
  });

  group('Error Handling', () {
    test('extractCoordinates returns null for invalid input', () {
      final result = GoogleMapsUrlExtractor.extractCoordinates('invalid-url');
      expect(result, isNull);
    });

    test('extractCoordinates returns null for malformed coordinates', () {
      // This should return null for malformed coordinates
      final result = GoogleMapsUrlExtractor.extractCoordinates(
          'https://maps.google.com/@invalid,invalid');
      expect(result, isNull);
    });

    test(
        'processGoogleMapsUrl throws InvalidUrlException for non-Google Maps URL',
        () async {
      expect(
          () => GoogleMapsUrlExtractor.processGoogleMapsUrl(
              'https://www.example.com'),
          throwsA(isA<InvalidUrlException>()));
    });
  });
}
