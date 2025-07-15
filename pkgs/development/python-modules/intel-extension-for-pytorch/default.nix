{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  setuptools,

  # deps
  torch,

  # native deps
  cmake,
  gcc,
}:

buildPythonPackage rec {
  pname = "intel-extension-for-pytorch";
  v = "2.7.0";
  version = "${v}+cpu";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "intel";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-0LyqEVBroH5ZcbxUP8yDfka6jO7M+ODNDAuVXGKo784=";
    leaveDotGit = true;
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];
  dependencies = [
    torch
  ];

  torchLib = "${torch.dev}/";

  preConfigure = ''
    export LDFLAGS="-L${torchLib}"
    export CFLAGS="-I${torchLib}/include"
  '';

  BUILD_WITH_CPU = 1;
  IPEX_VERSION = version;
  IPEX_PROJ_NAME = "intel_extension_for_pytorch";
  LIBTORCH_PATH = torch;


  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [

    (lib.cmakeFeature "CMAKE_PROJECT_VERSION" v)
    (lib.cmakeFeature "CMAKE_LIBRARY_PATH" "${torch.dev}")
    (lib.cmakeFeature "CMAKE_C_COMPILER" "${gcc}")
  ];
}
