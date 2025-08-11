import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_view/model/get-postion-model.dart';
import 'package:http/http.dart' as http;
import 'package:sky_view/utils/popUp.dart';
import 'package:xml/xml.dart';

class GetPositionConstructor {
  static Future<Map<String, String>?> getRaAndDec(
      String astrologicalName, BuildContext context) async {
    final originalUrl =
        Uri.parse("https://server2.sky-map.org/search?star=$astrologicalName");

    final url = kIsWeb
        ? Uri.parse(
            'http://localhost:3000/stars?url=${Uri.encodeComponent(originalUrl.toString())}')
        : originalUrl;

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body);

      final raElement = document.findAllElements('ra').isNotEmpty
          ? document.findAllElements('ra').first
          : null;
      final decElement = document.findAllElements('de').isNotEmpty
          ? document.findAllElements('de').first
          : null;
      final radiusElement = document.findAllElements('radius').isNotEmpty
          ? document.findAllElements('radius').first
          : null;

      if (raElement == null || decElement == null) {
        // print('astrological sign not found for $astrologicalName');
        showMyDialog(context);
        return null;
      }

      return {
        "ra": raElement.text,
        "dec": decElement.text,
        "angle": radiusElement != null ? radiusElement.text : '0',
      };
    } else {
      showMyDialog(context);
      // print('error: ${response.statusCode}');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getPosition(List<GetPositionModel> data,
      DateTime? selectedDate, BuildContext context) async {
    final now = selectedDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var i = 0; i < data.length; i++) {
      final startParts = data[i].start_date.split('/');
      final endParts = data[i].end_date.split('/');
      final start = DateTime(
        now.year,
        int.parse(startParts[1]),
        int.parse(startParts[0]),
      );
      final end = DateTime(
        now.year,
        int.parse(endParts[1]),
        int.parse(endParts[0]),
      );
      bool isInRange;
      if (end.isBefore(start)) {
        isInRange = today.isAfter(start) ||
            today.isBefore(end.add(const Duration(days: 1)));
      } else {
        isInRange = today.isAfter(start.subtract(const Duration(days: 1))) &&
            today.isBefore(end.add(const Duration(days: 1)));
      }
      if (isInRange) {
        final raDec = await getRaAndDec(data[i].name, context);
        if (raDec == null) {
          continue;
        }
        final monthName = DateFormat('MMMM').format(now);

        final imageUrl =
            'http://server2.sky-map.org/map?type=PART&w=1200&h=1000&angle=${raDec['angle']}&ra=${raDec['ra']}&de=${raDec['dec']}&rotation=0&mag=7.5&max_stars=100000&zoom=8&borders=0&border_color=400000&show_grid=0&grid_color=404040&grid_color_zero=808080&grid_lines_width=1&grid_ra_step=1&grid_de_step=1&show_const_lines=1&constellation_lines_color=006000&constellation_lines_width=1&language=EN&show_const_names=1&constellation_names_color=006000&const_name_font_type=PLAIN&const_name_font_name=SanSerif&const_name_font_size=15&show_const_boundaries=1&constellation_boundaries_color=000060&constellation_boundaries_width=1&background_color=1&output=1';

        final proxyUrl =
            'http://localhost:3000/proxy?url=${Uri.encodeComponent(imageUrl)}';

        final currentPositionData = {
          'image_url': kIsWeb ? proxyUrl : imageUrl,
          'name': data[i].name,
          'start_date': data[i].start_date,
          'end_date': data[i].end_date,
          'symbol': data[i].symbol,
          'ra': raDec['ra'],
          'de': raDec['dec'],
          'current_month': monthName,
        };
        return currentPositionData;
      }
    }
    return null;
  }
}
