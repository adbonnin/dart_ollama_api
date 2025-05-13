import 'dart:convert';

import 'package:ollama_api/ollama_api.dart' as ollama;

Future<void> main() async {
  final api = ollama.Api.http();

  final schema = ollama.Json.object(
    properties: {
      'haiku': ollama.Json.string(),
      'theme': ollama.Json.string(),
      'keywords': ollama.Json.array(items: ollama.Json.string()),
      'syllable_count': ollama.Json.array(items: ollama.Json.integer()),
    },
    required: [
      'haiku',
      'theme',
      'keywords',
      'syllable_count',
    ],
  );

  final resp = await api.generate(
    'Compose a haiku. Respond using JSON',
    model: 'gemma3:latest',
    format: ollama.Format.jsonSchema(schema),
  );

  final json = jsonDecode(resp.response) as Map<String, dynamic>;
  print(json['haiku']);
  print('Theme: ${json['theme']}');
  print('Keywords: ${json['keywords']}');
  print('Syllable count: ${json['syllable_count']}');
}
