// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'ranking_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_RankingMember _$$_RankingMemberFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$_RankingMember',
      json,
      ($checkedConvert) {
        final val = _$_RankingMember(
          createdAt: $checkedConvert(
              'created_at',
              (v) => _$JsonConverterFromJson<Timestamp, DateTime>(
                  v, const TimestampConverter().fromJson)),
          updatedAt: $checkedConvert(
              'updated_at',
              (v) => _$JsonConverterFromJson<Timestamp, DateTime>(
                  v, const TimestampConverter().fromJson)),
          order: $checkedConvert('order', (v) => (v as num).toDouble()),
          title: $checkedConvert('title', (v) => v as String),
          description:
              $checkedConvert('description', (v) => v as String? ?? ''),
          imageUrl: $checkedConvert('image_url', (v) => v as String?),
          thumbnailUrl: $checkedConvert('thumbnail_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'createdAt': 'created_at',
        'updatedAt': 'updated_at',
        'imageUrl': 'image_url',
        'thumbnailUrl': 'thumbnail_url'
      },
    );

Map<String, dynamic> _$$_RankingMemberToJson(_$_RankingMember instance) =>
    <String, dynamic>{
      'created_at': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.createdAt, const TimestampConverter().toJson),
      'updated_at': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.updatedAt, const TimestampConverter().toJson),
      'order': instance.order,
      'title': instance.title,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'thumbnail_url': instance.thumbnailUrl,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
