import 'package:download_manager/domain/entities/download/download_entity.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class DownloadModel{
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  DownloadModel({required this.id, required this.name});

  factory DownloadModel.fromEntity(DownloadEntity entity) {
    return DownloadModel(id: entity.id, name: entity.name);
  }

  DownloadEntity toEntity() {
    return DownloadEntity(id: id, name: name);
  }
}