# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-09-14

### Added
- Initial release of the Google Maps URL Extractor package.
- `GoogleMapsUrlExtractor` class with the following methods:
  - `expandShortUrl`: Expands shortened Google Maps URLs.
  - `extractCoordinates`: Extracts latitude and longitude from Google Maps URLs.
  - `processGoogleMapsUrl`: Processes a Google Maps URL (expands if short, then extracts coordinates).
- Support for various Google Maps URL formats:
  - Short URLs (goo.gl)
  - Standard map URLs
  - Place URLs
  - Search URLs
  - Direction URLs
- Comprehensive test suite for all main functionalities.
- Detailed README with usage examples and documentation.

### Changed
- N/A

### Deprecated
- N/A

### Removed
- N/A

### Fixed
- N/A

### Security
- N/A