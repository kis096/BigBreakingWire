// utils.dart
import 'package:flutter_html/flutter_html.dart';

String decodeHtmlEntities(String input) {
  return input
          .replaceAll('&#8217;', "'")
          .replaceAll('&#8211;', "–")
          .replaceAll('&amp;', "&")
          .replaceAll('&lt;', "<")
          .replaceAll('&gt;', ">")
          .replaceAll('&quot;', '"')
          .replaceAll('&apos;', "'")
          .replaceAll('&nbsp;', " ")
      // Add more replacements as needed
      ;
}

String decodeHtmlString(String htmlContent) {
  return Html(data: htmlContent).data ?? 'No content available';
}
