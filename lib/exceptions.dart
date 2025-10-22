/// Base exception class for Google Maps URL Extractor errors.
abstract class GoogleMapsUrlExtractorException implements Exception {
  final String message;
  final String? details;

  const GoogleMapsUrlExtractorException(this.message, [this.details]);

  @override
  String toString() => details != null ? '$message: $details' : message;
}

/// Exception thrown when URL expansion fails.
class UrlExpansionException extends GoogleMapsUrlExtractorException {
  const UrlExpansionException(super.message, [super.details]);
}

/// Exception thrown when coordinate extraction fails.
class CoordinateExtractionException extends GoogleMapsUrlExtractorException {
  const CoordinateExtractionException(super.message, [super.details]);
}

/// Exception thrown when URL validation fails.
class InvalidUrlException extends GoogleMapsUrlExtractorException {
  const InvalidUrlException(super.message, [super.details]);
}

/// Exception thrown when coordinate validation fails.
class InvalidCoordinateException extends GoogleMapsUrlExtractorException {
  const InvalidCoordinateException(super.message, [super.details]);
}

/// Exception thrown when network operations fail.
class NetworkException extends GoogleMapsUrlExtractorException {
  const NetworkException(super.message, [super.details]);
}
