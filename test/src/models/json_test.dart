import 'package:ollama_api/ollama_api.dart' as ollama;
import 'package:test/test.dart';

void main() {
  group('ollama.Json serialization', () {
    group('JsonConst', () {
      test('should serialize a const value', () {
        final value = 42;

        // given:
        final json = ollama.Json.const$(value);

        // expect:
        expect(
          json.toJson(),
          {
            'const': value,
          },
        );
      });
    });

    group('JsonEnum', () {
      test('should serialize an enum with mixed values', () {
        final values = [null, 1, 'a'];

        // given:
        final json = ollama.Json.enum$(values);

        // expect:
        expect(
          json.toJson(),
          {
            'enum': values,
          },
        );
      });
    });

    group('JsonNull', () {
      test('should serialize a null type', () {
        // given:
        final json = ollama.Json.null$();

        // expect:
        expect(
          json.toJson(),
          {
            'type': 'null',
          },
        );
      });
    });

    group('JsonBoolean', () {
      test('should serialize a boolean type', () {
        // given:
        final json = ollama.Json.boolean();

        // expect:
        expect(
          json.toJson(),
          {
            'type': 'boolean',
          },
        );
      });
    });

    group('JsonInteger', () {
      test('should serialize a basic integer type without constraints', () {
        // given:
        final json = ollama.Json.integer();

        // expect:
        expect(
          json.toJson(),
          {
            'type': 'integer',
          },
        );
      });

      test('should serialize integer with range constraints', () {
        final minimum = 10;
        final exclusiveMinimum = true;
        final maximum = 100;
        final exclusiveMaximum = false;

        // given:
        final json = ollama.Json.integer(
          minimum: minimum,
          exclusiveMinimum: exclusiveMinimum,
          maximum: maximum,
          exclusiveMaximum: exclusiveMaximum,
        );

        // expect:
        expect(
          json.toJson(),
          {
            'type': 'integer',
            'minimum': minimum,
            'exclusiveMinimum': exclusiveMinimum,
            'maximum': maximum,
            'exclusiveMaximum': exclusiveMaximum,
          },
        );
      });
    });

    group('JsonNumber', () {
      test('should serialize a basic number type without constraints', () {
        // given:
        final json = ollama.Json.number();

        // expect:
        expect(
          json.toJson(),
          {
            'type': 'number',
          },
        );
      });
    });

    group('JsonString', () {
      test('should serialize a basic string type without constraints', () {
        // given:
        final json = ollama.Json.string();

        // expect:
        expect(
          json.toJson(),
          {
            'type': 'string',
          },
        );
      });

      test('should serialize string with minLength and maxLength constraints', () {
        final minLength = 2;
        final maxLength = 3;

        // given:
        final json = ollama.Json.string(minLength: minLength, maxLength: maxLength);

        // expect:
        expect(
          json.toJson(),
          {
            'type': 'string',
            'minLength': minLength,
            'maxLength': maxLength,
          },
        );
      });

      test('should serialize string with pattern constraint', () {
        final pattern = r'^(\([0-9]{3}\))?[0-9]{3}-[0-9]{4}$';

        // given:
        final json = ollama.Json.string(pattern: pattern);

        // expect:
        expect(
          json.toJson(),
          {
            'type': 'string',
            'pattern': pattern,
          },
        );
      });
    });

    group('JsonArray', () {
      test('should serialize a basic array type without constraints', () {
        // given:
        final json = ollama.Json.array();

        // expect:
        expect(
          json.toJson(),
          {
            'type': 'array',
          },
        );
      });

      test('should serialize array with single item schema (homogeneous items)', () {
        // given:
        final json = ollama.Json.array(items: ollama.Json.number());

        // expect:
        expect(
          json.toJson(),
          {
            'type': 'array',
            'items': {'type': 'number'}
          },
        );
      });

      test('should serialize array as tuple with prefixItems', () {
        final prefixItems = [
          ollama.Json.number(),
          ollama.Json.string(),
          ollama.Json.enum$(['Street', 'Avenue', 'Boulevard']),
          ollama.Json.enum$(['NW', 'NE', 'SW', 'SE']),
        ];

        // given:
        final json = ollama.Json.array(prefixItems: prefixItems);

        // expect:
        expect(
          json.toJson(),
          {
            'type': 'array',
            'prefixItems': [
              {
                'type': 'number',
              },
              {
                'type': 'string',
              },
              {
                'enum': ['Street', 'Avenue', 'Boulevard'],
              },
              {
                'enum': ['NW', 'NE', 'SW', 'SE'],
              }
            ]
          },
        );
      });

      test('should serialize tuple array with allowAdditionalItems = false', () {
        final prefixItems = [
          ollama.Json.number(),
          ollama.Json.string(),
          ollama.Json.enum$(['Street', 'Avenue', 'Boulevard']),
          ollama.Json.enum$(['NW', 'NE', 'SW', 'SE']),
        ];

        // given:
        final json = ollama.Json.array(prefixItems: prefixItems, allowAdditionalItems: false);

        // expect:
        expect(
          json.toJson(),
          {
            'type': 'array',
            'prefixItems': [
              {
                'type': 'number',
              },
              {
                'type': 'string',
              },
              {
                'enum': ['Street', 'Avenue', 'Boulevard'],
              },
              {
                'enum': ['NW', 'NE', 'SW', 'SE'],
              }
            ],
            'items': false
          },
        );
      });
    });

    group('JsonObject', () {
      test('should serialize a basic object without constraints', () {
        // given:
        final json = ollama.Json.object();

        // expect:
        expect(
          json.toJson(),
          {
            'type': 'object',
          },
        );
      });

      test('should serialize object with properties and no additional properties allowed', () {
        final properties = {
          'number': ollama.Json.number(),
          'street_name': ollama.Json.string(),
          'street_type': ollama.Json.enum$(['Street', 'Avenue', 'Boulevard']),
        };

        // given:
        final json = ollama.Json.object(properties: properties, allowAdditionalProperties: false);

        // expect:
        expect(
          json.toJson(),
          {
            'type': 'object',
            'properties': {
              'number': {
                'type': 'number',
              },
              'street_name': {
                'type': 'string',
              },
              'street_type': {
                'enum': ['Street', 'Avenue', 'Boulevard']
              }
            },
            'additionalProperties': false,
          },
        );
      });

      test('should serialize object with additionalProperties as schema', () {
        final properties = {'builtin': ollama.Json.number()};
        final additionalProperties = ollama.Json.string();

        // given:
        final json = ollama.Json.object(properties: properties, additionalProperties: additionalProperties);

        // expect:
        expect(
          json.toJson(),
          {
            'type': 'object',
            'properties': {
              'builtin': {'type': 'number'}
            },
            'additionalProperties': {'type': 'string'},
          },
        );
      });

      test('should serialize object with required properties', () {
        final properties = {
          'name': ollama.Json.string(),
          'email': ollama.Json.string(),
          'address': ollama.Json.string(),
          'telephone': ollama.Json.string(),
        };

        final required = ['name', 'email'];

        // given:
        final json = ollama.Json.object(properties: properties, required: required);

        // expect:
        expect(
          json.toJson(),
          {
            'type': 'object',
            'properties': {
              'name': {'type': 'string'},
              'email': {'type': 'string'},
              'address': {'type': 'string'},
              'telephone': {'type': 'string'},
            },
            'required': ['name', 'email'],
          },
        );
      });
    });
  });
}
