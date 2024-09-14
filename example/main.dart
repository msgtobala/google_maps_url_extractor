import 'package:google_maps_url_extractor/google_maps_url_extractor.dart';

void main() async {
  // Example of expanding a short URL
  const shortUrl = 'https://maps.app.goo.gl/mWtb4a1cUE9zMWya7';
  final expandedUrl = await GoogleMapsUrlExtractor.expandShortUrl(shortUrl);
  print('Expanded URL: $expandedUrl');

  // Example of extracting coordinates from a full URL
  const fullUrl =
      'https://www.google.com/maps/place/Moonraft+Innovation+Labs/@12.9140057,77.6281936,17z/data=!3m1!4b1!4m6!3m5!1s0x3bae148db555a135:0xdf658e2653660ee6!8m2!3d12.9140057!4d77.6281936!16s%2Fg%2F1tg66jp9?entry=ttu&g_ep=EgoyMDI0MDkxMS4wIKXMDSoASAFQAw%3D%3D';
  final coordinates = GoogleMapsUrlExtractor.extractCoordinates(fullUrl);
  if (coordinates != null) {
    print('Latitude: ${coordinates['latitude']}');
    print('Longitude: ${coordinates['longitude']}');
  } else {
    print('Failed to extract coordinates');
  }

  // Example of processing a Google Maps URL
  final processedCoordinates =
      await GoogleMapsUrlExtractor.processGoogleMapsUrl(shortUrl);
  if (processedCoordinates != null) {
    print('Processed Latitude: ${processedCoordinates['latitude']}');
    print('Processed Longitude: ${processedCoordinates['longitude']}');
  } else {
    print('Failed to process URL');
  }
}
