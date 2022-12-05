require_relative "../lib/cmake"

class Kf5Knotifications < Formula
  desc "Abstraction for system notifications"
  homepage "https://api.kde.org/frameworks/knotifications/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.96/knotifications-5.96.0.tar.xz"
  sha256 "12933ae33e511b6a37fb3b0dc896248ffdd2ef007e2fc4dd05757fc8a8c7cb85"
  head "https://invent.kde.org/frameworks/knotifications.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "ansatzX/homebrew-kde/kf5-kcodecs"
  depends_on "ansatzX/homebrew-kde/kf5-kconfig"
  depends_on "ansatzX/homebrew-kde/kf5-kcoreaddons"
  depends_on "ansatzX/homebrew-kde/kf5-kwindowsystem"
  depends_on "ansatzX/homebrew-kde/phonon"
  depends_on "libcanberra"

  def install
    # setBadgeLabelText method is deprecated since 5.12
    args = %w[
      -DCMAKE_C_FLAGS_RELEASE=-DNDEBUG
      -DQT_DISABLE_DEPRECATED_BEFORE=0x050b00
      -DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG
      -DQT_DISABLE_DEPRECATED_BEFORE=0x050b00
    ]

    system "cmake", *args, *kde_cmake_args
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
    (testpath/"CMakeLists.txt").write("find_package(KF5Notifications REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
