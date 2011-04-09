From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/4] libibmad/gs.c: In pma_query_via/performance_reset_via,
 set errno
Date: Sat, 09 Apr 2011 11:21:47 -0400
Message-ID: <4DA0798B.5040904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


according to rpc error field

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/gs.c b/src/gs.c
index 3cb2b25..78b8615 100644
--- a/src/gs.c
+++ b/src/gs.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
+ * Copyright (c) 2011 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -38,6 +39,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <errno.h>
 
 #include <infiniband/umad.h>
 #include <infiniband/mad.h>
@@ -51,6 +53,7 @@ uint8_t *pma_query_via(void *rcvbuf, ib_portid_t * dest, int port,
 {
 	ib_rpc_t rpc = { 0 };
 	int lid = dest->lid;
+	void *p_ret;
 
 	DEBUG("lid %u port %d", lid, port);
 
@@ -75,7 +78,9 @@ uint8_t *pma_query_via(void *rcvbuf, ib_portid_t * dest, int port,
 	if (!dest->qkey)
 		dest->qkey = IB_DEFAULT_QP1_QKEY;
 
-	return mad_rpc(srcport, &rpc, dest, rcvbuf, rcvbuf);
+	p_ret = mad_rpc(srcport, &rpc, dest, rcvbuf, rcvbuf);
+	errno = rpc.error;
+	return p_ret;
 }
 
 uint8_t *performance_reset_via(void *rcvbuf, ib_portid_t * dest,
@@ -84,6 +89,7 @@ uint8_t *performance_reset_via(void *rcvbuf, ib_portid_t * dest,
 {
 	ib_rpc_t rpc = { 0 };
 	int lid = dest->lid;
+	void *p_ret;
 
 	DEBUG("lid %u port %d mask 0x%x", lid, port, mask);
 
@@ -115,5 +121,7 @@ uint8_t *performance_reset_via(void *rcvbuf, ib_portid_t * dest,
 	if (!dest->qkey)
 		dest->qkey = IB_DEFAULT_QP1_QKEY;
 
-	return mad_rpc(srcport, &rpc, dest, rcvbuf, rcvbuf);
+	p_ret = mad_rpc(srcport, &rpc, dest, rcvbuf, rcvbuf);
+	errno = rpc.error;
+	return p_ret;
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
