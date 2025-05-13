part of '_models.dart';

// https://github.com/ollama/ollama/blob/main/llama/llama.cpp/common/json-schema-to-grammar.cpp
abstract class Json {
  const factory Json.enum$(List<dynamic> values) = JsonEnum;

  const factory Json.const$(dynamic value) = JsonConst;

  const factory Json.null$() = JsonNull;

  const factory Json.boolean() = JsonBoolean;

  const factory Json.integer({
    num? minimum,
    bool? exclusiveMinimum,
    num? maximum,
    bool? exclusiveMaximum,
  }) = JsonInteger;

  const factory Json.number() = JsonNumber;

  const factory Json.string({
    int? minLength,
    int? maxLength,
    String? pattern,
  }) = JsonString;

  const factory Json.array({
    Json? items,
    List<Json>? prefixItems,
    bool allowAdditionalItems,
  }) = JsonArray;

  const factory Json.object({
    Map<String, Json>? properties,
    Map<String, Json>? patternProperties,
    Json? additionalProperties,
    bool? allowAdditionalProperties,
    List<String>? required,
  }) = JsonObject;

  Map<String, dynamic> toJson();
}

class JsonEnum implements Json {
  const JsonEnum(this.values);

  final List<dynamic> values;

  @override
  Map<String, dynamic> toJson() {
    return {
      'enum': values,
    };
  }
}

class JsonConst implements Json {
  const JsonConst(this.value);

  final dynamic value;

  @override
  Map<String, dynamic> toJson() {
    return {
      'const': value,
    };
  }
}

class JsonType implements Json {
  const JsonType({required this.type});

  final String type;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
    };
  }
}

// https://json-schema.org/understanding-json-schema/reference/null
class JsonNull extends JsonType {
  const JsonNull() : super(type: 'null');
}

// https://json-schema.org/understanding-json-schema/reference/boolean
class JsonBoolean extends JsonType {
  const JsonBoolean() : super(type: 'boolean');
}

// https://json-schema.org/understanding-json-schema/reference/numeric#integer
class JsonInteger extends JsonType {
  const JsonInteger({
    this.minimum,
    this.exclusiveMinimum,
    this.maximum,
    this.exclusiveMaximum,
  }) : super(type: 'integer');

  final num? minimum;
  final bool? exclusiveMinimum;
  final num? maximum;
  final bool? exclusiveMaximum;

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      if (minimum != null) 'minimum': minimum,
      if (exclusiveMinimum != null) 'exclusiveMinimum': exclusiveMinimum,
      if (maximum != null) 'maximum': maximum,
      if (exclusiveMaximum != null) 'exclusiveMaximum': exclusiveMaximum,
    };
  }
}

// https://json-schema.org/understanding-json-schema/reference/numeric#number
class JsonNumber extends JsonType {
  const JsonNumber() : super(type: 'number');
}

// https://json-schema.org/understanding-json-schema/reference/string
class JsonString extends JsonType {
  const JsonString({
    this.minLength,
    this.maxLength,
    this.pattern,
  }) : super(type: 'string');

  final int? minLength;
  final int? maxLength;
  final String? pattern;

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      if (minLength != null) 'minLength': minLength,
      if (maxLength != null) 'maxLength': maxLength,
      if (pattern != null) 'pattern': pattern,
    };
  }
}

// https://json-schema.org/understanding-json-schema/reference/array
class JsonArray extends JsonType {
  const JsonArray({
    this.items,
    this.prefixItems,
    this.allowAdditionalItems,
  }) : super(type: 'array');

  final Json? items;
  final List<Json>? prefixItems;
  final bool? allowAdditionalItems;

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      if (items != null) 'items': items!.toJson(),
      if (prefixItems != null) 'prefixItems': prefixItems!.map((e) => e.toJson()),
      if (prefixItems != null && allowAdditionalItems == false) 'items': false,
    };
  }
}

class JsonObject extends JsonType {
  const JsonObject({
    this.properties,
    this.patternProperties,
    this.additionalProperties,
    this.allowAdditionalProperties,
    this.required,
  }) : super(type: 'object');

  final Map<String, Json>? properties;
  final Map<String, Json>? patternProperties;
  final Json? additionalProperties;
  final bool? allowAdditionalProperties;
  final List<String>? required;

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      if (properties != null) 'properties': properties!.map((k, v) => MapEntry(k, v.toJson())),
      if (patternProperties != null) 'patternProperties': patternProperties!.map((k, v) => MapEntry(k, v.toJson())),
      if (additionalProperties != null) 'additionalProperties': additionalProperties!.toJson(),
      if (allowAdditionalProperties == false) 'additionalProperties': false,
      if (required != null) 'required': required,
    };
  }
}
