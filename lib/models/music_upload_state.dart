sealed class MusicUploadState {}

final class Initial extends MusicUploadState{}
final class Success extends MusicUploadState {
  final String message;

  Success(this.message);
}

final class Uploading extends MusicUploadState {
  Uploading();
}

final class Error extends MusicUploadState {
  final String message;

  Error(this.message);
}
