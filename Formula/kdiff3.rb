require_relative "../lib/cmake"

class Kdiff3 < Formula
  desc "Utility for comparing and merging files and directories"
  homepage "https://apps.kde.org/kdiff3/"
  url "https://download.kde.org/stable/kdiff3/kdiff3-1.9.6.tar.xz"
  sha256 "ac922476f850613a739284e3faf477c98ac349ad15a737a2b72ded8451f6b2bc"
  head "https://invent.kde.org/sdk/kdiff3.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "ansatzX/homebrew-kde/kf5-kcoreaddons" => :build
  depends_on "ansatzX/homebrew-kde/kf5-kcrash" => :build
  depends_on "ansatzX/homebrew-kde/kf5-kiconthemes" => :build
  depends_on "ansatzX/homebrew-kde/kf5-kparts" => :build
  depends_on "kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "ansatzX/homebrew-kde/kf5-breeze-icons"
  depends_on "qt@5"

  def install
    system "cmake", "-DMACOSX_BUNDLE_ICON_FILE=kdiff3.icns", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    assert_match "help", shell_output("#{bin}/kdiff3.app/Contents/MacOS/kdiff3 --help")
  end
end
