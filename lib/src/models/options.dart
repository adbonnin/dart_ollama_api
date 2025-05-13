part of '_models.dart';

class Runner {
  const Runner({
    this.numCtx,
    this.numBatch,
    this.numGpu,
    this.mainGpu,
    this.useMmap,
    this.numThread,
  });

  final int? numCtx;
  final int? numBatch;
  final int? numGpu;
  final int? mainGpu;
  final bool? useMmap;
  final int? numThread;

  Map<String, dynamic> toJson() {
    return {
      if (numCtx != null) 'num_ctx': numCtx,
      if (numBatch != null) 'num_batch': numBatch,
      if (numGpu != null) 'num_gpu': numGpu,
      if (mainGpu != null) 'main_gpu': mainGpu,
      if (useMmap != null) 'use_mmap': useMmap,
      if (numThread != null) 'num_thread': numThread,
    };
  }
}

// https://github.com/ollama/ollama/blob/main/docs/modelfile.md#valid-parameters-and-values
class Options extends Runner {
  const Options({
    this.numKeep,
    this.seed,
    this.numPredict,
    this.topK,
    this.topP,
    this.minP,
    this.typicalP,
    this.repeatLastN,
    this.temperature,
    this.repeatPenalty,
    this.presencePenalty,
    this.frequencyPenalty,
    this.stop,
  });

  final int? numKeep;
  final int? seed;
  final int? numPredict;
  final int? topK;
  final double? topP;
  final double? minP;
  final double? typicalP;
  final int? repeatLastN;
  final double? temperature;
  final double? repeatPenalty;
  final double? presencePenalty;
  final double? frequencyPenalty;
  final List<String>? stop;

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      if (numKeep != null) 'num_keep': numKeep,
      if (seed != null) 'seed': seed,
      if (numPredict != null) 'numPredict': numPredict,
      if (topK != null) 'top_k': topK,
      if (topP != null) 'top_p': topP,
      if (minP != null) 'min_p': minP,
      if (typicalP != null) 'typical_p': typicalP,
      if (repeatLastN != null) 'repeat_last_n': repeatLastN,
      if (temperature != null) 'temperature': temperature,
      if (repeatPenalty != null) 'repeat_penalty': repeatPenalty,
      if (presencePenalty != null) 'presence_penalty': presencePenalty,
      if (frequencyPenalty != null) 'frequency_penalty': frequencyPenalty,
      if (stop != null) 'stop': stop,
    };
  }
}
