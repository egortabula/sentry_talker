// ignore_for_file: comment_references

import 'dart:async';

import 'package:sentry/sentry.dart';
import 'package:sentry_talker/src/extension.dart';
import 'package:sentry_talker/src/version.dart';
import 'package:talker/talker.dart';

/// An [Integration] which listens to all messages of the
/// [talker](https://pub.dev/packages/talker) package.
class TalkerIntegration implements Integration<SentryOptions> {
  /// Creates the [TalkerIntegration].
  ///
  /// All log events equal or higher than [minBreadcrumbLevel] are recorded as a
  /// [Breadcrumb].
  /// All log events equal or higher than [minEventLevel] are recorded as a
  /// [SentryEvent].
  TalkerIntegration({
    required this.talker,
    LogLevel minBreadcrumbLevel = LogLevel.info,
    LogLevel minEventLevel = LogLevel.error,
    this.captureRouteEvents = false,
    this.captureHttpErrorEvents = false,
    this.captureHttpRequestEvents = false,
    this.captureHttpResponseEvents = false,
  })  : _minBreadcrumbLevel = minBreadcrumbLevel,
        _minEventLevel = minEventLevel;

  /// [Talker] instance
  final Talker talker;
  final LogLevel _minBreadcrumbLevel;
  final LogLevel _minEventLevel;

  /// Flag to capture route events.
  ///
  /// If set to `true`, route events (navigation related) will be captured.
  /// If you are using [SentryNavigatorObserver], it is recommended to keep this
  /// flag set to `false` to avoid duplicating route events.
  final bool captureRouteEvents;

  /// Flag to capture HTTP error events.
  ///
  /// If set to `true`, HTTP error events will be captured.
  /// If you are using [sentry_dio](https://pub.dev/packages/sentry_dio)
  /// or other packages for logging HTTP requests,
  /// it is recommended to set this flag to `false` to avoid duplicating
  /// HTTP error events.
  final bool captureHttpErrorEvents;

  /// Flag to capture HTTP request events.
  ///
  /// If set to `true`, HTTP request events will be captured.
  /// If you are using [sentry_dio](https://pub.dev/packages/sentry_dio)
  /// or other packages for logging HTTP requests it is recommended to set
  /// this flag to `false` to avoid duplicating
  /// HTTP request events.
  final bool captureHttpRequestEvents;

  /// Flag to capture HTTP response events.
  ///
  /// If set to `true`, HTTP response events will be captured.
  /// If you are using [sentry_dio](https://pub.dev/packages/sentry_dio)
  /// or other packages for logging HTTP requests it is recommended to set
  /// this flag to `false` to avoid duplicating
  /// HTTP response events.
  final bool captureHttpResponseEvents;
  late StreamSubscription<TalkerData> _subscription;
  late Hub _hub;

  @override
  void call(Hub hub, SentryOptions options) {
    _hub = hub;
    _subscription = talker.stream.listen(
      (record) {
        if (record.key == TalkerLogType.route.key && !captureRouteEvents) {
          return;
        }
        if (record.key == TalkerLogType.httpError.key &&
            !captureHttpErrorEvents) {
          return;
        }
        if (record.key == TalkerLogType.httpRequest.key &&
            !captureHttpRequestEvents) {
          return;
        }
        if (record.key == TalkerLogType.httpResponse.key &&
            !captureHttpResponseEvents) {
          return;
        }
        _onLog(record);
      },
      onError: (Object error, StackTrace stackTrace) async {
        await _hub.captureException(error, stackTrace: stackTrace);
      },
    );
    options.sdk.addPackage(packageName, sdkVersion);
    options.sdk.addIntegration('TalkerIntegration');
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
  }

  bool _isLoggable(LogLevel logLevel, LogLevel minLevel) {
    final levelPriorityList = logLevelPriorityList.reversed.toList();
    final logLevelIndex = levelPriorityList.indexOf(logLevel);
    final minLevelIndex = levelPriorityList.indexOf(minLevel);

    final isLoggable = logLevelIndex >= minLevelIndex;
    return isLoggable;
  }

  Future<void> _onLog(TalkerData record) async {
    // The event must be logged first, otherwise the log would also be added
    // to the breadcrumbs for itself.
    if (_isLoggable(record.logLevel!, _minEventLevel)) {
      await _hub.captureEvent(
        record.toEvent(),
        stackTrace: record.stackTrace,
        hint: Hint.withMap({TypeCheckHint.record: record}),
      );
    }

    if (_isLoggable(record.logLevel!, _minBreadcrumbLevel)) {
      await _hub.addBreadcrumb(
        record.toBreadcrumb(),
        hint: Hint.withMap({TypeCheckHint.record: record}),
      );
    }
  }
}
