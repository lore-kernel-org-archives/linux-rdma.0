From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH ibacm 6/8] acm.c: Send multicast joins to SA on default partition
Date: Tue, 06 Aug 2013 07:45:37 -0400
Message-ID: <5200E1E1.4020403@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


rather than on EP partition

Prefer full default partition in case both full and limited
pkeys for default partition are in pkey table.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/acm.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 146d6e8..b35c986 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -121,6 +121,7 @@ struct acm_port {
 	int                 subnet_timeout;
 	int                 gid_cnt;
 	uint16_t            pkey_cnt;
+	uint16_t            default_pkey_ix;
 	uint16_t            lid;
 	uint16_t            lid_mask;
 	uint8_t             port_num;
@@ -1524,7 +1525,7 @@ static void acm_join_group(struct acm_ep *ep, union ibv_gid *port_gid,
 	port = ep->port;
 	umad->addr.qpn = htonl(port->sa_dest.remote_qpn);
 	umad->addr.qkey = htonl(ACM_QKEY);
-	umad->addr.pkey_index = ep->pkey_index;
+	umad->addr.pkey_index = port->default_pkey_ix;
 	umad->addr.lid = htons(port->sa_dest.av.dlid);
 	umad->addr.sl = port->sa_dest.av.sl;
 	umad->addr.path_bits = port->sa_dest.av.src_path_bits;
@@ -3170,6 +3171,7 @@ static void acm_port_up(struct acm_port *port)
 	union ibv_gid gid;
 	uint16_t pkey;
 	int i, ret;
+	int is_full_default_pkey_set = 0;
 
 	acm_log(1, "%s %d\n", port->dev->verbs->device->name, port->port_num);
 	ret = ibv_query_port(port->dev->verbs, port->port_num, &attr);
@@ -3211,9 +3213,18 @@ static void acm_port_up(struct acm_port *port)
 	atomic_set(&port->sa_dest.refcnt, 1);
 	for (i = 0; i < attr.pkey_tbl_len; i++) {
 		ret = ibv_query_pkey(port->dev->verbs, port->port_num, i, &pkey);
-		if (ret || !(ntohs(pkey) & 0x7fff))
+		if (ret)
+			continue;
+		pkey = ntohs(pkey);
+		if (!(pkey & 0x7fff))
 			continue;
 		port->pkey_cnt++;
+		/* Determine pkey index for default partition with preference for full membership */
+		if (!is_full_default_pkey_set && (pkey & 0x7fff) == 0x7fff) {
+			port->default_pkey_ix = i;
+			if (pkey & 0x8000)
+				is_full_default_pkey_set = 1;
+		}
 		acm_ep_up(port, (uint16_t) i);
 	}
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
