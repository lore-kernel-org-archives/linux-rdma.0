From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 7/9] move librdmacm documentation to Documentation/
Date: Mon, 19 Sep 2016 08:56:31 -0700
Message-ID: <1474300593-31922-8-git-send-email-hch@lst.de>
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
 Documentation/librdmacm.md | 46 ++++++++++++++++++++++++++++++++++
 librdmacm/README           | 61 ----------------------------------------------
 2 files changed, 46 insertions(+), 61 deletions(-)
 create mode 100644 Documentation/librdmacm.md
 delete mode 100644 librdmacm/README

diff --git a/Documentation/librdmacm.md b/Documentation/librdmacm.md
new file mode 100644
index 0000000..5eb8d31
--- /dev/null
+++ b/Documentation/librdmacm.md
@@ -0,0 +1,46 @@
+# Device files
+
+The userspace CMA uses a single device file regardless of the number
+of adapters or ports present.
+
+To create the appropriate character device file automatically with
+udev, a rule like
+
+    KERNEL="rdma_cm", NAME="infiniband/%k", MODE="0666"
+
+can be used.  This will create the device node named
+
+    /dev/infiniband/rdma_cm
+
+or you can create it manually
+
+  mknod /dev/infiniband/rdma_cm c 231 255
+
+
+# Common issues
+
+Using multiple interfaces
+	The librdmacm does support multiple interfaces.  To make use
+	of multiple interfaces, however, you need to instruct linux
+	to only send ARP reples on the interface targetted in the ARP
+	request.  This can be done using a command similar to the
+	following:
+
+	sysctl -w net.ipv4.conf.all.arp_ignore=2
+
+	Without this change, it's possible for linux to resopnd to ARP
+	requests on a different interface (IP address) than the IP
+	address carried in the ARP request.  This causes the RDMA stack
+	to incorrectly map the remote IP address to the wrong RDMA
+	device.
+
+Using loopback
+	The librdmacm relies on ARP to resolve IP address to RDMA
+	addresses.  To support loopback connections between different
+	ports on the same system, ARP must be enabled for local
+	resolution:
+
+	sysctl net.ipv4.conf.all.accept_local=1
+
+	Without this setting, loopback connections may timeout
+	during address resolution.
diff --git a/librdmacm/README b/librdmacm/README
deleted file mode 100644
index e1f2227..0000000
--- a/librdmacm/README
+++ /dev/null
@@ -1,61 +0,0 @@
-This README is for userspace RDMA cm library.
-
-
-Building
-========
-To make this directory, run:
-./autogen.sh && ./configure && make && make install
-
-Typically the autogen and configure steps only need be done the first
-time unless configure.in or Makefile.am changes.
-
-Libraries are installed by default at /usr/local/lib.
-
-
-Device files
-============
-The userspace CMA uses a single device file regardless of the number
-of adapters or ports present.
-
-To create the appropriate character device file automatically with
-udev, a rule like
-
-    KERNEL="rdma_cm", NAME="infiniband/%k", MODE="0666"
-
-can be used.  This will create the device node named
-
-    /dev/infiniband/rdma_cm
-
-or you can create it manually
-
-  mknod /dev/infiniband/rdma_cm c 231 255
-
-
-Common issues
-=============
-
-Using multiple interfaces
-	The librdmacm does support multiple interfaces.  To make use
-	of multiple interfaces, however, you need to instruct linux
-	to only send ARP reples on the interface targetted in the ARP
-	request.  This can be done using a command similar to the
-	following:
-
-	sysctl -w net.ipv4.conf.all.arp_ignore=2
-
-	Without this change, it's possible for linux to resopnd to ARP
-	requests on a different interface (IP address) than the IP
-	address carried in the ARP request.  This causes the RDMA stack
-	to incorrectly map the remote IP address to the wrong RDMA
-	device.
-
-Using loopback
-	The librdmacm relies on ARP to resolve IP address to RDMA
-	addresses.  To support loopback connections between different
-	ports on the same system, ARP must be enabled for local
-	resolution:
-
-	sysctl net.ipv4.conf.all.accept_local=1
-
-	Without this setting, loopback connections may timeout
-	during address resolution.
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
