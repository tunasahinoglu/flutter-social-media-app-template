part of 'nav_bloc.dart';

abstract class NavEvent extends Equatable {
  const NavEvent();

  @override
  List<Object> get props => [];
}

class TabChangedEvent extends NavEvent {
  final int index;

  const TabChangedEvent(this.index);

  @override
  List<Object> get props => [index];
}