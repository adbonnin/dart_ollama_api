part of '_models.dart';

abstract class Format {
  const factory Format.json() = JsonFormat;

  const factory Format.jsonSchema(Json schema) = JsonSchemaFormat;

  dynamic toJson();
}

class JsonFormat implements Format {
  const JsonFormat();

  @override
  dynamic toJson() {
    return 'json';
  }
}

class JsonSchemaFormat implements Format {
  const JsonSchemaFormat(this.schema);

  final Json schema;

  @override
  dynamic toJson() {
    return schema.toJson();
  }
}
