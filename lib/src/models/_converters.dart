abstract class JsonConverter<T, S> {
  const JsonConverter();

  T fromJson(S json);

  S toJson(T object);
}

const dateTimeConverter = DateTimeConverter();
const durationInMinutesConverter = DurationInMinutesConverter();

class DateTimeConverter extends JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json);
  }

  @override
  String toJson(DateTime object) {
    return object.toIso8601String();
  }
}

class DurationInMinutesConverter extends JsonConverter<Duration, int> {
  const DurationInMinutesConverter();

  @override
  Duration fromJson(int json) {
    return Duration(minutes: json);
  }

  @override
  int toJson(Duration object) {
    return object.inMinutes;
  }
}
