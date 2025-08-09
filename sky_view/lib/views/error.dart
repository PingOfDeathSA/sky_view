import 'package:flutter/material.dart';
import 'package:sky_view/main.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          child: const Text('Error occured'),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyApp())),
        ),
      ),
    );
  }
}