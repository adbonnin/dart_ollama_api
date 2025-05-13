import 'package:http/http.dart' as http;
import 'package:ollama_api/src/client.dart';
import 'package:ollama_api/src/models/_models.dart';

class Api {
  const Api(this.client);

  factory Api.http({
    Uri? baseUri,
    http.Client? httpClient,
  }) {
    return Api(ApiClient.http(
      baseUri: baseUri,
      httpClient: httpClient,
    ));
  }

  final ApiClient client;

  Future<GenerateResponse> generate(
    String prompt, {
    required String model,
    String? suffix,
    List<String>? images,
    Format? format,
    Options? options,
    String? system,
    String? template,
    bool? raw,
    Duration? keepAlive,
    List<int>? context,
  }) async {
    final request = GenerateRequest(
      model: model,
      prompt: prompt,
      suffix: suffix,
      images: images,
      format: format,
      options: options,
      system: system,
      template: template,
      stream: false,
      raw: raw,
      keepAlive: keepAlive,
      context: context,
    );

    final json = await client.sendRequest('api/generate', request.toJson());
    return GenerateResponse.fromJson(json);
  }

  Stream<GenerateResponse> generateStream(
    String prompt, {
    required String model,
    String? suffix,
    List<String>? images,
    Format? format,
    Options? options,
    String? system,
    String? template,
    bool? raw,
    Duration? keepAlive,
    List<int>? context,
  }) async* {
    final request = GenerateRequest(
      model: model,
      prompt: prompt,
      suffix: suffix,
      images: images,
      format: format,
      options: options,
      system: system,
      template: template,
      raw: raw,
      keepAlive: keepAlive,
      context: context,
    );

    final stream = client.streamRequest('api/generate', request.toJson());
    yield* stream.map(GenerateResponse.fromJson);
  }
}
