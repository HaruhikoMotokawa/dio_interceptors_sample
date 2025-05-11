// ignore_for_file: invalid_annotation_target

import 'package:dio_interceptors_sample/domain/api_models/pokemon_named_api_resource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_species.freezed.dart';
part 'pokemon_species.g.dart';

@freezed
abstract class PokemonSpecies with _$PokemonSpecies {
  const factory PokemonSpecies({
    required int id, // ID
    required String name, // 名前
    required Sprites sprites, // スプライト画像
    required List<PokemonType> types, // タイプ
  }) = _PokemonSpecies;

  factory PokemonSpecies.fromJson(Map<String, dynamic> json) =>
      _$PokemonSpeciesFromJson(json);
}

@freezed
abstract class Sprites with _$Sprites {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Sprites({
    required String? frontDefault, // 正面画像
  }) = _Sprites;

  factory Sprites.fromJson(Map<String, dynamic> json) =>
      _$SpritesFromJson(json);
}

@freezed
abstract class PokemonType with _$PokemonType {
  const factory PokemonType({
    required int slot,
    required PokemonNamedApiResource type,
  }) = _PokemonType;

  factory PokemonType.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeFromJson(json);
}
