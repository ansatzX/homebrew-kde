require_relative "../lib/cmake"

class Dolphin < Formula
  desc "KDE File Manager"
  homepage "https://apps.kde.org/dolphin"
  url "https://download.kde.org/stable/release-service/22.04.3/src/dolphin-22.04.3.tar.xz"
  sha256 "8e573e1df98b5b8f134374da641c1f289a00d1b6aabf65ecf3b2a6a854b22a1e"
  head "https://invent.kde.org/system/dolphin.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "ansatzX/homebrew-kde/kf5-breeze-icons"
  depends_on "ansatzX/homebrew-kde/kf5-kcmutils"
  depends_on "ansatzX/homebrew-kde/kf5-kdelibs4support"
  depends_on "ansatzX/homebrew-kde/kf5-kfilemetadata"
  depends_on "ansatzX/homebrew-kde/kf5-kinit"
  depends_on "ansatzX/homebrew-kde/kf5-knewstuff"
  depends_on "ansatzX/homebrew-kde/kf5-kparts"
  depends_on "ansatzX/homebrew-kde/kio-extras"
  depends_on "ansatzX/homebrew-kde/konsole"
  depends_on "ruby"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
    # Extract Qt plugin path
    qtpp = `#{Formula["qt@5"].bin}/qtpaths --plugin-dir`.chomp
    system "/usr/libexec/PlistBuddy",
      "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
      "#{bin}/dolphin.app/Contents/Info.plist"
  end

  def post_install
    mkdir_p HOMEBREW_PREFIX/"share/dolphin"
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/dolphin/icontheme.rcc"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo ansatzX/homebrew-kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    assert_match "help", shell_output("#{bin}/dolphin.app/Contents/MacOS/dolphin --help")
  end
end
