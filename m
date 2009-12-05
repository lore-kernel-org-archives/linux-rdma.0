From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: IB/documentation: fix grammar in ipoib.txt
Date: Sat, 5 Dec 2009 14:29:24 +0100
Message-ID: <200912051429.24408.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Single-sentence grammar fix for Documentation/infiniband/ipoib.txt.

Signed-off-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

diff --git a/Documentation/infiniband/ipoib.txt b/Documentation/infiniband/ipoib.txt
index 6d40f00..64eeb55 100644
--- a/Documentation/infiniband/ipoib.txt
+++ b/Documentation/infiniband/ipoib.txt
@@ -36,11 +36,11 @@ Datagram vs Connected modes
   fabric with a 2K MTU, the IPoIB MTU will be 2048 - 4 = 2044 bytes.
 
   In connected mode, the IB RC (Reliable Connected) transport is used.
-  Connected mode is to takes advantage of the connected nature of the
-  IB transport and allows an MTU up to the maximal IP packet size of
-  64K, which reduces the number of IP packets needed for handling
-  large UDP datagrams, TCP segments, etc and increases the performance
-  for large messages.
+  Connected mode takes advantage of the connected nature of the IB
+  transport and allows an MTU up to the maximal IP packet size of 64K,
+  which reduces the number of IP packets needed for handling large UDP
+  datagrams, TCP segments, etc and increases the performance for large
+  messages.
 
   In connected mode, the interface's UD QP is still used for multicast
   and communication with peers that don't support connected mode. In
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
