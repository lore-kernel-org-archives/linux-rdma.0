From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH RFC rdma-core] travis: Enforce kernel coding style on rdma-core
Date: Sat, 15 Jul 2017 11:21:01 +0300
Message-ID: <20170715082101.17811-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The rdma-core library is tightly coupled to the linux-rdma kernel
and developed mostly by the same kernel developers. Enforcement of
the same coding style as used for kernel development has potential
to reduce errors and improve readability.

Despite the fact that checkpatch is written as general tool, the
differences between kernel and user space requires from us to
skip kernel types, file movement and execute permissions checks.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
I checked it and it works correctly on man pages, markdown, debian and redhat sepfic files.
https://github.com/linux-rdma/rdma-core/pull/168
https://travis-ci.org/linux-rdma/rdma-core/builds/253870106?utm_source=github_status&utm_medium=notification

Thanks
---
 .travis.yml                       |  1 +
 buildlib/const_structs.checkpatch |  0
 buildlib/travis-checkpatch        | 14 ++++++++++++++
 3 files changed, 15 insertions(+)
 create mode 100644 buildlib/const_structs.checkpatch
 create mode 100755 buildlib/travis-checkpatch

diff --git a/.travis.yml b/.travis.yml
index e72ff9d2..c63ac962 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -49,6 +49,7 @@ before_script:
   - rm $LATEST_GCC_LINARO_TAR
 script:
   - buildlib/travis-build
+  - buildlib/travis-checkpatch
   - buildlib/github-release
 deploy:
   # Deploy assets to Github releases
diff --git a/buildlib/const_structs.checkpatch b/buildlib/const_structs.checkpatch
new file mode 100644
index 00000000..e69de29b
diff --git a/buildlib/travis-checkpatch b/buildlib/travis-checkpatch
new file mode 100755
index 00000000..50e5d67e
--- /dev/null
+++ b/buildlib/travis-checkpatch
@@ -0,0 +1,14 @@
+#!/bin/bash
+# Copyright 2017 Mellanox Technologies Ltd.
+# Licensed under BSD (MIT variant) or GPLv2. See COPYING.
+
+set -e
+
+if [ $TRAVIS_COMMIT_RANGE != "" ]; then
+	cd buildlib/
+	wget https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/checkpatch.pl
+	wget https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/scripts/spelling.txt
+	DIR_FOR_PATCHES_TO_CHECK=$(mktemp -d)
+	git format-patch --no-cover-letter $TRAVIS_COMMIT_RANGE -o $DIR_FOR_PATCHES_TO_CHECK/
+	perl checkpatch.pl --no-tree --ignore PREFER_KERNEL_TYPES,FILE_PATH_CHANGES,EXECUTE_PERMISSIONS $DIR_FOR_PATCHES_TO_CHECK/*
+fi
--
2.13.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
