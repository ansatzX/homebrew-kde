require_relative "../lib/cmake"

class Lokalize < Formula
  desc "Computer-aided translation system"
  homepage "https://www.kde.org/applications/development/lokalize/"
  url "https://download.kde.org/stable/release-service/22.04.3/src/lokalize-22.04.3.tar.xz"
  sha256 "3d8366e1bdb8543ca430ea2406d37c4bdebbdb3afce6e516b6d2981a04cba1fb"
  head "https://invent.kde.org/sdk/lokalize.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "gettext"
  depends_on "hicolor-icon-theme"
  depends_on "hunspell"
  depends_on "ansatzX/homebrew-kde/kf5-kross"
  depends_on "poxml"
  depends_on "qt@5"
  depends_on "subversion"
  depends_on "translate-toolkit"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
    # Extract Qt plugin path
    qtpp = `#{Formula["qt@5"].bin}/qtpaths --plugin-dir`.chomp
    system "/usr/libexec/PlistBuddy",
      "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
      "#{bin}/lokalize.app/Contents/Info.plist"
  end

  def post_install
    mkdir_p HOMEBREW_PREFIX/"share/lokalize"
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/lokalize/icontheme.rcc"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo ansatzX/homebrew-kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    assert_match "help", shell_output("#{bin}/lokalize.app/Contents/MacOS/lokalize --help")
  end
end
