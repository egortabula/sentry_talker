<!-- # Sentry Talker

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link] -->


<p align="center">
  <a href="https://sentry.io" target="_blank" align="center">
    <img src="https://sentry-brand.storage.googleapis.com/sentry-logo-black.png" width="280">
  </a>
  <br />
</p>

Sentry integration for `talker` package
===========

| package | license | pub | likes | popularity | pub points |
| ------- | ------- | ------- | ------- | ------- | ------- |
| sentry_talker | [![License: MIT][license_badge]][license_link] | [![pub package](https://img.shields.io/pub/v/sentry_talker.svg)](https://pub.dev/packages/sentry_talker) | [![likes](https://img.shields.io/pub/likes/sentry_talker)](https://pub.dev/packages/sentry_talker/score) | [![popularity](https://img.shields.io/pub/popularity/sentry_talker)](https://pub.dev/packages/sentry_talker/score) | [![pub points](https://img.shields.io/pub/points/sentry_talker)](https://pub.dev/packages/sentry_talker/score)

Integration for the [`talker`](https://pub.dev/packages/talker) package.

#### Usage

- Sign up for a Sentry.io account and get a DSN at https://sentry.io.

- Follow the installing instructions on [pub.dev](https://pub.dev/packages/sentry/install).

- Initialize the Sentry SDK using the DSN issued by Sentry.io and add the `TalkerIntegration`

```dart
import 'package:sentry/sentry.dart';
import 'package:sentry_talker/sentry_talker.dart';

Future<void> main() async {
  await Sentry.init(
    (options) {
      options.dsn = 'https://example@sentry.io/example';
      options.addIntegration(TalkerIntegration());
    },
    appRunner: initApp, // Init your App.
  );
}

void initApp() {
  // your app code
}
```

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
[cpverage]: coverage_badge.svg