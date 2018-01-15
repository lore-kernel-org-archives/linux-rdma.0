From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 3/3] travis: Use clang-5.0
Date: Mon, 15 Jan 2018 14:13:47 -0700
Message-ID: <20180115211347.5651-4-jgg@ziepe.ca>
References: <20180115211347.5651-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180115211347.5651-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Packages are available for trusty now

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 .travis.yml           | 6 +++---
 buildlib/travis-build | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 7af2aeb9072db5..9d9667a9ecd838 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -11,15 +11,15 @@ addons:
   apt:
     sources:
       # sourceline because travis won't white list trusty builds, and hasn't
-      # whitelisted 4.0
-      - sourceline: "deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-4.0 main"
+      # whitelisted 5.0
+      - sourceline: "deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-5.0 main"
         key_url: "http://apt.llvm.org/llvm-snapshot.gpg.key"
       - ubuntu-toolchain-r-test
       # Multiverse is not on by default and we need it to get sparse
       - sourceline: "deb http://archive.ubuntu.com/ubuntu/ trusty multiverse"
     packages:
       - build-essential
-      - clang-4.0
+      - clang-5.0
       - cmake
       - debhelper
       - dh-systemd
diff --git a/buildlib/travis-build b/buildlib/travis-build
index 0efcbc60d18be5..cb5c1149a43ab8 100755
--- a/buildlib/travis-build
+++ b/buildlib/travis-build
@@ -9,9 +9,9 @@ mkdir build-clang build32 build-sparse build-aarch64
 
 # Build with latest clang first
 cd build-clang
-CC=clang-4.0 CFLAGS=-Werror cmake -GNinja ..
+CC=clang-5.0 CFLAGS=-Werror cmake -GNinja ..
 ninja
-../buildlib/check-build --src .. --cc clang-4.0
+../buildlib/check-build --src .. --cc clang-5.0
 
 # 32 bit build to check format strings/etc
 cd ../build32
@@ -42,7 +42,7 @@ cd ../build-clang
 cp ../util/udma_barrier.h ../util/udma_barrier.h.old
 echo "#error Fail" >> ../util/udma_barrier.h
 rm CMakeCache.txt
-CC=clang-4.0 CFLAGS=-Werror cmake -GNinja ..
+CC=clang-5.0 CFLAGS=-Werror cmake -GNinja ..
 ninja
 cp ../util/udma_barrier.h.old ../util/udma_barrier.h
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
