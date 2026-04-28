import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/product_entity.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.images,
    required this.description,
  });

  final int id;
  final String title;

  @JsonKey(fromJson: _priceFromJson, toJson: _priceToJson)
  final double price;

  @JsonKey(defaultValue: <String>[])
  final List<String> images;

  @JsonKey(defaultValue: '')
  final String description;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  ProductEntity toEntity() {
    final imageUrl = images.isNotEmpty ? images.first : '';
    return ProductEntity(
      id: id,
      title: title,
      price: price,
      imageUrl: imageUrl,
      description: description,
    );
  }

  static double _priceFromJson(Object? json) {
    if (json is num) {
      return json.toDouble();
    }
    if (json is String) {
      return double.tryParse(json) ?? 0;
    }
    return 0;
  }

  static Object _priceToJson(double value) => value;
}
