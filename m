From: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
Subject: [PATCH] rdma: replace deprecated ifconfig in doc
Date: Sun, 8 Mar 2015 16:36:14 -0700
Message-ID: <20150308163614.1cb3da70@urahara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The ifconfig command has been deprecated for many years.
To encourage new users not to continue using it and learning
iproute2; the ifconfig should not be used in examples.

Signed-off-by: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>


--- a/Documentation/filesystems/nfs/nfs-rdma.txt	2014-09-28 16:27:20.393505440 -0700
+++ b/Documentation/filesystems/nfs/nfs-rdma.txt	2015-03-08 16:33:21.483985810 -0700
@@ -187,8 +187,10 @@ Check RDMA and NFS Setup
     To further test the InfiniBand software stack, use IPoIB (this
     assumes you have two IB hosts named host1 and host2):
 
-    host1$ ifconfig ib0 a.b.c.x
-    host2$ ifconfig ib0 a.b.c.y
+    host1$ ip link set dev ib0 up
+    host1$ ip address add dev ib0 a.b.c.x
+    host2$ ip link set dev ib0 up
+    host2$ ip address add dev ib0 a.b.c.y
     host1$ ping a.b.c.y
     host2$ ping a.b.c.x
 
@@ -229,7 +231,8 @@ NFS/RDMA Setup
 
     $ modprobe ib_mthca
     $ modprobe ib_ipoib
-    $ ifconfig ib0 a.b.c.d
+    $ ip li set dev ib0 up
+    $ ip addr add dev ib0 a.b.c.d
 
     NOTE: use unique addresses for the client and server
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
