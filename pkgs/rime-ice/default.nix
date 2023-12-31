{ lib
, stdenvNoCC
, fetchFromGitHub
, enableUnihan ? true
}:

stdenvNoCC.mkDerivation rec {
  pname = "rime-ice";
  version = "unstable-2023-07-14";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = pname;
    rev = "61d1bb41de307503ba12b7e446f47a572d40e6e0";
    hash = "sha256-GGsZn5zhyy72CQfXNBXyI1TtMFsI/LNeq1+sRyiMAo4=";
  };

  installPhase = ''
    mkdir -p $out/share/rime-data
    ${lib.optionalString enableUnihan ''
      sed -e '9s/^ *# /  /' -i rime_ice.dict.yaml
    ''}
    mv double_pinyin_flypy.schema.yaml rime_ice.schema.yaml \
      liangfen.dict.yaml liangfen.schema.yaml \
      melt_eng.dict.yaml melt_eng.schema.yaml \
      zh-hans-t-essay-bgw.gram \
      rime_ice.dict.yaml \
      symbols_caps_v.yaml symbols_v.yaml \
      cn_dicts/ en_dicts/ \
      opencc lua rime.lua \
      custom_phrase.txt \
      default.yaml \
      $out/share/rime-data
  '';

  meta = with lib; {
    description = "Rime pinyin dict from iDvel";
    homepage = "https://github.com/iDvel/rime-ice";
    license = licenses.gpl3Plus;
  };
}
