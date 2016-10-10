From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH] add a build.sh helper to allow for a one-stop build
Date: Mon, 10 Oct 2016 17:28:02 +0200
Message-ID: <1476113282-19194-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This allows for a quick build instead of typing the whole mkdir, cd,
cmake and ninja sequence.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 README.md |  5 +----
 build.sh  | 12 ++++++++++++
 2 files changed, 13 insertions(+), 4 deletions(-)
 create mode 100755 build.sh

diff --git a/README.md b/README.md
index 98ec5a7..2ddecc3 100644
--- a/README.md
+++ b/README.md
@@ -36,10 +36,7 @@ Additional service daemons are provided for:
 This project uses a cmake based build system. Quick start:
 
 ```sh
-$ mkdir build
-$ cd build
-$ cmake -GNinja ..
-$ ninja
+$ sh build.sh
 ```
 
 *build/bin* will contain the sample programs and *build/lib* will contain the
diff --git a/build.sh b/build.sh
new file mode 100755
index 0000000..e3d85eb
--- /dev/null
+++ b/build.sh
@@ -0,0 +1,12 @@
+#!/bin/sh
+
+SRCDIR=`dirname $0`
+BUILDDIR="$SRCDIR/build"
+
+if [ ! -d "$BUILDDIR" ]; then
+    mkdir $BUILDDIR
+fi
+
+cd $BUILDDIR
+cmake -GNinja ..
+ninja
-- 
2.10.1.382.ga23ca1b

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
