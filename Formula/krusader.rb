require_relative "../lib/cmake"

class Krusader < Formula
  desc "Advanced twin panel (commander style) file manager"
  homepage "https://krusader.org/"
  url "https://download.kde.org/stable/krusader/2.7.2/krusader-2.7.2.tar.xz"
  sha256 "41a39a43b3c42dd1d1ecaea86df30caff6a061fecc1d66f60859b2a3ca976109"
  revision 4
  head "https://invent.kde.org/utilities/krusader.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "gettext"
  depends_on "hicolor-icon-theme"
  depends_on "karchive"
  depends_on "ansatzX/homebrew-kde/kf5-kio"
  depends_on "ansatzX/homebrew-kde/kf5-kparts"
  depends_on "ansatzX/homebrew-kde/kf5-kwallet"
  depends_on "ansatzX/homebrew-kde/kf5-kxmlgui"
  depends_on "ansatzX/homebrew-kde/kio-extras"
  depends_on "kdoctools"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
    # Extract Qt plugin path
    qtpp = `#{Formula["qt@5"].bin}/qtpaths --plugin-dir`.chomp
    system "/usr/libexec/PlistBuddy",
      "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
      "#{bin}/krusader.app/Contents/Info.plist"
  end

  def post_install
    mkdir_p HOMEBREW_PREFIX/"share/krusader"
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/krusader/icontheme.rcc"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo ansatzX/homebrew-kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    assert_match "help", shell_output("#{bin}/krusader.app/Contents/MacOS/krusader --help")
  end
end
