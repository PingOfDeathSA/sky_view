import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sky_view/model/get-postion-model.dart';
import 'package:sky_view/server/astrologicalSignData.dart';
import 'package:sky_view/view-model/get-position.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SkyMap extends StatefulWidget {
  const SkyMap({super.key});

  @override
  State<SkyMap> createState() => _SkyMapState();
}

class _SkyMapState extends State<SkyMap> {
  Map<String, dynamic>? result;
  DateTime? _selectedDate;

  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    _loadPositionData(_selectedDate!);
  }

  Future<void> _loadPositionData(DateTime date) async {
    final dataList = astrologicalSignData
        .map((map) => GetPositionModel.fromMap(map))
        .toList();
    final positionData =
        await GetPositionConstructor.getPosition(dataList, date, context);
    if (positionData != null) {
      setState(() {
        result = positionData;
        controller.loadRequest(Uri.parse(result!['image_url']));
      });
    } else {
      setState(() {
        result = null;
      });
    }
  }

  bool get userSelectedDate {
    if (_selectedDate == null) return false;
    final now = DateTime.now();
    return !(_selectedDate!.year == now.year &&
        _selectedDate!.month == now.month &&
        _selectedDate!.day == now.day);
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      await _loadPositionData(_selectedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return Center(
          child: LoadingAnimationWidget.discreteCircle(
        color: Color(0xffFED16A),
        size: 50,
        secondRingColor: Colors.white,
        thirdRingColor: Colors.blueAccent,
      ));
    }
    final screenWidth = MediaQuery.of(context).size.width;
    final customWidth = screenWidth.clamp(360.0, 1200.0);

    final monthName = _selectedDate == null
        ? 'No date selected'
        : DateFormat('d MMMM yyyy').format(_selectedDate!);

    return SafeArea(
      bottom: true,
      top: true,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 3, 36, 92),
        body: Center(
          child: Container(
            width: customWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () => _pickDate(context),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  border: Border.all(color: Color(0xffFED16A))),
                              child: Text(
                                'Pick a Date',
                                style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      userSelectedDate
                          ? Container(
                              height: 40,
                              child:
                                  userText('Your zodiac', 'shines brightest!'))
                          : Text(
                              textAlign: TextAlign.center,
                              "Stars in this month",
                              style: GoogleFonts.openSans(
                                color: userSelectedDate
                                    ? Color(0xffFED16A)
                                    : Colors.white,
                                fontSize: userSelectedDate ? 28 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              result!['current_month'].toString(),
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset(
                              'assets/${result!['symbol']}',
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/aries_symbol.png');
                              },
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              userSelectedDate ? 'Your Sign' : 'Today\'s Sign',
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: userSelectedDate ? 15 : 15,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                            Text(
                              result!['name'].toString(),
                              style: GoogleFonts.openSans(
                                color: const Color(0xffFED16A),
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                shadows: const [
                                  Shadow(
                                    color: Color(0xffFED16A),
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                        Text(
                          'Sky Position',
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 435,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            child: Image.network(
                              result!['image_url'].toString(),
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget userText(String text, String text2) {
    const colorizeColors = [
      Color(0xFFFAFFAF),
      Color(0xFF96C9F4),
      Color(0xFF3FA2F6),
      Color(0xFF0F67B1),
    ];
    const colorizeTextStyle = TextStyle(
      fontSize: 30.0,
      fontFamily: 'Horizon',
    );
    return SizedBox(
      child: AnimatedTextKit(
        repeatForever: true,
        animatedTexts: [
          ColorizeAnimatedText(
            text,
            textStyle: colorizeTextStyle,
            colors: colorizeColors,
          ),
          ColorizeAnimatedText(
            text2,
            textStyle: colorizeTextStyle,
            colors: colorizeColors,
          ),
        ],
        isRepeatingAnimation: true,
      ),
    );
  }
}
