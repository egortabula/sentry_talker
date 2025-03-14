@TestOn('vm')
library;

import 'dart:io';

import 'package:sentry_talker/src/version.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart' as yaml;
import 'package:yaml/yaml.dart';

void main() {
  test(
    'sdkVersion matches that of pubspec.yaml',
    () {
      final pubspec =
          yaml.loadYaml(File('pubspec.yaml').readAsStringSync()) as YamlMap;
      expect(sdkVersion, pubspec['version']);
    },
  );
}
