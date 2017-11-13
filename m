From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 3/3] travis: Test Debian packaging under artful container
Date: Mon, 13 Nov 2017 08:08:06 +0200
Message-ID: <20171113060806.27354-4-leon@kernel.org>
References: <20171113060806.27354-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113060806.27354-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This will be compiled with GCC 7 coming with Ubuntu artful.

Also, remove installations of GCC 7 and debian helpers from addons->apt
list in .travis.yml file as they are no longer required.

Finally, since we are removing a -Werror compilation test from buildlib/travis-build,
make sure that all builds performed by buildlib/cbuild will run with
-Werorr by adding it to CFLAGS environment variable.

Signed-off-by: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 .travis.yml                 |  6 ------
 buildlib/cbuild             |  7 +++++++
 buildlib/package-build-test |  2 +-
 buildlib/travis-build       | 16 +---------------
 4 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 4d7b0cc0..dadee011 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -14,18 +14,13 @@ addons:
       # whitelisted 4.0
       - sourceline: "deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-4.0 main"
         key_url: "http://apt.llvm.org/llvm-snapshot.gpg.key"
-      - ubuntu-toolchain-r-test
       # Multiverse is not on by default and we need it to get sparse
       - sourceline: "deb http://archive.ubuntu.com/ubuntu/ trusty multiverse"
     packages:
       - build-essential
       - clang-4.0
       - cmake
-      - debhelper
-      - dh-systemd
-      - fakeroot
       - gcc
-      - gcc-7
       - git
       - libnl-3-dev
       - libnl-route-3-dev
@@ -40,7 +35,6 @@ addons:
 
       # 32 bit support packages
       - gcc-multilib
-      - lib32gcc-7-dev
 
 service:
     - docker
diff --git a/buildlib/cbuild b/buildlib/cbuild
index 32bb70df..d47938ef 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -478,6 +478,9 @@ os.symlink({tarfn!r},os.path.join("SOURCES",tarfn));
             extra_opts = getattr(env,"rpmbuild_options", [])
             bopts = ["-bb",tspec_file] + extra_opts;
 
+            # Let rpmbuild compile with -Werror
+            print >> F,'os.environ["CFLAGS"] = "-Werror"'
+
             print >> F,'os.execlp("rpmbuild","rpmbuild",%s)'%(
                 ",".join(repr(I) for I in bopts));
 
@@ -533,6 +536,10 @@ import subprocess,os;
 def to_user():
    os.setgid({gid:d});
    os.setuid({uid:d});
+
+# Compile with -Werror
+os.environ["CFLAGS"] = "-Werror"
+
 subprocess.check_call(["debian/rules","debian/rules","build"],
             preexec_fn=to_user);
 subprocess.check_call(["debian/rules","debian/rules","binary"]);
diff --git a/buildlib/package-build-test b/buildlib/package-build-test
index 15f24caa..b1a7807c 100755
--- a/buildlib/package-build-test
+++ b/buildlib/package-build-test
@@ -11,7 +11,7 @@ if [ -e "/.dockerenv" ] || (grep -q docker /proc/self/cgroup &>/dev/null); then
        exit 0
 fi
 
-for OS in centos7 tumbleweed
+for OS in centos7 tumbleweed artful
 do
 	echo
 	echo "Checking package build for ${OS} ...."
diff --git a/buildlib/travis-build b/buildlib/travis-build
index bf86baa7..3ee4182b 100755
--- a/buildlib/travis-build
+++ b/buildlib/travis-build
@@ -17,7 +17,7 @@ ninja
 cd ../build32
 # travis's trusty is not configured in a way that enables all 32 bit
 # packages. We could fix this with some sudo stuff.. For now turn off libnl
-CC=gcc-7 CFLAGS="-Werror -m32" cmake -GNinja .. -DENABLE_RESOLVE_NEIGH=0
+CFLAGS="-Werror -m32" cmake -GNinja .. -DENABLE_RESOLVE_NEIGH=0
 ninja
 
 # aarch64 build to check compilation on ARM 64bit platform
@@ -45,17 +45,3 @@ rm CMakeCache.txt
 CC=clang-4.0 CFLAGS=-Werror cmake -GNinja ..
 ninja
 cp ../util/udma_barrier.h.old ../util/udma_barrier.h
-
-# Finally run through gcc-7 64 bit through the debian packaging This gives a
-# good clue if patches are changing packaging related things, the RPM stuff
-# will have to be audited by hand.
-
-# When running cmake through debian/rules it is hard to set -Werror,
-# instead force it on by changing the CMakeLists.txt
-cd ..
-echo 'set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Werror")' >> buildlib/RDMA_EnableCStd.cmake
-sed -i -e 's/-DCMAKE_BUILD_TYPE=Release//g' debian/rules
-sed -i -e 's/ninja \(.*\)-v/ninja \1/g' debian/rules
-
-CC=gcc-7 debian/rules build
-fakeroot debian/rules binary
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
