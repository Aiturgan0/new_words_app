import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState()) {
    on<ChangeLanguage>((event, emit) {
      emit(LanguageState(languageCode: event.languageCode));
    });
  }
}
