part of 'nav_bloc.dart';

abstract class NavState extends Equatable {
  const NavState();

  @override
  List<Object> get props => [];
}

class NavInitial extends NavState {
  final int selectedIndex;

  const NavInitial({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}

class NavUpdated extends NavState {
  final int selectedIndex;

  const NavUpdated({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}