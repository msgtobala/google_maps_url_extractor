# Google Maps URL Extractor

A comprehensive Dart package for extracting location information from Google Maps URLs, including short URL expansion, coordinate extraction, place information, and more.

## Features

### Core Functionality
- **Expand shortened Google Maps URLs** (e.g., goo.gl, maps.app.goo.gl links)
- **Extract coordinates** from various Google Maps URL formats
- **Extract zoom levels** from URLs
- **Extract place names** from place URLs
- **Comprehensive location info** extraction with metadata

### Advanced Features
- **Batch processing** for multiple URLs
- **Intelligent caching** with LRU eviction policy
- **Robust error handling** with custom exceptions
- **URL and coordinate validation**
- **Support for 6+ different URL formats**
- **Asynchronous processing** with proper error handling

### Performance & Reliability
- **Memory-efficient caching** to avoid redundant network requests
- **Comprehensive input validation** to prevent errors
- **Detailed error messages** for better debugging
- **Extensive test coverage** for reliability

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  google_maps_url_extractor: ^2.0.0
```

or run

```bash
flutter pub add google_maps_url_extractor
```

## Quick Start

```dart
import 'package:google_maps_url_extractor/google_maps_url_extractor.dart';

void main() async {
  // Basic coordinate extraction
  const url = 'https://www.google.com/maps/@37.7749,-122.4194,15z';
  final coordinates = GoogleMapsUrlExtractor.extractCoordinates(url);
  print('Coordinates: $coordinates');
  
  // Comprehensive location info
  final info = GoogleMapsUrlExtractor.extractLocationInfo(url);
  print('Full info: $info');
}
```

## API Reference

### Core Methods

#### `extractCoordinates(String url)`
Extracts latitude and longitude from a Google Maps URL.

```dart
final coordinates = GoogleMapsUrlExtractor.extractCoordinates(url);
if (coordinates != null) {
  print('Lat: ${coordinates['latitude']}, Lng: ${coordinates['longitude']}');
}
```

#### `extractZoomLevel(String url)`
Extracts zoom level from a Google Maps URL.

```dart
final zoom = GoogleMapsUrlExtractor.extractZoomLevel(url);
print('Zoom level: ${zoom ?? 'Not found'}');
```

#### `extractPlaceName(String url)`
Extracts place name from a Google Maps URL.

```dart
final placeName = GoogleMapsUrlExtractor.extractPlaceName(url);
print('Place: ${placeName ?? 'Not found'}');
```

#### `extractLocationInfo(String url)`
Extracts comprehensive location information.

```dart
final info = GoogleMapsUrlExtractor.extractLocationInfo(url);
if (info != null) {
  print('Latitude: ${info['latitude']}');
  print('Longitude: ${info['longitude']}');
  print('Zoom: ${info['zoom']}');
  print('Place: ${info['placeName']}');
  print('Type: ${info['urlType']}');
}
```

### URL Processing

#### `expandShortUrl(String shortUrl)`
Expands shortened Google Maps URLs with caching.

```dart
try {
  final expandedUrl = await GoogleMapsUrlExtractor.expandShortUrl(shortUrl);
  print('Expanded: $expandedUrl');
} catch (e) {
  print('Error: $e');
}
```

#### `processGoogleMapsUrl(String url)`
Processes any Google Maps URL (expands if needed, then extracts coordinates).

```dart
try {
  final coordinates = await GoogleMapsUrlExtractor.processGoogleMapsUrl(url);
  print('Coordinates: $coordinates');
} catch (e) {
  print('Error: $e');
}
```

### Batch Processing

#### `processBatch(List<String> urls)`
Processes multiple URLs in batch.

```dart
final urls = [
  'https://www.google.com/maps/@37.7749,-122.4194,15z',
  'https://maps.app.goo.gl/abc123',
];
final results = await GoogleMapsUrlExtractor.processBatch(urls);
for (int i = 0; i < results.length; i++) {
  if (results[i] != null) {
    print('URL ${i + 1}: ${results[i]}');
  }
}
```

### Validation

#### `isValidGoogleMapsUrl(String url)`
Validates if a URL is a Google Maps URL.

```dart
final isValid = GoogleMapsUrlExtractor.isValidGoogleMapsUrl(url);
print('Valid: $isValid');
```

#### `isValidCoordinates(double lat, double lng)`
Validates coordinate ranges.

```dart
final isValid = GoogleMapsUrlExtractor.isValidCoordinates(37.7749, -122.4194);
print('Valid coordinates: $isValid');
```

### Cache Management

#### `clearCache()`
Clears the internal cache.

```dart
GoogleMapsUrlExtractor.clearCache();
```

#### `getCacheSize()`
Gets current cache size.

```dart
final size = GoogleMapsUrlExtractor.getCacheSize();
print('Cache size: $size');
```



## Supported URL Formats

This package supports 6+ different Google Maps URL formats:

- **Short URLs**: `https://goo.gl/maps/abcdefg`, `https://maps.app.goo.gl/abc123`
- **Standard map URLs**: `https://www.google.com/maps/@37.7749,-122.4194,15z`
- **Place URLs**: `https://www.google.com/maps/place/Eiffel+Tower/@48.8583701,2.2922926,17z`
- **Search URLs**: `https://www.google.com/maps/search/?api=1&query=48.8583701,2.2922926`
- **Direction URLs**: `https://www.google.com/maps/dir/?api=1&destination=48.8583701,2.2922926`
- **Query parameter URLs**: `https://www.google.com/maps/?ll=37.7749,-122.4194&z=15`

## Error Handling

The package provides comprehensive error handling with custom exceptions:

```dart
try {
  final coordinates = await GoogleMapsUrlExtractor.processGoogleMapsUrl(url);
} on InvalidUrlException catch (e) {
  print('Invalid URL: ${e.message}');
} on UrlExpansionException catch (e) {
  print('URL expansion failed: ${e.message}');
} on CoordinateExtractionException catch (e) {
  print('Coordinate extraction failed: ${e.message}');
} catch (e) {
  print('Unexpected error: $e');
}
```

### Exception Types

- `InvalidUrlException`: Invalid URL format
- `UrlExpansionException`: Short URL expansion failed
- `CoordinateExtractionException`: Coordinate extraction failed
- `InvalidCoordinateException`: Invalid coordinate values
- `NetworkException`: Network-related errors

## Performance Features

### Caching
- **Automatic caching** of expanded URLs
- **LRU eviction policy** to manage memory usage
- **Configurable cache size** (default: 100 entries)
- **Cache management** methods for manual control

### Batch Processing
- **Efficient batch processing** for multiple URLs
- **Error isolation** - one failed URL doesn't affect others
- **Memory efficient** processing

## Migration from v1.x

If you're upgrading from v1.x, here are the key changes:

### Breaking Changes
- Methods now throw exceptions instead of returning null for invalid inputs
- `extractCoordinates` now validates coordinates before returning them

### New Features
- Comprehensive location info extraction
- Zoom level and place name extraction
- Batch processing capabilities
- Caching system
- Enhanced error handling

### Migration Example

```dart
// Old v1.x code
final coordinates = await GoogleMapsUrlExtractor.processGoogleMapsUrl(url);
if (coordinates != null) {
  print('Lat: ${coordinates['latitude']}');
}

// New v2.0 code
try {
  final coordinates = await GoogleMapsUrlExtractor.processGoogleMapsUrl(url);
  print('Lat: ${coordinates['latitude']}');
} catch (e) {
  print('Error: $e');
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.
