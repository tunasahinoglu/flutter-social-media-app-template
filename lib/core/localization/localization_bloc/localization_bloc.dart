import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'localization_event.dart';
part 'localization_state.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  final Box<String> _settingsBox;

  LocalizationBloc(this._settingsBox) : super(_getInitialState(_settingsBox)) {
    on<LocalizationChangedEvent>((event, emit) async {
      await _settingsBox.put('Localization', event.locale.languageCode);
      emit(LocalizationChangedState(event.locale));
    });
  }

  static LocalizationState _getInitialState(Box<String> settingsBox) {
    final savedLocalizationCode = settingsBox.get('Localization', defaultValue: 'en');
    final initialLocale = Locale(savedLocalizationCode!);
    return LocalizationChangedState(initialLocale);
  }

  void changeLocale(BuildContext context, Locale newLocale) {
    context.setLocale(newLocale);
    add(LocalizationChangedEvent(newLocale));
  }
}