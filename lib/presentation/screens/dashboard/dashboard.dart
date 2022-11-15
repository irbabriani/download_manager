import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:download_manager/presentation/screens/needed_packages.dart';
import 'package:download_manager/presentation/screens/dashboard/cubit/dashboard_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text(translate("dashboard.app_bar.title")),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [CircularProgressIndicator()],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () async {
                          var url = Uri.parse(
                              "https://upload.wikimedia.org/wikipedia/commons/e/e4/GatesofArctic.jpg");
                          http.Response r = await http.head(url);
                          var length =
                              int.parse(r.headers["content-length"].toString());
                          var contentType =
                          r.headers["content-type"].toString();
                          var disposition =
                          r.headers["content-disposition"].toString();
                          int len = 5;
                          print("length: $length");
                          var divided = length ~/ len;
                          var arr = List.filled(len, String, growable: false);
                          var lastBuffer = 0;
                          int ii = 0;
                          Future.forEach(arr, (element) async {
                            ii = ii + 1;
                            var port = ReceivePort();
                            if (ii != (len - 1)) {
                              await Isolate.spawn(spliter,
                                  [port.sendPort, url, lastBuffer, divided]);
                              lastBuffer = (lastBuffer + divided + 1);
                            } else {
                              await Isolate.spawn(spliter,
                                  [port.sendPort, url, lastBuffer, length]);
                            }
                            // port.listen((message) {
                            //   if (message != "") {
                            //     arr.insert(ii, message);
                            //   }
                            // });
                          });
                        },
                        child: const Text("Download"))
                  ],
                )
              ],
            ));
      },
    );
  }

  static void spliter(List<dynamic> args) async {
    SendPort sendPort = args[0];
    Uri url = args[1];
    int lastBuffer = args[2];
    int divided = args[3];
    // var res = await http.get(url, headers: {
    //   'range': 'bytes=$lastBuffer-${lastBuffer + divided}',
    //   'cache-control': 'no-cache',
    // });

    final request = http.Request('GET', url);
    request.headers.addAll({
      'range': 'bytes=$lastBuffer-${lastBuffer + divided}',
      'cache-control': 'no-cache',
    });
    final http.StreamedResponse response = await http.Client().send(request);
    final contentLength = response.contentLength;

    List<int> bytes = [];

    // final file = await getFile('video.mp4');

    response.stream.listen((List<int> newBytes) {
      bytes.addAll(newBytes);
      final downloadedLength = bytes.length;
      downloadedLength.toDouble() / (contentLength ?? 1);
    },onDone: ()async{
      print(bytes.length);
      sendPort.send("bytes");
      // await file.writeAsBytes(bytes);
    },onError: (e) {
      debugPrint(e);
    },
      cancelOnError: true,);
  }

  static Future<File> getFile(String filename) async {
    final dir = await getTemporaryDirectory();
    return File("${dir.path}/$filename");
  }
}
