class Kf5Kimageformats < Formula
  desc "Image format plugins for Qt5"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.47/kimageformats-5.47.0.tar.xz"
  sha256 "8e5c2cb68ee57bf902cfbe72db1e9543819dcbcf40c652d96bccfab45de346a6"

  head "git://anongit.kde.org/kimageformats.git"

  depends_on "cmake" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "KDE-mac/kde/kf5-karchive" => :optional
  depends_on "qt"
  depends_on "openexr"
  depends_on "jasper"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      prefix.install "install_manifest.txt"
    end
  end

  def caveats; <<~EOS
    You need to take some manual steps in order to make this formula work:
      ln -sfv "$(brew --prefix)/share/kservices5" "$HOME/Library/Application Support"
     EOS
  end
end
