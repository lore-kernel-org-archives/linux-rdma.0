From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 5/5] Update TravisCI to use clang 3.9 as well
Date: Fri,  7 Oct 2016 16:36:12 -0600
Message-ID: <1475879772-29458-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475879772-29458-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475879772-29458-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Now that the build runs warning free on clang 3.9 as well.

clang has a different set of static checker type warnings.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 .travis.yml | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index a2b9e3b8c3f3..d81b699294eb 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -1,15 +1,23 @@
 language: c
 # We need at least cmake 2.12, this means we need to use trusty.
 # Precise's glibc, etc predates what we are willing to support.
-# No reason for sudo.
+# sudo is required to get the trusty image, and at present to enable llvm 3.9
 sudo: required
 dist: trusty
 addons:
+  # We run our builds sequentially in one VM rather than try and use the
+  # matrix feature. This is because Travis is unreasonably inefficient
+  # doing this APT setup pass.
   apt:
     sources:
+      # sourceline because travis won't white list trusty builds, and hasn't
+      # whitelisted 3.9
+      - sourceline: "deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-3.9 main"
+        key_url: "http://apt.llvm.org/llvm-snapshot.gpg.key"
       - ubuntu-toolchain-r-test
     packages:
       - build-essential
+      - clang-3.9
       - cmake
       - debhelper
       - gcc
@@ -25,16 +33,22 @@ addons:
       # 32 bit support packages
       - gcc-multilib
       - lib32gcc-6-dev
+
 script:
-  - mkdir build build32
+  - mkdir build build-clang build32
   - cd build
   # The goal is warning free compile on latest gcc.
   - CC=gcc-6 CFLAGS=-Werror cmake -GNinja ..
   - ninja
 
+  # .. and latest clang
+  - cd ../build-clang
+  - CC=clang-3.9 CFLAGS=-Werror cmake -GNinja ..
+  - ninja
+
   # 32 bit build
   - cd ../build32
-  # travis's trusty is not configured in a way that enables all32 bit
+  # travis's trusty is not configured in a way that enables all 32 bit
   # packages. We could fix this with some sudo stuff.. For now turn off libnl
   - CC=gcc-6 CFLAGS="-Werror -m32" cmake -GNinja .. -DENABLE_RESOLVE_NEIGH=0
   - ninja
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
