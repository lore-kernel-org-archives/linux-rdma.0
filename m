From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/1] ibacm: Use pkey 0xffff or 0x7fff for SA query
Date: Thu, 19 Mar 2015 13:28:37 -0400
Message-ID: <1426786117-24257-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Currently, ibacm uses the first pkey on the local port to query SA. More
appropriately, it should use either 0xffff or 0x7fff for SA query.
However, if the local port is not configured with either pkey, ibacm will
continue to use the first pkey.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 815a916..7649725 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -106,6 +106,7 @@ struct acmc_port {
 	union ibv_gid       *gid_tbl;
 	uint16_t            lid;
 	uint16_t            lid_mask;
+	int                 default_pkey_index;
 };
 
 struct acmc_device {
@@ -1844,6 +1845,7 @@ static void acm_port_up(struct acmc_port *port)
 	uint16_t pkey;
 	int i, ret;
 	struct acmc_prov_context *dev_ctx;
+	int index = -1;
 
 	acm_log(1, "%s %d\n", port->dev->device.verbs->device->name, 
 		port->port.port_num);
@@ -1889,6 +1891,25 @@ static void acm_port_up(struct acmc_port *port)
 		goto err1;
 	}
 
+	/* Determine the default pkey first.
+	   Order of preference: 0xffff, 0x7fff, first pkey
+	*/
+	for (i = 0; i < attr.pkey_tbl_len; i++) {
+		ret = ibv_query_pkey(port->dev->device.verbs, 
+				     port->port.port_num, i, &pkey);
+		if (ret)
+			continue;
+		pkey = ntohs(pkey);
+		if (pkey == 0xffff) {
+			index = i;
+			break;
+		}
+		else if (pkey == 0x7fff) {
+			index = i;
+		}
+	}
+	port->default_pkey_index = index < 0 ? 0: index;
+
 	for (i = 0; i < attr.pkey_tbl_len; i++) {
 		ret = ibv_query_pkey(port->dev->device.verbs, 
 				     port->port.port_num, i, &pkey);
@@ -2397,7 +2418,7 @@ int acm_send_sa_mad(struct acm_sa_mad *mad)
 	mad->umad.addr.qkey = port->sa_addr.qkey;
 	mad->umad.addr.lid = htons(port->sa_addr.lid);
 	mad->umad.addr.sl = port->sa_addr.sl;
-	// TODO: mad->umad.addr.pkey_index = req->ep->?;
+	mad->umad.addr.pkey_index = req->ep->port->default_pkey_index;
 
 	lock_acquire(&port->lock);
 	if (port->sa_credits && DListEmpty(&port->sa_wait)) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
