require_relative "../lib/cmake"

class Kate < Formula
  desc "Advanced KDE Text Editor"
  homepage "https://kate-editor.org"
  url "https://download.kde.org/stable/release-service/22.04.3/src/kate-22.04.3.tar.xz"
  sha256 "6e3e4f78c8c2b6a68ce8122dbcd1f1222ec18dd17aa1b4b155989a4659c8d436"
  revision 1
  head "https://invent.kde.org/utilities/kate.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "hicolor-icon-theme"
  depends_on "ansatzX/homebrew-kde/kf5-breeze-icons"
  depends_on "ansatzX/homebrew-kde/kf5-kactivities"
  depends_on "ansatzX/homebrew-kde/kf5-kitemmodels"
  depends_on "ansatzX/homebrew-kde/kf5-knewstuff"
  depends_on "ansatzX/homebrew-kde/kf5-ktexteditor"
  depends_on "ansatzX/homebrew-kde/konsole"
  depends_on "threadweaver"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
    # Extract Qt plugin path
    qtpp = `#{Formula["qt@5"].bin}/qtpaths --plugin-dir`.chomp
    system "/usr/libexec/PlistBuddy",
      "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
      "#{bin}/kate.app/Contents/Info.plist"
    system "/usr/libexec/PlistBuddy",
      "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
      "#{bin}/kwrite.app/Contents/Info.plist"
  end

  def post_install
    mkdir_p HOMEBREW_PREFIX/"share/kate"
    mkdir_p HOMEBREW_PREFIX/"share/kwrite"
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/kate/icontheme.rcc"
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/kwrite/icontheme.rcc"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
       "$(brew --repo ansatzX/homebrew-kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    assert_match "help", shell_output("#{bin}/kate.app/Contents/MacOS/kate --help")
    assert_match "help", shell_output("#{bin}/kwrite.app/Contents/MacOS/kwrite --help")
  end
end
