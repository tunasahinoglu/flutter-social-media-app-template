part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeChangedEvent extends ThemeEvent {
  final String theme;

  const ThemeChangedEvent(this.theme);

  @override
  List<Object> get props => [theme];
}