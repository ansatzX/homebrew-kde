require_relative "../lib/cmake"

class KdeconnectKde < Formula
  desc "Multi-platform app that allows your devices to communicate"
  homepage "https://community.kde.org/KDEConnect"
  url "https://download.kde.org/stable/release-service/22.04.3/src/kdeconnect-kde-22.04.3.tar.xz"
  sha256 "9df40473469e73fbb865e1d0fcbe530b10b49d0f652f9265dd4237cae8ebaf04"
  head "https://invent.kde.org/network/kdeconnect-kde.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "ansatzX/homebrew-kde/kf5-kdeclarative" => :build
  depends_on "ninja" => :build
  depends_on "gettext"
  depends_on "hicolor-icon-theme"
  depends_on "ansatzX/homebrew-kde/kf5-kcmutils"
  depends_on "ansatzX/homebrew-kde/kf5-kconfigwidgets"
  depends_on "ansatzX/homebrew-kde/kf5-kdbusaddons"
  depends_on "ansatzX/homebrew-kde/kf5-kiconthemes"
  depends_on "ansatzX/homebrew-kde/kf5-kio"
  depends_on "ansatzX/homebrew-kde/kf5-kirigami2"
  depends_on "ansatzX/homebrew-kde/kf5-knotifications"
  depends_on "ansatzX/homebrew-kde/kf5-kpeople"
  depends_on "ansatzX/homebrew-kde/kf5-kservice"
  depends_on "kdoctools"
  depends_on "ki18n"
  depends_on "qca"
  depends_on "qt@5"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    assert_match "help", shell_output("#{bin}/kdeconnect-cli --help")
  end
end
