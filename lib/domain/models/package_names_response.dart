import 'package:freezed_annotation/freezed_annotation.dart';

part 'package_names_response.freezed.dart';
part 'package_names_response.g.dart';

@freezed
abstract class PackageNamesResponse with _$PackageNamesResponse {
  const factory PackageNamesResponse({
    required List<String> packages,
  }) = _PackageNamesResponse;

  factory PackageNamesResponse.fromJson(Map<String, dynamic> json) =>
      _$PackageNamesResponseFromJson(json);
}
