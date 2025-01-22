part of 'localization_bloc.dart';

abstract class LocalizationEvent extends Equatable {
  const LocalizationEvent();

  @override
  List<Object> get props => [];
}

class LocalizationChangedEvent extends LocalizationEvent {
  final Locale locale;

  const LocalizationChangedEvent(this.locale);

  @override
  List<Object> get props => [locale];
}