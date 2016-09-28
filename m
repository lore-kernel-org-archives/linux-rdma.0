From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core] Add a .travis.yml file
Date: Wed, 28 Sep 2016 17:28:57 -0600
Message-ID: <1475105337-18002-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Necessary to use the Travis CI service.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 .travis.yml | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 .travis.yml

Now that travis is enabled on repo, we need a yml file to make it run.

Here is a basic one.

I don't test with distros as old as precise and I don't expect that glibc to
be new enough to build this (eg missing timerfd, O_CLOEXEC, etc), and the
cmake certainly isn't. So we use the trusty 'beta' environment and install
gcc 6.2.

See it in action:

https://github.com/linux-rdma/rdma-core/pull/7

diff --git a/.travis.yml b/.travis.yml
new file mode 100644
index 000000000000..e09dd32ffa9f
--- /dev/null
+++ b/.travis.yml
@@ -0,0 +1,28 @@
+language: c
+# We need at least cmake 2.12, this means we need to use trusty.
+# Precise's glibc, etc predates what we are willing to support.
+# No reason for sudo.
+sudo: required
+dist: trusty
+addons:
+  apt:
+    sources:
+      - ubuntu-toolchain-r-test
+    packages:
+      - build-essential
+      - cmake
+      - debhelper
+      - gcc
+      - gcc-6
+      - libnl-3-dev
+      - libnl-route-3-dev
+      - make
+      - ninja-build
+      - pkg-config
+      - python
+      - valgrind
+script:
+  - mkdir build
+  - cd build
+  - CC=gcc-6 cmake -GNinja ..
+  - ninja
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
