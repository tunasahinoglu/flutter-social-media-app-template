part of 'connectivity_bloc.dart';

abstract class ConnectivityState {}

class ConnectivityInitial extends ConnectivityState {}

class NoConnectionState extends ConnectivityState {}

class HasConnectionState extends ConnectivityState {
  final bool needToBlock;

  HasConnectionState({required this.needToBlock});
}