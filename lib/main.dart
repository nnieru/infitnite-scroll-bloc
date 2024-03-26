import 'package:flutter/material.dart';
import 'package:infinitelist/app.dart';
import 'package:infinitelist/simple_bloc_oberserver.dart';
import 'package:bloc/bloc.dart';

void main() {
  Bloc.observer = const SimpleBlocOberver();
  runApp(const App());
}