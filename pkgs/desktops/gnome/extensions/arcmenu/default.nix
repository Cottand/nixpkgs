{ lib, stdenv, fetchFromGitLab, glib, gettext, substituteAll, gnome-menus }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-arcmenu";
  version = "14";

  src = fetchFromGitLab {
    owner = "arcmenu";
    repo = "ArcMenu";
    rev = "v${version}";
    sha256 = "sha256-Iobu5eNWSvAiTRe6wyx/0PgUtB9QIC9KdH0M1xhsM1I=";
  };

  patches = [
    (substituteAll {
      src = ./fix_gmenu.patch;
      gmenu_path = "${gnome-menus}/lib/girepository-1.0";
    })
  ];

  buildInputs = [
    glib gettext
  ];

  makeFlags = [ "INSTALLBASE=${placeholder "out"}/share/gnome-shell/extensions" ];

  passthru = {
    extensionUuid = "arcmenu@arcmenu.com";
    extensionPortalSlug = "arcmenu";
  };

  meta = with lib; {
    description = "Application menu for GNOME Shell, designed to provide a more traditional user experience and workflow";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dkabot ];
    homepage = "https://gitlab.com/arcmenu/ArcMenu";
  };
}
