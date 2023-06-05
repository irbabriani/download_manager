import 'package:download_manager/data/models/download/download_model.dart';
import 'package:download_manager/domain/repositories/download_repository.dart';

class AddDownloadUseCase{
  final DownloadRepository downloadRepository;

  AddDownloadUseCase({required this.downloadRepository});

  Future<void> call(DownloadModel download)async{
    await downloadRepository.addDownload(download);
  }
}