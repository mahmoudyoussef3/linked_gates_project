// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  price: ProductModel._priceFromJson(json['price']),
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  description: json['description'] as String? ?? '',
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': ProductModel._priceToJson(instance.price),
      'images': instance.images,
      'description': instance.description,
    };
