import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final Box<String> _settingsBox;

  ThemeBloc(this._settingsBox) : super(ThemeInitial()) {
    on<ThemeChangedEvent>((event, emit) {
      emit(ThemeChangingState(event.theme));
      _settingsBox.put('theme', event.theme);
      emit(ThemeChangedState(event.theme));
    });

    _initializeTheme();
  }

  void _initializeTheme() {
    final savedTheme = _settingsBox.get('theme', defaultValue: 'light');
    if (savedTheme == 'dark') {
      add(const ThemeChangedEvent('dark'));
    } else {
      add(const ThemeChangedEvent('light'));
    }
  }

  @override
  Future<void> close() {
    _settingsBox.close();
    return super.close();
  }
}