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

## [1.0.2] - 2024-09-14

### Added

- Added example to the package to showcase the usage of the package.

### Changed

- N/A

### Deprecated

- N/A

### Removed

- N/A

### Fixed

- N/A

## [2.0.0] - 2024-12-19

### Added

- **Enhanced coordinate extraction** with support for 6+ URL formats
- **Zoom level extraction** from Google Maps URLs
- **Place name extraction** from place URLs
- **Comprehensive location info extraction** with metadata
- **Batch processing** for multiple URLs
- **Intelligent caching system** with LRU eviction policy
- **Custom exception classes** for better error handling
- **URL and coordinate validation** utilities
- **Cache management** methods (clear, get size)
- **Enhanced error handling** with detailed error messages
- **Comprehensive test coverage** for all new features
- **Updated documentation** with complete API reference
- **Migration guide** for v1.x users

### Changed

- **BREAKING**: Methods now throw exceptions instead of returning null for invalid inputs
- **BREAKING**: `extractCoordinates` now validates coordinates before returning them
- **Enhanced**: `expandShortUrl` now includes caching and better error handling
- **Enhanced**: `processGoogleMapsUrl` now includes comprehensive validation
- **Updated**: All method documentation with detailed examples
- **Updated**: Example app with comprehensive feature demonstration

### Deprecated

- N/A

### Removed

- N/A

### Fixed

- Fixed coordinate extraction patterns to handle more URL formats
- Fixed error handling to provide more specific error messages
- Fixed memory leaks in URL expansion by implementing proper caching

### Security

- Enhanced input validation to prevent potential security issues
- Improved error handling to avoid information leakage
