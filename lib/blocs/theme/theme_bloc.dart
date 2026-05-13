import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ToggleTheme>((event, emit) {
      if (state.themeMode == ThemeMode.light) {
        emit(const ThemeState(themeMode: ThemeMode.dark));
      } else {
        emit(const ThemeState(themeMode: ThemeMode.light));
      }
    });
  }
}
