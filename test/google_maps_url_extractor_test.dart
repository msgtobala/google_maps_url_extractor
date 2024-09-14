import 'package:test/test.dart';
import 'package:google_maps_url_extractor/url_extractor.dart';

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

    test('processGoogleMapsUrl returns null for invalid URL', () async {
      const invalidUrl = 'https://www.example.com';
      final coordinates =
          await GoogleMapsUrlExtractor.processGoogleMapsUrl(invalidUrl);
      expect(coordinates, isNull);
    });
  });
}
