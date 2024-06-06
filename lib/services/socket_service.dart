import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket socket;

  ServerStatus get serverStatus => _serverStatus;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client
    socket = IO.io(
        'https://flutter-socket-io-server-9yxx.onrender.com/',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect()
            //.disableAutoConnect()  // disable auto-connection
            //.setExtraHeaders({'foo': 'bar'}) // optional
            .build());

    socket.onConnect((_) {
      print('Connected');
      socket.emit('mensaje', 'onConnect :)');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    /* socket.on(
        'nuevo-mensaje',
        (payload) => {
              print('nuevo-mensaje: '),
              print('De: ' + payload['nombre']),
              print('Mensaje: ' + payload['mensaje']),
              print(payload.containsKey('mensaje2')
                  ? payload['mensaje2']
                  : 'no msj2'),
            }); */
  }
}
