From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 15/23] rdmacm: Move documentation to Documentation/
Date: Wed, 21 Sep 2016 16:08:41 -0600
Message-ID: <1474495729-17604-16-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

And drop bits that are outdated or replaced by top-level Documentation.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 librdmacm/README => Documentation/librdmacm.md | 27 ++++++--------------------
 1 file changed, 6 insertions(+), 21 deletions(-)
 rename librdmacm/README => Documentation/librdmacm.md (65%)

diff --git a/librdmacm/README b/Documentation/librdmacm.md
similarity index 65%
rename from librdmacm/README
rename to Documentation/librdmacm.md
index e1f222740144..817383661c06 100644
--- a/librdmacm/README
+++ b/Documentation/librdmacm.md
@@ -1,19 +1,5 @@
-This README is for userspace RDMA cm library.
+# Device files
 
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
 The userspace CMA uses a single device file regardless of the number
 of adapters or ports present.
 
@@ -31,17 +17,16 @@ or you can create it manually
   mknod /dev/infiniband/rdma_cm c 231 255
 
 
-Common issues
-=============
+# Common issues
 
 Using multiple interfaces
-	The librdmacm does support multiple interfaces.  To make use
+:	The librdmacm does support multiple interfaces.  To make use
 	of multiple interfaces, however, you need to instruct linux
 	to only send ARP reples on the interface targetted in the ARP
 	request.  This can be done using a command similar to the
 	following:
 
-	sysctl -w net.ipv4.conf.all.arp_ignore=2
+		sysctl -w net.ipv4.conf.all.arp_ignore=2
 
 	Without this change, it's possible for linux to resopnd to ARP
 	requests on a different interface (IP address) than the IP
@@ -50,12 +35,12 @@ Using multiple interfaces
 	device.
 
 Using loopback
-	The librdmacm relies on ARP to resolve IP address to RDMA
+:	The librdmacm relies on ARP to resolve IP address to RDMA
 	addresses.  To support loopback connections between different
 	ports on the same system, ARP must be enabled for local
 	resolution:
 
-	sysctl net.ipv4.conf.all.accept_local=1
+		sysctl net.ipv4.conf.all.accept_local=1
 
 	Without this setting, loopback connections may timeout
 	during address resolution.
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
