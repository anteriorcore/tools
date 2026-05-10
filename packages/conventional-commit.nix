{
  gnugrep,
  glibcLocales,
  lib,
  writeShellApplication,
}:
writeShellApplication {
  name = "conventional-commit";
  meta.description = "grep for valid conventional commit message header";
  runtimeInputs = [ gnugrep ];
  runtimeEnv = {
    LANG = "en_US.UTF-8";
  }
  // lib.optionalAttrs (glibcLocales != null) {
    # Don’t ask me how I figured this out 😭 - Robin
    LOCALE_ARCHIVE = "${lib.getLib glibcLocales}/lib/locale/locale-archive";
  };
  text = ''
    exec grep -P '^(build|chore|ci|docs|feat|fix|perf|p?refactor|revert|style|test)(\([\w/-]+\))?!?: '
  '';
  derivationArgs.postCheck = ''
    (
      set -x
      echo 'build: blabla' | $target
      echo 'chore: blabla' | $target
      echo 'ci: blabla' | $target
      echo 'docs: blabla' | $target
      echo 'feat: blabla' | $target
      echo 'fix: blabla' | $target
      echo 'perf: blabla' | $target
      echo 'refactor: blabla' | $target
      echo 'prefactor: blabla' | $target
      echo 'revert: blabla' | $target
      echo 'style: blabla' | $target
      echo 'test: blabla' | $target

      echo 'feat(foo): bar' | $target
      echo 'feat(123): bar' | $target
      echo 'feat(世界): bar' | $target
      echo 'feat!: bar' | $target
      echo 'feat(foo)!: bar' | $target
      echo 'feat(foo-bar): baz' | $target
      echo 'feat(foo_bar): bar' | $target
      echo 'feat(FooBar): bar' | $target
      echo 'feat(foo/bar): bar' | $target

      ! echo 'foobar' | $target
      ! echo 'lala: blabla' | $target
      ! echo 'feat:foo' | $target
      ! echo ' feat: foobar' | $target
      ! echo 'Feat: foobar' | $target
      ! echo 'feat/foobar' | $target
    )
  '';
}
