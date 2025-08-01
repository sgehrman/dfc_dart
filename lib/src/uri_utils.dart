import 'package:dfc_dart/src/string_utils.dart';
import 'package:mime/mime.dart';

// Size is in Flutter, not dart, so we use ImageSize
class ImageSize {
  const ImageSize(this.width, this.height);
  static const zero = ImageSize(0, 0);

  final int width;
  final int height;
}

// =========================================================

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

  static bool isEqualTo(String? url1, String? url2) {
    if (url1 == url2) {
      return true;
    }

    // case differences?  /r/UFOB vs. /r/ufob
    // www.example.com vs. example.com
    // example.com/ vs example.com
    // Example.com vs. example.com
    // https vs HTTPS

    final uri1 = parseUri(url1);
    final uri2 = parseUri(url2);

    if (uri1 != null && uri2 != null) {
      // uri seems to convert the case to lower, just do a quick test without any trailing slash
      final b1 = StrUtls.removeEnd(uri1.toString(), '/');
      final b2 = StrUtls.removeEnd(uri2.toString(), '/');
      if (b1 == b2) {
        return true;
      }

      // scheme returns lower case letters
      if (uri1.scheme != uri2.scheme) {
        return false;
      }

      // origin returns lower case letters, and port
      // Origin is only applicable to schemes http and https:
      // chrome://extensions will crash for example
      if (uri1.scheme.startsWith('http')) {
        try {
          if (uri1.origin != uri2.origin) {
            // what if we remove www?
            final o1 = uri1.origin.replaceAll('www.', '');
            final o2 = uri2.origin.replaceAll('www.', '');

            if (o1 != o2) {
              return false;
            }
          }
        } catch (err) {
          print(err);
        }
      }

      // path, convert to lower case and remove trailing slash
      final p1 = StrUtls.removeEnd(uri1.path.toLowerCase(), '/');
      final p2 = StrUtls.removeEnd(uri2.path.toLowerCase(), '/');

      if (p1 != p2) {
        return false;
      }

      // query string, need to convert lower case? not sure, try this first
      if (uri1.query != uri2.query) {
        return false;
      }

      // got this far so true?
      return true;
    }

    return false;
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

  // favIcons from chrome use this url scheme
  // https://developer.chrome.com/docs/extensions/mv3/favicon/
  static bool isChromeExtUrl(String? url) {
    final uri = parseUri(url);

    return isChromeExtUri(uri);
  }

  static bool isChromeExtUri(Uri? uri) {
    return uri != null && uri.scheme == 'chrome-extension';
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

  static ImageSize imageSizeFromUri(Uri? uri) {
    if (uri == null) {
      return ImageSize.zero;
    }

    // example-100x100.jpg
    // example-100x100@2x.jpg
    // example-100w.jpg
    // example_1920x1200.jpg
    // example_yt_1200.jpg

    // don't get _l5mhbqwka2f91, look for letter vs digit counts
    // also get query param width=
    // example_l5mhbqwka2f91.png?width=256&v=enabled&s=5a518842611e975d1c59e6548ce545625a8c5ea4

    // problem cases? check for multiple -?
    // https://sp.rmbl.ws/s8/1/4/H/2/A/4H2Aj.0kob-small-May-4-2023.jpg

    // don't start with letter
    // favicon_v4.png

    // https://sp.rmbl.ws/s8/1/6/1/M/A/61MAj.0kob-small-SYSTEM-UPDATE-SHOW-81.jpg

    try {
      // check for any parameters
      if (uri.queryParameters.isNotEmpty) {
        final wStr = uri.queryParameters['width'];
        final hStr = uri.queryParameters['height'];

        var w = 0;
        var h = 0;

        if (wStr != null) {
          w = int.tryParse(wStr) ?? 0;
        }
        if (hStr != null) {
          h = int.tryParse(hStr) ?? 0;
        }

        if (w != 0 || h != 0) {
          return ImageSize(w, h);
        }
      }

      if (uri.pathSegments.isNotEmpty) {
        final name = uri.pathSegments.last.toLowerCase();
        final len = name.length;
        var isUnderscore = false;

        var markerIndex = name.lastIndexOf('-');
        if (markerIndex == -1) {
          markerIndex = name.lastIndexOf('_');
          isUnderscore = true;
        }

        if (markerIndex != -1 && markerIndex < len) {
          final extIndex = name.lastIndexOf('.');

          if (extIndex != -1 && extIndex < len && extIndex > markerIndex) {
            final sizeText = name.substring(markerIndex + 1, extIndex);

            if (sizeText.isNotEmpty) {
              // 100x200x
              final sizes = sizeText.split('x');
              if (sizes.length == 2) {
                final width = int.tryParse(sizes.first);
                final height = int.tryParse(sizes.last);

                if (width != null && height != null) {
                  return ImageSize(width, height);
                }
              } else {
                if (StrUtls.firstIsDigit(sizeText)) {
                  // 700w ?
                  final digitStr = StrUtls.digitsOnly(sizeText);
                  final lettersStr = StrUtls.lettersOnly(sizeText);

                  if (digitStr.isNotEmpty && digitStr.length <= 4) {
                    final width = int.tryParse(digitStr);

                    if (width != null) {
                      if (lettersStr.isEmpty) {
                        if (isUnderscore) {
                          // rumble had a bunch of false positives, but youtube seems to be ok
                          // example_yt_1200.jpg
                          // https://sp.rmbl.ws/s8/1/4/H/2/A/4H2Aj.0kob-small-May-4-2023.jpg
                          // https://sp.rmbl.ws/s8/1/6/1/M/A/61MAj.0kob-small-SYSTEM-UPDATE-SHOW-81.jpg

                          return ImageSize(width, width);
                        } else {
                          return ImageSize.zero;
                        }
                      }

                      // if more letters than digits, that would be weird?
                      // assuming we got junk like _2klj3l3j23j333j
                      if (lettersStr.length > 2) {
                        return ImageSize.zero;
                      }

                      return ImageSize(width, 0);
                    }
                  }
                }
              }
            }
          }
        }
      }
    } catch (err) {
      print(err);
    }

    return ImageSize.zero;
  }

  // ------------------------------------------------------------
  // removes http(s)://www. from the url
  // for display purposes only

  static String shortDisplayUrl(String url) {
    final uri = UriUtils.parseUri(url);
    if (uri != null) {
      return shortDisplayUri(uri);
    }

    return url;
  }

  static String shortDisplayUri(Uri uri) {
    final result = uri.toString().replaceFirst('${uri.scheme}://', '');

    return result.replaceFirst('www.', '');
  }
}
