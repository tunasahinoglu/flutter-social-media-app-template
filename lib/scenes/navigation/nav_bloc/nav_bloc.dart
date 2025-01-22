import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'nav_event.dart';
part 'nav_state.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(NavInitial(selectedIndex: 0)) {
    on<TabChangedEvent>((event, emit) {
      emit(NavUpdated(selectedIndex: event.index));
    });
  }
}