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
  const UrlExpansionException(String message, [String? details])
      : super(message, details);
}

/// Exception thrown when coordinate extraction fails.
class CoordinateExtractionException extends GoogleMapsUrlExtractorException {
  const CoordinateExtractionException(String message, [String? details])
      : super(message, details);
}

/// Exception thrown when URL validation fails.
class InvalidUrlException extends GoogleMapsUrlExtractorException {
  const InvalidUrlException(String message, [String? details])
      : super(message, details);
}

/// Exception thrown when coordinate validation fails.
class InvalidCoordinateException extends GoogleMapsUrlExtractorException {
  const InvalidCoordinateException(String message, [String? details])
      : super(message, details);
}

/// Exception thrown when network operations fail.
class NetworkException extends GoogleMapsUrlExtractorException {
  const NetworkException(String message, [String? details])
      : super(message, details);
}
