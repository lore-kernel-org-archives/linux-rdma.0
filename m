From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
Date: Tue,  8 Dec 2015 12:33:02 -0500
Message-ID: <1449595982-20781-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In an insecure IB fabric, the default pkey in a port is 0xffff, where each
node is allowed to talk to any other node in the fabric, including the SA
node. However, in a secure fabric, to limit member access, not all nodes
can have the full-member default pkey 0xffff. A typical configuration is
to let SA node have pkey 0xffff while all other nodes have pkey 0x7fff; in
addition, each node can be assigned some other full-member pkeys, such as
0x8001 and 0x8002, so that it can be assigned to different partitions.
In this case, each node can access SA, and yet limits its other access to
only those nodes in its assigned partitions. In such a secure fabric,
however, ibacm will not work by interpreting "default" in its default
address file as 0xffff.

To solve the problem, this patch introduces the following priority to
interpret default pkey:
1. Find the first non-management full-member pkey;
2. If it fails, find pkey 0xffff;
3. If pkey 0xffff is not available, use the first pkey.
This approach will work in both securely and insecurely partitions
fabrics.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   52 +++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index ada0bfb..ce2797c 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -114,7 +114,8 @@ struct acmc_port {
 	union ibv_gid       *gid_tbl;
 	uint16_t            lid;
 	uint16_t            lid_mask;
-	int                 default_pkey_index;
+	int                 sa_pkey_index;
+	uint16_t            def_acm_pkey;
 };
 
 struct acmc_device {
@@ -2009,7 +2010,7 @@ static int acm_assign_ep_names(struct acmc_ep *ep)
 				continue;
 			}
 		} else {
-			pkey = 0xFFFF;
+			pkey = ep->port->def_acm_pkey;
 		}
 
 		if (!stricmp(dev_name, dev) &&
@@ -2202,7 +2203,11 @@ static void acm_port_up(struct acmc_port *port)
 	uint16_t pkey;
 	int i, ret;
 	struct acmc_prov_context *dev_ctx;
-	int index = -1;
+	int sa_index = -1;
+	int full_mgmt_index = -1;
+	uint16_t def_pkey = 0;
+	int first_pkey_index = -1;
+	uint16_t first_pkey = 0;
 
 	acm_log(1, "%s %d\n", port->dev->device.verbs->device->name, 
 		port->port.port_num);
@@ -2248,24 +2253,45 @@ static void acm_port_up(struct acmc_port *port)
 		goto err1;
 	}
 
-	/* Determine the default pkey first.
-	   Order of preference: 0xffff, 0x7fff, first pkey
-	*/
+	/* Determine the default pkey index for SA access first.
+	 *   Order of preference: 0xffff, 0x7fff, first pkey.
+	 * Determine the default pkey for parsing address file as well.
+	 *   order of preference: first full-member non-management pkey,
+	 *   0xffff, first pkey.
+	 */
 	for (i = 0; i < attr.pkey_tbl_len; i++) {
 		ret = ibv_query_pkey(port->dev->device.verbs, 
 				     port->port.port_num, i, &pkey);
 		if (ret)
 			continue;
 		pkey = ntohs(pkey);
-		if (pkey == 0xffff) {
-			index = i;
-			break;
-		}
-		else if (pkey == 0x7fff) {
-			index = i;
+		if (!(pkey & 0x7ffff))
+			continue;
+
+		if (first_pkey_index < 0) {
+			first_pkey_index = i;
+			first_pkey = pkey;
 		}
-	}
-	port->default_pkey_index = index < 0 ? 0: index;
+
+		if (pkey == 0xffff) {
+			sa_index = i;
+			full_mgmt_index = i;
+		} else if (pkey == 0x7fff) {
+			if (sa_index < 0)
+				sa_index = i;
+		} else if ((def_pkey == 0) && (pkey & 0x8000)) {
+			/* First full-member non-management pkey */
+			def_pkey = pkey;
+		}
+	}
+	port->sa_pkey_index = (sa_index < 0) ?
+		first_pkey_index : sa_index;
+	if (def_pkey)
+		port->def_acm_pkey = def_pkey;
+	else if (full_mgmt_index >= 0)
+		port->def_acm_pkey = 0xffff;
+	else
+		port->def_acm_pkey = first_pkey;
 
 	for (i = 0; i < attr.pkey_tbl_len; i++) {
 		ret = ibv_query_pkey(port->dev->device.verbs, 
@@ -2775,7 +2801,7 @@ int acm_send_sa_mad(struct acm_sa_mad *mad)
 	mad->umad.addr.qkey = port->sa_addr.qkey;
 	mad->umad.addr.lid = htons(port->sa_addr.lid);
 	mad->umad.addr.sl = port->sa_addr.sl;
-	mad->umad.addr.pkey_index = req->ep->port->default_pkey_index;
+	mad->umad.addr.pkey_index = req->ep->port->sa_pkey_index;
 
 	lock_acquire(&port->lock);
 	if (port->sa_credits && DListEmpty(&port->sa_wait)) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
