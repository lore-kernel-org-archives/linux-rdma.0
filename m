From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 5/5] travis: Test Debian packaging under Artful container
Date: Thu,  2 Nov 2017 18:55:56 +0200
Message-ID: <20171102165556.22105-6-leon@kernel.org>
References: <20171102165556.22105-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102165556.22105-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This will be compiled with GCC 7 coming with Ubuntu Artful

Signed-off-by: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 buildlib/package-build-test |  2 +-
 buildlib/travis-build       | 14 --------------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/buildlib/package-build-test b/buildlib/package-build-test
index d767f61f..b9624b31 100755
--- a/buildlib/package-build-test
+++ b/buildlib/package-build-test
@@ -5,7 +5,7 @@ set -e
 # be verbose
 set -x

-for OS in centos7 opensuse-42.2
+for OS in centos7 opensuse-42.2 artful
 do
 	echo
 	echo "Checking package build for ${OS} ...."
diff --git a/buildlib/travis-build b/buildlib/travis-build
index bf86baa7..1a88dff2 100755
--- a/buildlib/travis-build
+++ b/buildlib/travis-build
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
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
