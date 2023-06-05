import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DownloadIsolates extends StatefulWidget {
  @override
  _DownloadIsolatesState createState() => _DownloadIsolatesState();
}

class _DownloadIsolatesState extends State<DownloadIsolates> {
  int _numIsolates = 30;
  List<SendPort> _sendPorts = [];
  List<double> _progress = List.filled(30, 0.0);

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _numIsolates; i++) {
      _spawnIsolate(i);
    }
  }

  void _spawnIsolate(int isolateIndex) async {
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(_download, receivePort.sendPort);
    _sendPorts.add(receivePort.sendPort);
    receivePort.listen((data) {
      setState(() {
        _progress[isolateIndex] = data;
      });
    });
  }

  static void _download(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    final message = await receivePort.first;
    final url = 'https://file-examples-com.github.io/uploads/2017/02/zip_2MB.zip';
    final response = await http.get(Uri.parse(url));
    final contentLength = response.headers['content-length'];
    final totalBytes = contentLength != null ? int.parse(contentLength) : -1;
    final bytes = response.bodyBytes;
    var downloadedBytes = 0;
    for (final byte in bytes) {
      downloadedBytes++;
      final progress = downloadedBytes / totalBytes;
      sendPort.send(progress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Isolates'),
      ),
      body: ListView.builder(
        itemCount: _numIsolates,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Isolate ${index + 1}'),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _progress[index],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}