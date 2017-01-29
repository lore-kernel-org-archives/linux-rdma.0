From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 1/2] travis: Simplify travis config
Date: Sun, 29 Jan 2017 16:35:58 +0200
Message-ID: <20170129143559.7654-2-leon@kernel.org>
References: <20170129143559.7654-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170129143559.7654-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Move travis build instructions into separate file.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 .travis.yml           | 25 +------------------------
 buildlib/travis-build | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 24 deletions(-)
 create mode 100755 buildlib/travis-build

diff --git a/.travis.yml b/.travis.yml
index 06443530..c4fa1985 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -36,27 +36,4 @@ addons:
       - lib32gcc-6-dev
 
 script:
-  - mkdir build build-clang build32 build-no-dma
-  - cd build
-  # The goal is warning free compile on latest gcc.
-  - CC=gcc-6 CFLAGS=-Werror cmake -GNinja ..
-  - ninja
-
-  # .. and latest clang
-  - cd ../build-clang
-  - CC=clang-3.9 CFLAGS=-Werror cmake -GNinja ..
-  - ninja
-
-  # 32 bit build
-  - cd ../build32
-  # travis's trusty is not configured in a way that enables all 32 bit
-  # packages. We could fix this with some sudo stuff.. For now turn off libnl
-  - CC=gcc-6 CFLAGS="-Werror -m32" cmake -GNinja .. -DENABLE_RESOLVE_NEIGH=0
-  - ninja
-
-  # Test with coherent DMA mode disabled (ie as would be on ARM32, etc)
-  - cd ../build-clang
-  - echo "#error Fail" >> ../libibverbs/arch.h
-  - rm CMakeCache.txt
-  - CC=clang-3.9 CFLAGS=-Werror cmake -GNinja ..
-  - ninja
+  - buildlib/travis-build
diff --git a/buildlib/travis-build b/buildlib/travis-build
new file mode 100755
index 00000000..bf0143b9
--- /dev/null
+++ b/buildlib/travis-build
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+set -e
+
+mkdir build build-clang build32 build-no-dma
+cd build
+# The goal is warning free compile on latest gcc.
+CC=gcc-6 CFLAGS=-Werror cmake -GNinja ..
+ninja
+
+# .. and latest clang
+cd ../build-clang
+CC=clang-3.9 CFLAGS=-Werror cmake -GNinja ..
+ninja
+
+# 32 bit build
+cd ../build32
+# travis's trusty is not configured in a way that enables all 32 bit
+# packages. We could fix this with some sudo stuff.. For now turn off libnl
+CC=gcc-6 CFLAGS="-Werror -m32" cmake -GNinja .. -DENABLE_RESOLVE_NEIGH=0
+ninja
+
+# Test with coherent DMA mode disabled (ie as would be on ARM32, etc)
+cd ../build-clang
+echo "#error Fail" >> ../libibverbs/arch.h
+rm CMakeCache.txt
+CC=clang-3.9 CFLAGS=-Werror cmake -GNinja ..
+ninja
+cd ..
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
