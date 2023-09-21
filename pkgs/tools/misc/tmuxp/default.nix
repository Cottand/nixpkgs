{ lib, python3Packages, installShellFiles }:

let
  pypkgs = python3Packages;

in
pypkgs.buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.28.1";

  src = pypkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-sNLqUyas6QY11eW/FhkqB6+u4MTqiY1ixvD3BN69Fic=";
  };

  # No tests in archive
  doCheck = false;

  format = "pyproject";

  nativeBuildInputs = [
    pypkgs.poetry-core
    installShellFiles
  ];

  propagatedBuildInputs = with pypkgs; [
    click
    colorama
    kaptan
    libtmux
  ];

  postInstall = ''
    installShellCompletion --cmd tmuxp \
      --bash <(_TMUXP_COMPLETE=bash_source $out/bin/tmuxp) \
      --fish <(_TMUXP_COMPLETE=fish_source $out/bin/tmuxp) \
      --zsh <(_TMUXP_COMPLETE=zsh_source $out/bin/tmuxp)
  '';

  meta = with lib; {
    description = "tmux session manager";
    homepage = "https://tmuxp.git-pull.com/";
    changelog = "https://github.com/tmux-python/tmuxp/raw/v${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
