require_relative "../lib/cmake"

class Kf5Kfilemetadata < Formula
  desc "Library for extracting file metadata"
  homepage "https://api.kde.org/frameworks/kfilemetadata/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.96/kfilemetadata-5.96.0.tar.xz"
  sha256 "7809a54aadf8a37a73652e16fcf152e5230581502c4252cb75070083a9aa036a"
  head "https://invent.kde.org/frameworks/kfilemetadata.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "ebook-tools"
  depends_on "exiv2"
  depends_on "ffmpeg"
  depends_on "karchive"
  depends_on "ansatzX/homebrew-kde/kf5-kconfig"
  depends_on "ansatzX/homebrew-kde/kf5-kcoreaddons"
  depends_on "ki18n"
  depends_on "poppler-qt5"
  depends_on "taglib"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5FileMetaData REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
