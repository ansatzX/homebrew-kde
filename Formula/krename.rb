require_relative "../lib/cmake"

class Krename < Formula
  desc "Very powerful batch file renamer"
  homepage "https://userbase.kde.org/KRename"
  url "https://download.kde.org/stable/krename/5.0.2/src/krename-5.0.2.tar.xz"
  sha256 "b23c60a7ddd9f6db4dd7f55ac55fcca8a558fa68aaf8fa5cb89e1eaf692f23ed"
  head "https://invent.kde.org/utilities/krename.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "exiv2"
  depends_on "hicolor-icon-theme"
  depends_on "ansatzX/homebrew-kde/kf5-breeze-icons"
  depends_on "ansatzX/homebrew-kde/kf5-kio"
  depends_on "ansatzX/homebrew-kde/kf5-kjs"
  depends_on "podofo"
  depends_on "taglib"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
    # Extract Qt plugin path
    qtpp = `#{Formula["qt@5"].bin}/qtpaths --plugin-dir`.chomp
    system "/usr/libexec/PlistBuddy",
      "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
      "#{bin}/krename.app/Contents/Info.plist"
  end

  def post_install
    mkdir_p HOMEBREW_PREFIX/"share/krename"
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/krename/icontheme.rcc"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo ansatzX/homebrew-kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    assert_match "help", shell_output("#{bin}/krename.app/Contents/MacOS/krename --help")
  end
end
