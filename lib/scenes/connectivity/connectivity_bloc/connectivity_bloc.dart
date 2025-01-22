import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:project_template/core/connectivity/connectivity_repository.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc() : super(ConnectivityInitial()) {
    on<ConnectionChange>(_onConnectionChange);
    on<StartupConnectionCheck>(_onStartupConnectionCheck);
    connectivitySubscription = ConnectivityRepository()
        .connectivityResult
        .listen((connectivityResult) {
      add(ConnectionChange(connectivityResult: connectivityResult));
    });
  }

  bool isInitialCheck = true;
  late StreamSubscription connectivitySubscription;

  void _onConnectionChange(
      ConnectionChange event, Emitter<ConnectivityState> emit) {
    _emitAppropriateState(event.connectivityResult, emit);
    isInitialCheck = false;
  }

  Future<void> _onStartupConnectionCheck(
      StartupConnectionCheck event, Emitter<ConnectivityState> emit) async {
    connectivitySubscription.pause();
    List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    ConnectivityResult result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    _emitAppropriateState(result, emit);
    connectivitySubscription.resume();
  }

  void _emitAppropriateState(ConnectivityResult result, Emitter<ConnectivityState> emit) {
    switch (result) {
      case ConnectivityResult.bluetooth:
        emit(HasConnectionState(needToBlock: isInitialCheck));
      case ConnectivityResult.wifi:
        emit(HasConnectionState(needToBlock: isInitialCheck));
      case ConnectivityResult.ethernet:
        emit(HasConnectionState(needToBlock: isInitialCheck));
      case ConnectivityResult.mobile:
        emit(HasConnectionState(needToBlock: isInitialCheck));
        break;
      case ConnectivityResult.none:
        emit(NoConnectionState());
        break;
      case ConnectivityResult.vpn:
      case ConnectivityResult.other:
        break;
    }
  }

  @override
  Future<void> close() {
    connectivitySubscription.cancel();
    return super.close();
  }
}