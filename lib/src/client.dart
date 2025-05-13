import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class ApiClient {
  factory ApiClient.http({
    Uri? baseUri,
    http.Client? httpClient,
  }) {
    return HttpApiClient(baseUri ?? Uri.http('localhost:11434'), httpClient);
  }

  Future<Map<String, dynamic>> sendRequest(
    String path,
    Map<String, dynamic> body,
  );

  Stream<Map<String, dynamic>> streamRequest(
    String path,
    Map<String, dynamic> body,
  );
}

final _utf8Json = json.fuse(utf8);

class HttpApiClient implements ApiClient {
  const HttpApiClient(
    Uri baseUri, [
    http.Client? httpClient,
  ])  : _baseUri = baseUri,
        _httpClient = httpClient;

  final http.Client? _httpClient;
  final Uri _baseUri;

  final _headers = const {
    'Content-Type': 'application/json',
  };

  @override
  Future<Map<String, dynamic>> sendRequest(
    String path,
    Map<String, dynamic> body,
  ) async {
    final url = _buildUrl(path);

    final response = await (_httpClient?.post ?? http.post)(
      url,
      headers: _headers,
      body: _utf8Json.encode(body),
    );

    if (!response.isSuccess) {
      throw ApiException.fromResponse(response);
    }

    return _utf8Json.decode(response.bodyBytes) as Map<String, dynamic>;
  }

  @override
  Stream<Map<String, dynamic>> streamRequest(
    String path,
    Map<String, dynamic> body,
  ) async* {
    final url = _buildUrl(path);

    final request = http.Request('POST', url)
      ..bodyBytes = _utf8Json.encode(body)
      ..headers.addAll(_headers);

    final streamResponse = await (_httpClient?.send(request) ?? request.send());

    if (!streamResponse.isSuccess) {
      final response = await http.Response.fromStream(streamResponse);
      throw ApiException.fromResponse(response);
    }

    yield* streamResponse.stream //
        .toStringStream()
        .transform(const LineSplitter())
        .map((jsonText) => jsonDecode(jsonText) as Map<String, dynamic>);
  }

  Uri _buildUrl(String path) {
    return _baseUri.replace(
      pathSegments: _baseUri.pathSegments.followedBy(path.split('/')),
    );
  }
}

class ApiException {
  const ApiException(
    this.url,
    this.statusCode,
    this.reasonPhrase, {
    this.error,
  });

  factory ApiException.fromResponse(http.Response response) {
    final body = utf8.decode(response.bodyBytes);
    String? error;

    if (body.isNotEmpty) {
      try {
        final decodedBody = jsonDecode(body);

        if (decodedBody is Map<String, dynamic>) {
          error = decodedBody['error'] as String?;
        }
      } //
      catch (e) {
        // Fail to parse as Json
      }

      error ??= body;
    }

    return ApiException(
      response.request?.url,
      response.statusCode,
      response.reasonPhrase,
      error: error,
    );
  }

  final Uri? url;
  final int statusCode;
  final String? reasonPhrase;
  final String? error;

  @override
  String toString() {
    return 'ApiException($statusCode, $reasonPhrase, url: $url, error: $error)';
  }
}

extension ResponseSuccessExtension on http.BaseResponse {
  bool get isSuccess {
    return statusCode >= 200 && statusCode < 400;
  }
}
