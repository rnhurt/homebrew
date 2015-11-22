class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/2.2.14/tarball/percona-toolkit-2.2.14.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/percona-toolkit/percona-toolkit_2.2.14.orig.tar.gz"
  sha256 "dd02bedef65536321af6ad3fc6fd8f088e60830267daa613189a14c10ad3a0d0"
  revision 1

  head "lp:percona-toolkit", :using => :bzr

  bottle do
    cellar :any
    revision 2
    sha256 "bd302d01739a5f1c1dda4445dd50287d9d5c66b714b595f5f181de3eb5ed32cd" => :el_capitan
    sha256 "2fafd98c8ea4e1994b1da9f0c7b33db87f783cc993f68fa7cb7856f03363e171" => :yosemite
    sha256 "73db80b5764c024ec09faec733c390d3b2b68cc565f53e3fe885d85c1641fb5c" => :mavericks
  end

  depends_on :mysql
  depends_on "openssl"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.033.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.033.tar.gz"
    sha256 "cc98bbcc33581fbc55b42ae681c6946b70a26f549b3c64466740dfe9a7eac91c"
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MAKAMAKA/JSON-2.90.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MA/MAKAMAKA/JSON-2.90.tar.gz"
    sha256 "4ddbb3cb985a79f69a34e7c26cde1c81120d03487e87366f9a119f90f7bdfe88"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("JSON").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    resource("DBD::mysql").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "test", "install"
    share.install prefix/"man"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    system bin/"pt-summary"
  end
end
