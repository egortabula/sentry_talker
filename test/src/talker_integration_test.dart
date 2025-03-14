import 'package:sentry/sentry.dart';
import 'package:sentry_talker/src/talker_integration.dart';
import 'package:sentry_talker/src/version.dart';
import 'package:talker/talker.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'mock_hub.dart';

void main() {
  late Fixture fixture;
  setUp(() {
    fixture = Fixture();
  });

  test('options.sdk.integrations contains $TalkerIntegration', () async {
    final sut = fixture.createSut()..call(fixture.hub, fixture.options);
    await sut.close();
    expect(
      fixture.options.sdk.integrations.contains('TalkerIntegration'),
      true,
    );
  });

  test('options.sdk.integrations contains version', () async {
    final sut = fixture.createSut()..call(fixture.hub, fixture.options);
    await sut.close();

    final package =
        fixture.options.sdk.packages.firstWhere((it) => it.name == packageName);
    expect(package.name, packageName);
    expect(package.version, sdkVersion);
  });

  test('logger gets recorded if level over minlevel', () async {
    final sut = fixture.createSut(minBreadcrumbLevel: LogLevel.debug)
      ..call(fixture.hub, fixture.options);

    sut.talker.warning('A log message');

    await Future<void>.delayed(Duration.zero);

    expect(fixture.hub.events.length, 0);
    expect(fixture.hub.breadcrumbs.length, 1);
    final crumb = fixture.hub.breadcrumbs.first.breadcrumb;
    expect(crumb.level, SentryLevel.warning);
    expect(crumb.message, 'A log message');
    // expect(crumb.data, <String, dynamic>{
    //   'LogRecord.loggerName': 'FooBarLogger',
    //   'LogRecord.sequenceNumber': isNotNull,
    // });
    expect(crumb.timestamp, isNotNull);
    expect(crumb.category, 'log');
    expect(crumb.type, 'debug');
  });

  test('logger gets recorded if level equal minlevel', () async {
    final sut = fixture.createSut()..call(fixture.hub, fixture.options);
    sut.talker.info('A log message');
    await Future<void>.delayed(Duration.zero);

    expect(fixture.hub.events.length, 0);
    expect(fixture.hub.breadcrumbs.length, 1);
  });

  test('passes log records as hints', () async {
    final sut = fixture.createSut(minEventLevel: LogLevel.warning)
      ..call(fixture.hub, fixture.options);
    sut.talker.info('An info message');

    await Future<void>.delayed(Duration.zero);

    expect(fixture.hub.breadcrumbs.length, 1);
    final breadcrumbHint =
        fixture.hub.breadcrumbs.first.hint?.get('record') as TalkerData;

    expect(breadcrumbHint.logLevel, LogLevel.info);
    expect(breadcrumbHint.message, 'An info message');

    final exception = Exception('foo bar');
    final stackTrace = StackTrace.current;
    sut.talker.warning('A log message', exception, stackTrace);

    await Future<void>.delayed(Duration.zero);

    expect(fixture.hub.events.length, 1);
    final errorHint =
        fixture.hub.events.first.hint?.get('record') as TalkerData;

    expect(errorHint.logLevel, LogLevel.warning);
    expect(errorHint.message, 'A log message');
    expect(errorHint.exception, exception);
    expect(errorHint.stackTrace, stackTrace);
  });

  test('logger gets not recorded if level under minlevel', () {
    final sut = fixture.createSut(minBreadcrumbLevel: LogLevel.error)
      ..call(fixture.hub, fixture.options);

    sut.talker.warning('A log message');

    expect(fixture.hub.events.length, 0);
    expect(fixture.hub.breadcrumbs.length, 0);
  });

  test('exception is recorded as event if minEventLevel over minlevel',
      () async {
    final sut = fixture.createSut(minEventLevel: LogLevel.info)
      ..call(fixture.hub, fixture.options);

    final exception = Exception('foo bar');
    final stackTrace = StackTrace.current;

    sut.talker.warning('A log message', exception, stackTrace);

    await Future<void>.delayed(Duration.zero);

    expect(fixture.hub.events.length, 1);
    expect(fixture.hub.events.first.event.breadcrumbs, null);
    final event = fixture.hub.events.first.event;
    expect(event.level, SentryLevel.warning);
    expect(event.throwable, exception);
    // ignore: deprecated_member_use
    expect(fixture.hub.events.first.stackTrace, stackTrace);
  });

  test('exception is recorded as event if minEventLevel equal minlevel',
      () async {
    final sut = fixture.createSut(minEventLevel: LogLevel.info)
      ..call(fixture.hub, fixture.options);

    final exception = Exception('foo bar');
    final stackTrace = StackTrace.current;

    sut.talker.info(
      'A log message',
      exception,
      stackTrace,
    );

    await Future<void>.delayed(Duration.zero);

    expect(fixture.hub.events.length, 1);
    expect(fixture.hub.events.first.event.breadcrumbs, null);
  });

  test('exception is not recorded as event if minEventLevel under minlevel',
      () {
    final sut = fixture.createSut()..call(fixture.hub, fixture.options);

    final exception = Exception('foo bar');
    final stackTrace = StackTrace.current;

    sut.talker.warning(
      'A log message',
      exception,
      stackTrace,
    );
    expect(fixture.hub.events.length, 0);
  });
}

class Fixture {
  SentryOptions options = defaultTestOptions();
  MockHub hub = MockHub();
  final Talker talker = Talker();

  TalkerIntegration createSut({
    LogLevel minBreadcrumbLevel = LogLevel.info,
    LogLevel minEventLevel = LogLevel.error,
  }) {
    return TalkerIntegration(
      minBreadcrumbLevel: minBreadcrumbLevel,
      minEventLevel: minEventLevel,
      talker: talker,
    );
  }
}
