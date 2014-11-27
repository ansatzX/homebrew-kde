require "formula"

class Kf5Kcrash < Formula
  url "http://download.kde.org/stable/frameworks/5.4/kcrash-5.4.0.tar.xz"
  sha1 "ae04eead1cd80da8cc375d0ade100adf9aa0d68a"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kcrash.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"

  depends_on "haraldf/kf5/kf5-kwindowsystem"
  depends_on "haraldf/kf5/kf5-kcoreaddons"

  def install
    args = std_cmake_args

    args << "-DCMAKE_CXX_FLAGS='-D_DARWIN_C_SOURCE'"

    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"
  end
end
