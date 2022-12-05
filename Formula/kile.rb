require_relative "../lib/cmake"

class Kile < Formula
  desc "Integrated LaTeX Editing Environment"
  homepage "https://kile.sourceforge.io"
  url "https://downloads.sourceforge.net/project/kile/unstable/kile-3.0b3/kile-2.9.93.tar.bz2"
  sha256 "04499212ffcb24fb3a6829149a7cae4c6ad5d795985f080800d6df72f88c5df0"
  revision 3
  head "https://invent.kde.org/office/kile.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "ansatzX/homebrew-kde/kf5-khtml"
  depends_on "ansatzX/homebrew-kde/kf5-kinit"
  depends_on "ansatzX/homebrew-kde/kf5-ktexteditor"
  depends_on "ansatzX/homebrew-kde/okular"

  depends_on "ansatzX/homebrew-kde/konsole" => :recommended
  depends_on "poppler-qt5" => :recommended

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"

    # Extract Qt plugin path
    qtpp = `#{Formula["qt@5"].bin}/qtpaths --plugin-dir`.chomp
    system "/usr/libexec/PlistBuddy",
      "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
      "#{bin}/kile.app/Contents/Info.plist"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
       "$(brew --repo ansatzX/homebrew-kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    assert_match "help", shell_output("#{bin}/kile.app/Contents/MacOS/Kile --help")
  end
end
