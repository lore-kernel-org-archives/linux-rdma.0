From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 03/5] infiniband-diags: ibqueryerrors; use #defines for
 CapabilityMask
Date: Wed, 27 Apr 2011 18:46:52 -0700
Message-ID: <20110427184652.cf4c2148.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 26 Apr 2011 22:18:27 -0700
Subject: [PATCH 03/5] infiniband-diags: ibqueryerrors; use #defines for CapabilityMask

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/ibdiag_common.h |    6 ++++++
 src/ibqueryerrors.c     |    8 ++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 9b2add7..b113cfe 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -35,6 +35,7 @@
 #ifndef _IBDIAG_COMMON_H_
 #define _IBDIAG_COMMON_H_
 
+#include <infiniband/iba/ib_types.h>
 #include <infiniband/mad.h>
 
 extern int ibverbose;
@@ -57,6 +58,11 @@ extern int ibd_timeout;
 } while (0)
 #define IBERROR(fmt, ...) iberror(__FUNCTION__, fmt, ## __VA_ARGS__)
 
+/* not all versions of ib_types.h will have this define */
+#ifndef IB_PM_PC_XMIT_WAIT_SUP
+#define IB_PM_PC_XMIT_WAIT_SUP (CL_HTON16(((uint16_t)1)<<12))
+#endif
+
 struct ibdiag_opt {
 	const char *name;
 	char letter;
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index e0a328b..71fb5f6 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -437,7 +437,7 @@ static int query_cap_mask(ib_portid_t * portid, char *node_name, int portnum,
 	/* ClassPortInfo should be supported as part of libibmad */
 	memcpy(&rc_cap_mask, pc + 2, sizeof(rc_cap_mask));	/* CapabilityMask */
 
-	*cap_mask = ntohs(rc_cap_mask);
+	*cap_mask = rc_cap_mask;
 	return 0;
 }
 
@@ -454,7 +454,7 @@ static int print_port(ib_portid_t * portid, uint16_t cap_mask, char *node_name,
 		       node_name, portid2str(portid), portnum);
 		return (0);
 	}
-	if (!(cap_mask & 0x1000)) {
+	if (!(cap_mask & IB_PM_PC_XMIT_WAIT_SUP)) {
 		/* if PortCounters:PortXmitWait not supported clear this counter */
 		uint32_t foo = 0;
 		mad_encode_field(pc, IB_PC_XMT_WAIT_F, &foo);
@@ -477,7 +477,7 @@ static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
 
 	if (clear_errors) {
 		mask |= 0xFFF;
-		if (cap_mask & 0x1000)
+		if (cap_mask & IB_PM_PC_XMIT_WAIT_SUP)
 			mask |= 0x10000;
 	}
 	if (clear_counts)
@@ -544,7 +544,7 @@ void print_node(ibnd_node_t * node, void *user_data)
 		}
 	}
 	if ((query_cap_mask(&portid, node_name, p, &cap_mask) == 0) &&
-	    (cap_mask & 0x100)) {
+	    (cap_mask & IB_PM_ALL_PORT_SELECT)) {
 		all_port_sup = 1;
 		if (!print_port(&portid, cap_mask, node_name, node,
 				0xFF, &header_printed)) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
