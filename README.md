# Google Maps URL Extractor

A Dart package for extracting coordinates from Google Maps URLs and expanding shortened URLs.

## Features

- Expand shortened Google Maps URLs (e.g., goo.gl links)
- Extract latitude and longitude coordinates from Google Maps URLs
- Support for various Google Maps URL formats
- Asynchronous processing of URLs

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  google_maps_url_extractor: ^0.0.1
```

or run

`flutter pub add google_maps_url_extractor`

## Usage

1. Import the package in your Dart/Flutter code

```dart
import 'package:google_maps_url_extractor/google_maps_url_extractor.dart';

void main() async {
  final url = 'https://maps.app.goo.gl/mWtb4a1cUE9zMWya7';
  final coordinates = await GoogleMapsUrlExtractor.processGoogleMapsUrl(url);
}
```

2. Use the `expandShortUrl` method to expand the shortened URL

```dart
final expandedUrl = await GoogleMapsUrlExtractor.expandShortUrl(url);
```

3. Use the `extractCoordinates` method to get the coordinates from the URL

```dart
final url = 'https://www.google.com/maps/@37.7749,-122.4194,15z';
final coordinates = GoogleMapsUrlExtractor.extractCoordinates(url);
if (coordinates != null) {
print('Latitude: ${coordinates['latitude']}');
print('Longitude: ${coordinates['longitude']}');
}
```

4. Use the `processGoogleMapsUrl` method to get the coordinates from the URL

```dart
final url = 'https://maps.app.goo.gl/mWtb4a1cUE9zMWya7';
final coordinates = await GoogleMapsUrlExtractor.processGoogleMapsUrl(url);
if (coordinates != null) {
print('Latitude: ${coordinates['latitude']}');
print('Longitude: ${coordinates['longitude']}');
}
```



## Supported URL Formats

This package supports various Google Maps URL formats, including:

- Short URLs (e.g., `https://goo.gl/maps/abcdefg`)
- Standard map URLs (e.g., `https://www.google.com/maps/@37.7749,-122.4194,15z`)
- Place URLs (e.g., `https://www.google.com/maps/place/Eiffel+Tower/@48.8583701,2.2922926,17z`)
- Search URLs (e.g., `https://www.google.com/maps/search/?api=1&query=48.8583701,2.2922926`)
- Direction URLs (e.g., `https://www.google.com/maps/dir/?api=1&destination=48.8583701,2.2922926`)

## Error Handling

All methods return `null` if the input URL is invalid or if coordinates cannot be extracted.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.
