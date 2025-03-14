import 'package:sentry_talker/src/extension.dart';
import 'package:talker/talker.dart';
import 'package:test/test.dart';

void main() {
  test('breadcrumb time is always utc', () {
    final log = TalkerData(
      'foo bar',
      logLevel: LogLevel.info,
    );

    expect(log.toBreadcrumb().timestamp.isUtc, true);
  });

  test('event time is always utc', () {
    final log = TalkerData(
      'foo bar',
      logLevel: LogLevel.info,
    );

    expect(log.toEvent().timestamp?.isUtc, true);
  });
}
