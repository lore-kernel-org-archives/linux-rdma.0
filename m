From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2 3/3] libibmad/vendor.c: In ib_vendor_call_via, set errno
Date: Wed, 27 Apr 2011 07:14:41 -0400
Message-ID: <4DB7FAA1.9080606@dev.mellanox.co.il>
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
diff --git a/src/vendor.c b/src/vendor.c
index 11efd76..22d6843 100644
--- a/src/vendor.c
+++ b/src/vendor.c
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
 
 #include <infiniband/mad.h>
 #include "mad_internal.h"
@@ -61,8 +63,10 @@ uint8_t *ib_vendor_call_via(void *data, ib_portid_t * portid,
 			    ib_vendor_call_t * call,
 			    struct ibmad_port * srcport)
 {
-	ib_rpc_t rpc = { 0 };
+	ib_rpc_v1_t rpc = { 0 };
+	ib_rpc_t *rpcold = (ib_rpc_t *)(void *)&rpc;
 	int range1 = 0, resp_expected;
+	void *p_ret;
 
 	DEBUG("route %s data %p", portid2str(portid), data);
 	if (portid->lid <= 0)
@@ -74,7 +78,7 @@ uint8_t *ib_vendor_call_via(void *data, ib_portid_t * portid,
 
 	resp_expected = response_expected(call->method);
 
-	rpc.mgtclass = call->mgmt_class;
+	rpc.mgtclass = call->mgmt_class | IB_MAD_RPC_VERSION1;
 
 	rpc.method = call->method;
 	rpc.attr.id = call->attrid;
@@ -97,8 +101,11 @@ uint8_t *ib_vendor_call_via(void *data, ib_portid_t * portid,
 	if (!portid->qkey)
 		portid->qkey = IB_DEFAULT_QP1_QKEY;
 
-	if (resp_expected)
-		return mad_rpc_rmpp(srcport, &rpc, portid, 0, data);	/* FIXME: no RMPP for now */
+	if (resp_expected) {
+		p_ret = mad_rpc_rmpp(srcport, rpcold, portid, 0, data);	/* FIXME: no RMPP for now */
+		errno = rpc.error;
+		return p_ret;
+	}
 
-	return mad_send_via(&rpc, portid, 0, data, srcport) < 0 ? 0 : data;	/* FIXME: no RMPP for now */
+	return mad_send_via(rpcold, portid, 0, data, srcport) < 0 ? 0 : data;	/* FIXME: no RMPP for now */
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
