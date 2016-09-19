From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 6/9] move libibcm documentation to Documentation/
Date: Mon, 19 Sep 2016 08:56:30 -0700
Message-ID: <1474300593-31922-7-git-send-email-hch@lst.de>
References: <1474300593-31922-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474300593-31922-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

And drop bits that are outdated or replaced by top-level Documentation.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 Documentation/libibcm.md | 16 ++++++++++++++++
 libibcm/README           | 28 ----------------------------
 2 files changed, 16 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/libibcm.md
 delete mode 100644 libibcm/README

diff --git a/Documentation/libibcm.md b/Documentation/libibcm.md
new file mode 100644
index 0000000..663e773
--- /dev/null
+++ b/Documentation/libibcm.md
@@ -0,0 +1,16 @@
+# Device files
+
+The userspace CM uses a device file per adapter present.
+
+To create the appropriate character device file automatically with
+udev, a rule like
+
+    KERNEL="ucm*", NAME="infiniband/%k", MODE="0666"
+
+can be used.  This will create the device node named
+
+    /dev/infiniband/ucm0
+
+for the first HCA in the system, or you can create it manually
+
+  mknod /dev/infiniband/ucm0 c 231 224
diff --git a/libibcm/README b/libibcm/README
deleted file mode 100644
index 4dda13c..0000000
--- a/libibcm/README
+++ /dev/null
@@ -1,28 +0,0 @@
-This README is for userspace cm library.
-
-Building
-
-To make this directory, run:
-./autogen.sh && ./configure && make && make install
-
-Typically the autogen and configure steps only need be done the first
-time unless configure.in or Makefile.am changes.
-
-Libraries are installed by default at /usr/local/lib.
-
-Device files
-
-The userspace CM uses a device file per adapter present.
-
-To create the appropriate character device file automatically with
-udev, a rule like
-
-    KERNEL="ucm*", NAME="infiniband/%k", MODE="0666"
-
-can be used.  This will create the device node named
-
-    /dev/infiniband/ucm0
-
-for the first HCA in the system, or you can create it manually
-
-  mknod /dev/infiniband/ucm0 c 231 224
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
