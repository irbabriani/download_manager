import 'package:download_manager/domain/entities/download/download_entity.dart';
import 'package:download_manager/domain/repositories/download_repository.dart';

class GetDownloads{
  final DownloadRepository downloadRepository;

  GetDownloads({required this.downloadRepository});
  List<DownloadEntity> call(){
    return downloadRepository.getDownloads();
  }
}