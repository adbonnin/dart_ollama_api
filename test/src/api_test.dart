import 'dart:convert';

import 'package:nock/nock.dart';
import 'package:ollama_api/ollama_api.dart' as ollama;
import 'package:test/test.dart';

void main() {
  setUpAll(nock.init);
  setUp(nock.cleanAll);

  group('ollama.Api.generateStream', () {
    test('should stream a structured response from a prompt until done', () async {
      const model = 'llama3.2';
      const prompt = 'Why is the sky blue?';
      const createdAt = '2023-08-04T08:52:19.385406455-07:00';

      // given:
      final api = ollama.Api.http();

      // and:
      final requestBody = {
        'model': model,
        'prompt': prompt,
      };

      final responseChunks = [
        {
          'model': model,
          'created_at': createdAt,
          'response': 'The',
          'done': false,
        },
        {
          'model': model,
          'created_at': createdAt,
          'response': 'sky',
          'done': false,
        },
        {
          'model': model,
          'created_at': createdAt,
          'response': 'is blue.',
          'done': true,
        }
      ];

      final interceptor = nock('http://localhost:11434').post('/api/generate', requestBody) //
        ..reply(200, responseChunks.map((c) => jsonEncode(c)).join('\n'));

      // when:
      final resp = await api.generateStream(prompt, model: model).toList();

      // then:
      expect(interceptor.isDone, isTrue);
      expect(resp, hasLength(3));

      for (int i = 0; i < responseChunks.length; i++) {
        final chunk = responseChunks[i];
        final item = resp[i];

        expect(item.model, equals(chunk['model']));
        expect(item.createdAt, equals(DateTime.parse(chunk['created_at'] as String)));
        expect(item.response, equals(chunk['response']));
        expect(item.done, equals(chunk['done']));
      }
    });
  });

  group('ollama.Api.generate', () {
    test('should generate a structured response from a prompt', () async {
      const model = 'llama3.2';
      const prompt = 'Why is the sky blue?';

      const createdAt = '2023-08-04T19:22:45.499127Z';
      const response = 'The sky is blue because it is the color of the sky.';
      const done = true;
      const context = [1, 2, 3];
      const totalDuration = 5043500667;
      const loadDuration = 5025959;
      const promptEvalCount = 26;
      const promptEvalDuration = 325953000;
      const evalCount = 290;
      const evalDuration = 4709213000;

      // given:
      final api = ollama.Api.http();

      // and:
      final requestBody = {
        'model': model,
        'prompt': prompt,
        'stream': false,
      };

      final responseBody = {
        'model': model,
        'created_at': createdAt,
        'response': response,
        'done': done,
        'context': context,
        'total_duration': totalDuration,
        'load_duration': loadDuration,
        'prompt_eval_count': promptEvalCount,
        'prompt_eval_duration': promptEvalDuration,
        'eval_count': evalCount,
        'eval_duration': evalDuration,
      };

      final interceptor = nock('http://localhost:11434').post('/api/generate', requestBody) //
        ..reply(200, responseBody);

      // when:
      final resp = await api.generate(prompt, model: model);

      // then:
      expect(interceptor.isDone, isTrue);
      expect(resp.model, model);
      expect(resp.createdAt, DateTime.parse(createdAt));
      expect(resp.response, response);
      expect(resp.context, context);
      expect(resp.doneReason, isNull);
      expect(resp.totalDuration, totalDuration);
      expect(resp.loadDuration, loadDuration);
      expect(resp.promptEvalCount, promptEvalCount);
      expect(resp.promptEvalDuration, promptEvalDuration);
      expect(resp.evalCount, evalCount);
      expect(resp.evalDuration, evalDuration);
    });
  });
}
