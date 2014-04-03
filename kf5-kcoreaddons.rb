require "formula"

class Kf5Kcoreaddons < Formula
  url "http://download.kde.org/unstable/frameworks/4.97.0/kcoreaddons-4.97.0.tar.xz"
  sha1 "f38826cea99b3e21c1c4a6cf0186b573069ecfe5"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kcoreaddons.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"
  depends_on "shared-mime-info"

  def install
    args = std_cmake_args

    args << "-DCMAKE_CXX_FLAGS='-D_DARWIN_C_SOURCE'"

    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"
  end
end
