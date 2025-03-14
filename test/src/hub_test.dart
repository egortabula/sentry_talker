import 'package:flutter_test/flutter_test.dart';
import 'package:sentry/sentry.dart';

import 'talker_integration_test.dart';

void main() {
  late Fixture fixture;

  setUp(() {
    fixture = Fixture();
  });

  test('Test add events', () {
    expect(fixture.hub.events.length, 0);
    expect(fixture.hub.breadcrumbs.length, 0);

    fixture.hub.addBreadcrumb(Breadcrumb(message: 'message'));

    expect(fixture.hub.breadcrumbs.length, 1);
    expect(
      fixture.hub.breadcrumbs.first.breadcrumb.message,
      equals('message'),
    );

    fixture.hub.captureEvent(SentryEvent(eventId: SentryId.newId()));

    expect(fixture.hub.events.length, 1);
  });
}
