part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent {}

class StartupConnectionCheck extends ConnectivityEvent {}

class ConnectionChange extends ConnectivityEvent {
  final ConnectivityResult connectivityResult;

  ConnectionChange({required this.connectivityResult});
}