import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityRepository {
  static final ConnectivityRepository _connectivityRepository = ConnectivityRepository._internal();

  factory ConnectivityRepository() {
    return _connectivityRepository;
  }

  ConnectivityRepository._internal();

  final Connectivity _connectivity = Connectivity();

  Stream<ConnectivityResult> get connectivityResult {
    return _connectivity.onConnectivityChanged.map((List<ConnectivityResult> results) {
      return results.isNotEmpty ? results.first : ConnectivityResult.none;
    });
  }

  Future<ConnectivityResult> checkCurrentConnectivity() async {
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    return results.isNotEmpty ? results.first : ConnectivityResult.none;
  }
}