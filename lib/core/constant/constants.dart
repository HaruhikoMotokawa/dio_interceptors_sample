abstract final class Constants {
  /// dioのリトライ待機時間
  ///
  /// テストで時間を変更できるようにするためstaticのみで宣言する
  static List<Duration> dioRetryDelays = const [
    Duration(seconds: 1),
    Duration(seconds: 3),
    Duration(seconds: 5),
  ];
}
