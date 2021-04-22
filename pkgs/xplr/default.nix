{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.5.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "f9VvkSumgDpJaS8vKtv1UlbgbOegMw7wkgJ7BqbCB5A=";
  };

  cargoSha256 = "GQg1rCEx9CWqQRlKvlIaMdsM9kH8WkvPNqZ6N079Q48=";

  meta = with lib; {
    description = "A fast line-oriented regex search tool, similar to ag and ack";
    homepage = "https://github.com/BurntSushi/ripgrep";
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
  };
}
