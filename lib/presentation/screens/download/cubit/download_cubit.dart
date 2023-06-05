import 'dart:io';

import 'package:download_manager/data/models/download/download_model.dart';
import 'package:download_manager/domain/entities/download/download_entity.dart';
import 'package:download_manager/domain/repositories/download_repository.dart';
import 'package:download_manager/domain/usecases/download/add_download_use_case.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:typed_data' as typedData;
import 'dart:isolate';
import 'package:download_manager/presentation/screens/needed_packages.dart';
import 'package:equatable/equatable.dart';

part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  final DownloadRepository _downloadRepository;
  DownloadCubit(this._downloadRepository) : super(DashboardInitial());

  createFile(int split) async {
    Directory directory = await getApplicationDocumentsDirectory();
    var byteBuilder = typedData.BytesBuilder();
    for (int i = 0; i < split; i++) {
      final File file = File('${directory.path}/SDM/my_file$i.txt');
      var readAsBytes = await file.readAsBytes();
      byteBuilder.add(readAsBytes);
    }
    final File newFile = File('${directory.path}/SDM/new_file.zip');
    await newFile.writeAsBytes(byteBuilder.toBytes());
  }

  download(Uri uri, int split) async {
    var isMultiPartSupport = await checkMultipartSupport(uri.toString());
    if (!isMultiPartSupport) {
      return;
    }
    var listDownload = <DownloadInProgress>[];
    for (int i = 0; i < split; i++) {
      listDownload.add(DownloadInProgress(index: i, percent: 0));
    }
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
        ShredderDownload downloadModel = message;
        listDownload[downloadModel.partNumber] = DownloadInProgress(
            index: downloadModel.partNumber, percent: downloadModel.percentage);
        emit(DownloadInitial(progress: listDownload));

        bool allDownloadComplete =
            listDownload.every((download) => download.percent == 100);
        if (allDownloadComplete) {
          emit(DownloadSuccess());
        }
        // print('${downloadModel.partNumber}=>${downloadModel.percentage}');
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
            (downloadedLength.toDouble() / (contentLength ?? 1));
        var downloadModel =
            ShredderDownload(partNumber: shredder.i, percentage: progress);
        shredder.sendPort.send(downloadModel);
      },
      onDone: () async {
        final File file =
            File('${shredder.directory.path}/SDM/my_file${shredder.i}.txt');
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

  Future<bool> checkMultipartSupport(String url) async {
    try {
      var request = http.Request('HEAD', Uri.parse(url));
      var response = await request.send();
      return response.headers.containsKey('accept-ranges');
    } catch (e) {
      return false;
    }
  }

  addDownload(DownloadEntity entity)async{
    final downloadModel = DownloadModel.fromEntity(entity);
    _downloadRepository.addDownload(downloadModel);
  }
  getDownloads()async{
    var downloads = _downloadRepository.getDownloads();
    debugPrint('${downloads.length}');
  }
}

class ShredderModel {
  final SendPort sendPort;
  final Uri url;
  final int fromByte;
  final int toByte;
  final int i;
  final Directory directory;

  ShredderModel({
    required this.sendPort,
    required this.url,
    required this.fromByte,
    required this.toByte,
    required this.i,
    required this.directory,
  });
}

class ShredderDownload {
  final int partNumber;
  final double percentage;

  ShredderDownload({required this.partNumber, required this.percentage});
}


