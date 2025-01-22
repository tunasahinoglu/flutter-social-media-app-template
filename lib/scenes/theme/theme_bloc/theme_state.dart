part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeChangingState extends ThemeState {
  final String theme;

  const ThemeChangingState(this.theme);

  @override
  List<Object> get props => [theme];
}

class ThemeChangedState extends ThemeState {
  final String theme;

  const ThemeChangedState(this.theme);

  @override
  List<Object> get props => [theme];
}