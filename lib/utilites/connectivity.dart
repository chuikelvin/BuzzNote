import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ConnectivityStatus extends StatefulWidget {
  const ConnectivityStatus({super.key});

  @override
  State<ConnectivityStatus> createState() => _ConnectivityStatusState();
}

class _ConnectivityStatusState extends State<ConnectivityStatus> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// final connectivityResult = await (Connectivity().checkConnectivity());
// if (connectivityResult == ConnectivityResult.mobile) {
//   // I am connected to a mobile network.
// } else if (connectivityResult == ConnectivityResult.wifi) {
//   // I am connected to a wifi network.
// }