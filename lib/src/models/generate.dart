part of '_models.dart';

class GenerateRequest {
  const GenerateRequest({
    required this.model,
    required this.prompt,
    this.suffix,
    this.images,
    this.format,
    this.options,
    this.system,
    this.template,
    this.stream,
    this.raw,
    this.keepAlive,
    this.context,
  });

  final String model;
  final String prompt;
  final String? suffix;
  final List<String>? images;
  final Format? format;
  final Options? options;
  final String? system;
  final String? template;
  final bool? stream;
  final bool? raw;
  final Duration? keepAlive;
  final List<int>? context;

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'prompt': prompt,
      if (suffix != null) 'suffix': suffix,
      if (images != null) 'images': images,
      if (format != null) 'format': format?.toJson(),
      if (options != null) 'options': options?.toJson(),
      if (system != null) 'system': system,
      if (template != null) 'template': template,
      if (stream != null) 'stream': stream,
      if (raw != null) 'raw': raw,
      if (keepAlive != null) 'keep_alive': durationInMinutesConverter.toJson(keepAlive!),
      if (context != null) 'context': context,
    };
  }
}

class GenerateResponse {
  const GenerateResponse({
    required this.model,
    required this.createdAt,
    required this.response,
    required this.done,
    this.doneReason,
    this.totalDuration,
    this.loadDuration,
    this.promptEvalCount,
    this.promptEvalDuration,
    this.evalCount,
    this.evalDuration,
    this.context,
  });

  final String model;
  final DateTime createdAt;
  final String response;
  final bool done;
  final List<int>? context;
  final String? doneReason;
  final int? totalDuration;
  final int? loadDuration;
  final int? promptEvalCount;
  final int? promptEvalDuration;
  final int? evalCount;
  final int? evalDuration;

  factory GenerateResponse.fromJson(Map<String, dynamic> json) {
    return GenerateResponse(
      model: json['model'] as String,
      createdAt: dateTimeConverter.fromJson(json['created_at'] as String),
      response: json['response'] as String,
      done: json['done'] as bool,
      context: json['context'] == null ? null : (json['context'] as List<dynamic>).map((e) => e as int).toList(),
      doneReason: json['done_reason'] as String?,
      totalDuration: json['total_duration'] as int?,
      loadDuration: json['load_duration'] as int?,
      promptEvalCount: json['prompt_eval_count'] as int?,
      promptEvalDuration: json['prompt_eval_duration'] as int?,
      evalCount: json['eval_count'] as int?,
      evalDuration: json['eval_duration'] as int?,
    );
  }
}
