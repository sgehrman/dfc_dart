import 'package:mime/mime.dart';

class UriUtils {
  UriUtils._();

  static String? urlOrigin(String url) {
    final uri = parseUri(url);
    // crashes if origin is called on a non http scheme
    if (isHttpUri(uri)) {
      return uri!.origin;
    }

    return null;
  }

  // Uri.tryParse doesn't return null for ''
  static Uri? parseUri(String? url) {
    if (url != null && url.isNotEmpty) {
      final result = Uri.tryParse(url);

      if (result != null) {
        return result;
      }

      // tryParse doesn't handle data uris??
      if (url.startsWith(RegExp('data', caseSensitive: false))) {
        try {
          // some data urls have spaces?
          final data = UriData.parse(url.replaceAll(' ', ''));

          return data.uri;
        } catch (err) {
          print('UriData.parse failed: $url, err: $err');
        }
      }
    }

    return null;
  }

  static bool isHttpUrl(String? url) {
    final uri = parseUri(url);

    return isHttpUri(uri);
  }

  static bool isHttpUri(Uri? uri) {
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  static bool isSvgUrl(String? url) {
    final uri = parseUri(url);

    return isSvgUri(uri);
  }

  static bool isSvgUri(Uri? uri) {
    if (isHttpUri(uri)) {
      final mimeType = lookupMimeType(uri!.path);

      return mimeType == 'image/svg+xml';
    }

    return false;
  }

  static bool isIcoUrl(String? url) {
    final uri = parseUri(url);

    return isIcoUri(uri);
  }

  static bool isIcoUri(Uri? uri) {
    if (isHttpUri(uri)) {
      final mimeType = lookupMimeType(uri!.path);

      return mimeType == 'image/x-icon';
    }

    return false;
  }

  static bool isDataUrl(String? url) {
    final uri = parseUri(url);

    return isDataUri(uri);
  }

  static bool isDataUri(Uri? uri) {
    if (uri != null) {
      return uri.isScheme('data');
    }

    return false;
  }

  static bool isPngUrl(String? url) {
    final uri = parseUri(url);

    return isPngUri(uri);
  }

  static bool isPngUri(Uri? uri) {
    if (isHttpUri(uri)) {
      final mimeType = lookupMimeType(uri!.path);

      return mimeType == 'image/png';
    }

    return false;
  }

  static bool isJpgUrl(String? url) {
    final uri = parseUri(url);

    return isJpgUri(uri);
  }

  static bool isJpgUri(Uri? uri) {
    if (isHttpUri(uri)) {
      final mimeType = lookupMimeType(uri!.path);

      return mimeType == 'image/jpg' || mimeType == 'image/jpeg';
    }

    return false;
  }

  static bool isGifUrl(String? url) {
    final uri = parseUri(url);

    return isGifUri(uri);
  }

  static bool isGifUri(Uri? uri) {
    if (isHttpUri(uri)) {
      final mimeType = lookupMimeType(uri!.path);

      return mimeType == 'image/gif';
    }

    return false;
  }

  static bool uriIsHtml(Uri? uri) {
    if (isHttpUri(uri)) {
      final segments = uri!.pathSegments;

      if (segments.isNotEmpty) {
        final lastSegment = segments.last.toLowerCase();

        // not sure the best way to do this, for now, just check if path has an image extension
        if (lastSegment.endsWith('.png') ||
            lastSegment.endsWith('.jpg') ||
            lastSegment.endsWith('.jpeg') ||
            lastSegment.endsWith('.gif') ||
            lastSegment.endsWith('.ico') ||
            lastSegment.endsWith('.svg') ||
            lastSegment.endsWith('.pdf') ||
            lastSegment.endsWith('.mp4') ||
            lastSegment.endsWith('.tiff') ||
            lastSegment.endsWith('.mp3') ||
            lastSegment.endsWith('.webp')) {
          return false;
        }
      }

      // empty path is ok too
      return true;
    }

    return false;
  }

  static String? uriOrigin(Uri uri) {
    // crashes if origin is called on a non http scheme
    if (isHttpUri(uri)) {
      return uri.origin;
    }

    return null;
  }
}
