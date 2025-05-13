import 'package:ollama_api/ollama_api.dart' as ollama;

Future<void> main() async {
  final api = ollama.Api.http();

  final resp = await api.generate(
    'Compose a haiku',
    model: 'gemma3:latest',
  );

  print(resp.response);
}
