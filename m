From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH V2 1/1] [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
Date: Thu, 10 Dec 2015 07:56:22 -0500
Message-ID: <1449752182-23245-1-git-send-email-kaike.wan@intel.com>
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

To solve the problem, we will use pkey 0 as the default pkey, in
line with ipoib convention.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Change since v1:
- Use pkey 0 as the default pkey for parsing address file.

 src/acm.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index ada0bfb..8b6d762 100644
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
@@ -2203,6 +2204,7 @@ static void acm_port_up(struct acmc_port *port)
 	int i, ret;
 	struct acmc_prov_context *dev_ctx;
 	int index = -1;
+	uint16_t first_pkey = 0;
 
 	acm_log(1, "%s %d\n", port->dev->device.verbs->device->name, 
 		port->port.port_num);
@@ -2248,15 +2250,18 @@ static void acm_port_up(struct acmc_port *port)
 		goto err1;
 	}
 
-	/* Determine the default pkey first.
-	   Order of preference: 0xffff, 0x7fff, first pkey
-	*/
+	/* Determine the default pkey for SA access first.
+	 *     Order of preference: 0xffff, 0x7fff
+	 * Use the first pkey as the default pkey for parsing address file.
+	 */
 	for (i = 0; i < attr.pkey_tbl_len; i++) {
 		ret = ibv_query_pkey(port->dev->device.verbs, 
 				     port->port.port_num, i, &pkey);
 		if (ret)
 			continue;
 		pkey = ntohs(pkey);
+		if (i == 0)
+			first_pkey = pkey;
 		if (pkey == 0xffff) {
 			index = i;
 			break;
@@ -2265,7 +2270,8 @@ static void acm_port_up(struct acmc_port *port)
 			index = i;
 		}
 	}
-	port->default_pkey_index = index < 0 ? 0: index;
+	port->sa_pkey_index = index < 0 ? 0 : index;
+	port->def_acm_pkey = first_pkey;
 
 	for (i = 0; i < attr.pkey_tbl_len; i++) {
 		ret = ibv_query_pkey(port->dev->device.verbs, 
@@ -2775,7 +2781,7 @@ int acm_send_sa_mad(struct acm_sa_mad *mad)
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
