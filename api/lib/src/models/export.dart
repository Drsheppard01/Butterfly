import 'package:freezed_annotation/freezed_annotation.dart';

import 'area.dart';

part 'export.freezed.dart';
part 'export.g.dart';

@freezed
sealed class ExportOptions with _$ExportOptions {
  const factory ExportOptions.image({
    required double width,
    required double height,
    @Default(0) double x,
    @Default(0) double y,
    @Default(0) double scale,
    @Default(0) double quality,
    @Default(true) bool renderBackground,
  }) = ImageExportOptions;

  const factory ExportOptions.svg({
    required double width,
    required double height,
    @Default(0) double x,
    @Default(0) double y,
    @Default(true) bool renderBackground,
  }) = SVGExportOptions;
}

@freezed
sealed class ExportPreset with _$ExportPreset {
  const factory ExportPreset({
    @Default('') String name,
    @Default([]) List<AreaPreset> areas,
  }) = _ExportPreset;

  factory ExportPreset.fromJson(Map<String, dynamic> json) =>
      _$ExportPresetFromJson(json);
}

@freezed
sealed class AreaPreset with _$AreaPreset {
  const factory AreaPreset({
    @Default('default') String page,
    @Default('') String name,
    @Default(1) double quality,
    Area? area,
  }) = _AreaPreset;

  factory AreaPreset.fromJson(Map<String, dynamic> json) =>
      _$AreaPresetFromJson(json);
}
