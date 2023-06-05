import 'package:download_manager/data/models/download/download_model.dart';
import 'package:download_manager/domain/entities/download/download_entity.dart';
import 'package:hive/hive.dart';
import 'package:download_manager/domain/repositories/download_repository.dart';

abstract class DownloadRepositoryImpl implements DownloadRepository{
  final Box<DownloadModel> _downloadBox = Hive.box<DownloadModel>('downloads');

  @override
  Future<void> addDownload(DownloadModel download) async {
    await _downloadBox.put(download.id, download);
  }
  @override
  List<DownloadEntity>getDownloads(){
    final downloads = _downloadBox.values.map((download) => download.toEntity()).toList();
    return downloads;
  }
}