require "formula"

class Kf5Kpty < Formula
  url "http://download.kde.org/unstable/frameworks/4.98.0/kpty-4.98.0.tar.xz"
  sha1 "6cb93ced70b9cd04e5f6a2ff445fdef5e132784a"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kpty.git'

  depends_on "cmake" => :build
  depends_on "qt5" => "with-d-bus"
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "haraldf/kf5/kf5-kcoreaddons" => :build
  depends_on "haraldf/kf5/kf5-kjs" => :build
  depends_on "haraldf/kf5/kf5-ki18n" => :build

  def install
    args = std_cmake_args


    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"
  end
end
