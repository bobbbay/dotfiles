{ pkgs
, fetchFromGitHub
, autoreconfHook
, cairo
, libjpeg_turbo
, libpng
, libossp_uuid
, freerdp
, pango
, libssh2
, libvncserver
, libpulseaudio
, openssl
, libvorbis
, libwebp
, pkgconfig
, perl
, libtelnet
, makeWrapper
, ...
}:

with pkgs;

stdenv.mkDerivation rec {
  name = "guacamole-${version}";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "incubator-guacamole-server";
    rev = "6c0862e82da8ee737ee655c7815b1851de6d0488";
    sha256 = "1wzlg06yzr3lbxdjjj9rkhdv6g6nr62sdmkklq5f99fj1jclgvic";
  };
  buildInputs = with stdenv; [ autoreconfHook pkgconfig cairo libpng libjpeg_turbo libossp_uuid freerdp pango libssh2 libvncserver libpulseaudio openssl libvorbis libwebp libtelnet perl makeWrapper ];
  # propogatedBuildInputs = with stdenv; [ autoreconfHook pkgconfig cairo libpng libjpeg_turbo libossp_uuid freerdp pango libssh2 libvncserver libpulseaudio openssl libvorbis libwebp inetutils];
  patchPhase = ''
    substituteInPlace ./src/protocols/rdp/keymaps/generate.pl --replace /usr/bin/perl "${perl}/bin/perl"
    substituteInPlace ./src/protocols/rdp/Makefile.am --replace "-Werror -Wall" "-Wall"
  '';
  postInstall = ''
    echo "Wrap"
    wrapProgram $out/sbin/guacd --prefix LD_LIBRARY_PATH ":" $out/lib
  '';

  meta = with stdenv.lib; {
    description = "Clientless remote desktop gateway";
    homepage = "https://guacamole.incubator.apache.org/";
    maintainers = [ stdenv.lib.maintainers.tomberek ];
    license = licenses.cc-by-40;
    platforms = platforms.linux;
  };
}
