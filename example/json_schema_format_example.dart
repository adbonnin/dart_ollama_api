import 'dart:convert';

import 'package:ollama_api/ollama_api.dart' as ollama;

Future<void> main() async {
  final api = ollama.Api.http();

  final schema = ollama.Json.object(
    properties: {
      'haiku': ollama.Json.string(),
      'theme': ollama.Json.string(),
      'keywords': ollama.Json.array(items: ollama.Json.string()),
      'inspiration': ollama.Json.string(),
    },
    required: [
      'haiku',
      'theme',
      'keywords',
      'inspiration',
    ],
  );

  final prompt = '''
    Compose a haiku.
    
    Respond in the following JSON format:
    {
      "haiku": "Line one\nLine two\nLine three", 
      "theme": "A concise (1-2 sentence) description of the main theme or subject of the haiku", 
      "keywords": "A list of 3-5 keywords related to the haiku's subject and imagery",
      "inspiration": "A short (1-2 sentence) note about the source of inspiration for the haiku"
    }
  ''';

  final resp = await api.generate(
    prompt,
    model: 'gemma3:latest',
    format: ollama.Format.jsonSchema(schema),
  );

  final json = jsonDecode(resp.response) as Map<String, dynamic>;
  print(json['haiku']);
  print('Theme: ${json['theme']}');
  print('Keywords: ${json['keywords']}');
  print('Inspiration: ${json['inspiration']}');
}
