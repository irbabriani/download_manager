import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:download_manager/presentation/screens/needed_packages.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  createFile(int split) async {
    Directory directory = await getApplicationDocumentsDirectory();
    var b = BytesBuilder();
    for (int i = 0; i < split; i++) {
      final File file = File('${directory.path}/my_file$i.txt');
      var ress = await file.readAsBytes();
      b.add(ress);
    }
    final File newFile = File('${directory.path}/new_file.zip');
    await newFile.writeAsBytes(b.toBytes());
  }

  download(Uri uri, int split) async {
    Directory directory = await getApplicationDocumentsDirectory();
    int length = await getUirInfo(uri);
    var divided = length ~/ split;
    var lastBuffer = 0;
    for (int i = 0; i < split; i++) {
      var port = ReceivePort();
      var shredderModel = ShredderModel(
          sendPort: port.sendPort,
          directory: directory,
          fromByte: lastBuffer,
          toByte: divided + lastBuffer,
          i: i,
          url: uri);

      if (i != (split - 1)) {
        await Isolate.spawn(shredder, shredderModel);
        lastBuffer = (lastBuffer + divided + 1);
      } else {
        await Isolate.spawn(shredder, shredderModel);
      }
      port.listen((message) {
        print(message);
      });
    }
  }

  Future<int> getUirInfo(Uri uri) async {
    var basenameWithoutExtension =
        path.basenameWithoutExtension(uri.toString());
    var extension = path.extension(uri.toString());
    http.Response r = await http.head(uri).timeout(const Duration(seconds: 4));
    var length = int.parse(r.headers["content-length"].toString());
    var contentType = r.headers["content-type"].toString();
    var disposition = r.headers["content-disposition"].toString();
    return length;
  }

  static void shredder(ShredderModel shredder) async {
    final request = http.Request('GET', shredder.url);
    request.headers.addAll({
      'range': 'bytes=${shredder.fromByte}-${shredder.toByte}',
      'cache-control': 'no-cache',
    });
    final http.StreamedResponse response = await http.Client().send(request);
    final contentLength = response.contentLength;

    List<int> bytes = [];
    response.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
        final downloadedLength = bytes.length;
        var progress =
            (downloadedLength.toDouble() / (contentLength ?? 1) * 100).round();
        shredder.sendPort.send("${shredder.i}=>$progress");
      },
      onDone: () async {
        final File file =
            File('${shredder.directory.path}/my_file${shredder.i}.txt');
        await file.writeAsBytes(bytes);
      },
      onError: (e) {
        debugPrint(e);
      },
      cancelOnError: true,
    );
  }

  static Future<File> getFile(String filename) async {
    final dir = await getTemporaryDirectory();
    return File("${dir.path}/$filename");
  }
}

class ShredderModel {
  final SendPort sendPort;
  final Uri url;
  final int fromByte;
  final int toByte;
  final int i;
  final Directory directory;

  ShredderModel(
      {required this.sendPort,
      required this.url,
      required this.fromByte,
      required this.toByte,
      required this.i,
      required this.directory});
}
