part of 'download_cubit.dart';

abstract class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DownloadState {
  @override
  List<Object> get props => [];
}

class DownloadInitial extends DownloadState {
  final List<DownloadInProgress> progress;

  const DownloadInitial({required this.progress});

  @override
  List<Object?> get props => [progress];

  List<DownloadInProgress> get getProgress => progress;
}

class DownloadInProgress {
  final int index;
  final double percent;

  const DownloadInProgress(
      {required this.index, this.percent = 0});
}

class DownloadSuccess extends DownloadState {}

class DownloadFailure extends DownloadState {
  final String error;

  const DownloadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
