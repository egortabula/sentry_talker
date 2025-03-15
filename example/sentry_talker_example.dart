import 'dart:async';
import 'package:sentry/sentry.dart';
import 'package:sentry_talker/sentry_talker.dart';
import 'package:talker/talker.dart';

// Create a Talker instance
final talker = Talker();

Future<void> main() async {
  // ATTENTION: Change the DSN below with your own to see the events in Sentry. Get one at sentry.io
  const dsn =
      'https://e85b375ffb9f43cf8bdf9787768149e0@o447951.ingest.sentry.io/5428562';

  await Sentry.init(
    (options) {
      options.dsn = dsn;

      // Add TalkerIntegration
      options.addIntegration(
        TalkerIntegration(talker: talker),
      );
    },
    appRunner: runApp,
  );
}

Future<void> runApp() async {
  talker.warning('this is a warning!');

  try {
    throw Exception();
  } catch (error, stackTrace) {
    // The log from above will be contained in this crash report.
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
    );
  }
}
