import 'package:download_manager/data/models/download/download_model.dart';
import 'package:download_manager/domain/entities/download/download_entity.dart';

abstract class DownloadRepository{
  Future<void>addDownload(DownloadModel download);
  List<DownloadEntity>getDownloads();
}