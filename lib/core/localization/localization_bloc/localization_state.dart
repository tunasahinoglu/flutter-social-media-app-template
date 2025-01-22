part of 'localization_bloc.dart';

abstract class LocalizationState extends Equatable {
  const LocalizationState();

  @override
  List<Object> get props => [];
}

class LocalizationInitial extends LocalizationState {}

class LocalizationChangedState extends LocalizationState {
  final Locale locale;

  const LocalizationChangedState(this.locale);

  @override
  List<Object> get props => [locale];
}