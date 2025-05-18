# Dio Interceptors Sample

Flutter/Dartで [dio](https://pub.dev/packages/dio) パッケージのInterceptor機能を活用した実装サンプル。様々なInterceptorパターンを使用して、HTTP通信の処理をカスタマイズする方法を示します。

![Dart Version](https://img.shields.io/badge/Dart-^3.6.0-blue)
![Flutter Version](https://img.shields.io/badge/Flutter-Stable-blue)

## 概要

このプロジェクトは、Dioパッケージのインターセプター機能を活用した以下の実装を含んでいます：

- キャッシュインターセプター（`DioCacheInterceptor`）
- リトライインターセプター（`RetryInterceptor`）
  - ネットワークエラー用
  - 認証エラー（401）用
- テスト用エラー発生インターセプター（`FakeErrorInterceptor`）

## 主な特徴

- **キャッシュ機能**: 同一リクエストのレスポンスをキャッシュしてネットワーク通信を削減
- **エラーリトライ機能**: ネットワークエラーや認証エラー発生時に自動的にリトライ
- **Riverpod統合**: インターセプターの依存性注入にRiverpodを使用
- **テスト環境**: 単体テストとモックを使った検証

## 使用されている技術・パッケージ

- [dio](https://pub.dev/packages/dio): HTTPクライアント
- [dio_cache_interceptor](https://pub.dev/packages/dio_cache_interceptor): キャッシュ機能
- [dio_smart_retry](https://pub.dev/packages/dio_smart_retry): リトライ機能
- [hooks_riverpod](https://pub.dev/packages/hooks_riverpod): 状態管理
- [go_router](https://pub.dev/packages/go_router): ナビゲーション
- [mockito](https://pub.dev/packages/mockito): モックテスト用

## インストール方法

```bash
# プロジェクトをクローン
git clone https://github.com/HaruhikoMotokawa/dio_interceptors_sample.git

# derry パッケージの有効化（スクリプト実行用）
dart pub global activate derry

# コード生成の実行
flutter pub run build_runner build --delete-conflicting-outputs
# または
derry build
```

## スクリプトコマンド

このプロジェクトでは `derry` パッケージを使用して、よく使うコマンドをショートカットとして定義しています。以下のコマンドが利用可能です：

```bash
# コード生成（build_runner）を一度だけ実行
derry build

# コード生成を監視モードで実行（ファイル変更を検知して自動生成）
derry watch

# Gradle デーモンプロセスを終了（ビルドエラー解消用）
derry gc

# テスト実行とカバレッジレポート生成（HTML形式）
derry cov

# Very Good CLI を使ったテスト実行とカバレッジレポート生成
derry cov_good

# Flutter環境のリセット（キャッシュクリア）
derry reset_flutter
```

## 使用例

1. `HomeScreen`からポケモンリスト画面を選択
2. 通常のAPIクライアント（インターセプターなし）または
   インターセプター付きクライアントでデータ取得の違いを確認
