require_relative "../lib/cmake"

class Kf5Kio < Formula
  desc "Resource and network access abstraction"
  homepage "https://api.kde.org/frameworks/kio/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.96/kio-5.96.0.tar.xz"
  sha256 "95983904cd01c31b7fffbf615765485029192b2352f6672b8b7386cb0e7ebb76"
  head "https://invent.kde.org/frameworks/kio.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "desktop-file-utils"
  depends_on "ansatzX/homebrew-kde/kf5-kbookmarks"
  depends_on "ansatzX/homebrew-kde/kf5-kjobwidgets"
  depends_on "ansatzX/homebrew-kde/kf5-kwallet"
  depends_on "ansatzX/homebrew-kde/kf5-solid"
  depends_on "libxslt"
  depends_on "qt@5"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo ansatzX/homebrew-kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5KIO REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
