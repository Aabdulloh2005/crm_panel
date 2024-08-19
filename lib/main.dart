import 'package:flutter/material.dart';
import 'package:lesson_101/core/app.dart';
import 'package:lesson_101/core/get_it.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  setUpAuth();
  runApp(const MyApp());
}

