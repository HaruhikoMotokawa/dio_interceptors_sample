import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_named_api_resource.freezed.dart';
part 'pokemon_named_api_resource.g.dart';

@freezed
abstract class PokemonNamedApiResource with _$PokemonNamedApiResource {
  const factory PokemonNamedApiResource({
    required String name,
    required String url,
  }) = _PokemonNamedApiResource;

  factory PokemonNamedApiResource.fromJson(Map<String, dynamic> json) =>
      _$PokemonNamedApiResourceFromJson(json);
}
