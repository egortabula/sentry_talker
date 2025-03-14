// ignore_for_file: unnecessary_statements

mixin NoSuchMethodProvider {
  @override
  void noSuchMethod(Invocation invocation) {
    'Method ${invocation.memberName} was called '
        'with arguments ${invocation.positionalArguments}';
  }
}
