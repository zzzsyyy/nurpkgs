{ symlinkJoin
, megasync
, makeWrapper
}:
symlinkJoin {
  name = "megasync";
  paths = [ megasync ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/megasync --prefix QT_SCALE_FACTOR : 1
  '';
}
