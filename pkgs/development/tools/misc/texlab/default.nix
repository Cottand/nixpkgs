{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, help2man
, installShellFiles
, libiconv
, Security
, CoreServices
, nix-update-script
}:

let
  isCross = stdenv.hostPlatform != stdenv.buildPlatform;
in
rustPlatform.buildRustPackage rec {
  pname = "texlab";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = "texlab";
    rev = "refs/tags/v${version}";
    hash = "sha256-GvORAPbQOdVpz4yY66b3OObewU98V26cZ6nrJ35nlkg=";
  };

  cargoHash = "sha256-b7v3ODOjY5BQCzVqlLCNUOaZS95AvIvyjOeas2XfRjM=";

  outputs = [ "out" ] ++ lib.optional (!isCross) "man";

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optional (!isCross) help2man;

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    Security
    CoreServices
  ];

  # When we cross compile we cannot run the output executable to
  # generate the man page
  postInstall = lib.optionalString (!isCross) ''
    # TexLab builds man page separately in CI:
    # https://github.com/latex-lsp/texlab/blob/v5.6.0/.github/workflows/publish.yml#L127-L131
    help2man --no-info "$out/bin/texlab" > texlab.1
    installManPage texlab.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "An implementation of the Language Server Protocol for LaTeX";
    homepage = "https://github.com/latex-lsp/texlab";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar kira-bruneau ];
    platforms = platforms.all;
  };
}
