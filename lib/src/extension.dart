// ignore_for_file: public_member_api_docs

import 'package:sentry/sentry.dart';
import 'package:talker/talker.dart';

extension TalkerDataX on TalkerData {
  Breadcrumb toBreadcrumb() {
    return Breadcrumb(
      category: 'log',
      type: 'debug',
      timestamp: time.toUtc(),
      level: logLevel?.toSentryLevel(),
      message: message,
      data: <String, Object>{
        if (exception != null) 'LogRecord.error': exception!,
        if (stackTrace != null) 'LogRecord.stackTrace': stackTrace!,
      },
    );
  }

  SentryEvent toEvent() {
    return SentryEvent(
      timestamp: time.toUtc(),
      level: logLevel?.toSentryLevel(),
      message: SentryMessage(message ?? 'No message'),
      throwable: exception,
      // ignore: deprecated_member_use
      extra: const <String, Object>{
        // if (object != null) 'LogRecord.object': object!,
        // 'LogRecord.sequenceNumber': sequenceNumber,
      },
    );
  }
}

extension LogLevelX on LogLevel {
  SentryLevel? toSentryLevel() {
    return <LogLevel, SentryLevel?>{
      LogLevel.verbose: SentryLevel.debug,
      LogLevel.debug: SentryLevel.debug,
      LogLevel.info: SentryLevel.info,
      LogLevel.warning: SentryLevel.warning,
      LogLevel.error: SentryLevel.error,
      LogLevel.critical: SentryLevel.fatal,
    }[this];
  }
}
