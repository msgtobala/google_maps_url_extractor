/// A simple in-memory cache manager for storing expanded URLs and location data.
///
/// This class provides basic caching functionality to avoid redundant network
/// requests for the same URLs. The cache has a maximum size limit and uses
/// a simple LRU (Least Recently Used) eviction policy.
class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  final Map<String, _CacheEntry> _cache = {};
  final int _maxSize = 100; // Maximum number of entries

  /// Stores a value in the cache with an optional expiration time.
  ///
  /// [key] - The cache key
  /// [value] - The value to store
  /// [expirationMinutes] - Optional expiration time in minutes (default: 60)
  void put(String key, dynamic value, {int expirationMinutes = 60}) {
    // Remove oldest entries if cache is full
    if (_cache.length >= _maxSize) {
      _evictOldest();
    }

    final expirationTime =
        DateTime.now().add(Duration(minutes: expirationMinutes));
    _cache[key] = _CacheEntry(value, expirationTime);
  }

  /// Retrieves a value from the cache.
  ///
  /// Returns the cached value if found and not expired, null otherwise.
  dynamic get(String key) {
    final entry = _cache[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }

    // Update access time for LRU
    entry.updateAccessTime();
    return entry.value;
  }

  /// Checks if a key exists in the cache and is not expired.
  bool containsKey(String key) {
    final entry = _cache[key];
    if (entry == null) return false;

    if (entry.isExpired) {
      _cache.remove(key);
      return false;
    }

    return true;
  }

  /// Removes a specific key from the cache.
  void remove(String key) {
    _cache.remove(key);
  }

  /// Clears all entries from the cache.
  void clear() {
    _cache.clear();
  }

  /// Returns the current cache size.
  int get size => _cache.length;

  /// Removes the oldest entry from the cache.
  void _evictOldest() {
    if (_cache.isEmpty) return;

    String? oldestKey;
    DateTime? oldestTime;

    for (final entry in _cache.entries) {
      if (oldestTime == null || entry.value.lastAccessed.isBefore(oldestTime)) {
        oldestTime = entry.value.lastAccessed;
        oldestKey = entry.key;
      }
    }

    if (oldestKey != null) {
      _cache.remove(oldestKey);
    }
  }
}

/// Internal class representing a cache entry with expiration and access tracking.
class _CacheEntry {
  final dynamic value;
  final DateTime expirationTime;
  DateTime lastAccessed;

  _CacheEntry(this.value, this.expirationTime) : lastAccessed = DateTime.now();

  bool get isExpired => DateTime.now().isAfter(expirationTime);

  void updateAccessTime() {
    lastAccessed = DateTime.now();
  }
}
