From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 8/9] ibacm: Store the base GID with acm_port
Date: Sun, 23 Mar 2014 13:18:20 -0700
Message-ID: <1395605901-9080-9-git-send-email-sean.hefty@intel.com>
References: <1395605901-9080-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395605901-9080-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Record the base GID of a port with acm_port.  This avoids
needing to query again for it later.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index eba027d..2d9ecee 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -117,6 +117,7 @@ struct acm_port {
 	int                 mad_portid;
 	int                 mad_agentid;
 	struct acm_dest     sa_dest;
+	union ibv_gid	    base_gid;
 	enum ibv_port_state state;
 	enum ibv_mtu        mtu;
 	enum ibv_rate       rate;
@@ -1569,34 +1570,25 @@ static void acm_port_join(struct acm_port *port)
 {
 	struct acm_device *dev;
 	struct acm_ep *ep;
-	union ibv_gid port_gid;
 	DLIST_ENTRY *ep_entry;
-	int ret;
 
 	dev = port->dev;
 	acm_log(1, "device %s port %d\n", dev->verbs->device->name,
 		port->port_num);
 
-	ret = ibv_query_gid(dev->verbs, port->port_num, 0, &port_gid);
-	if (ret) {
-		acm_log(0, "ERROR - ibv_query_gid %d device %s port %d\n",
-			ret, dev->verbs->device->name, port->port_num);
-		return;
-	}
-
 	for (ep_entry = port->ep_list.Next; ep_entry != &port->ep_list;
 		 ep_entry = ep_entry->Next) {
 
 		ep = container_of(ep_entry, struct acm_ep, entry);
 		ep->mc_cnt = 0;
-		acm_join_group(ep, &port_gid, 0, 0, 0, min_rate, min_mtu);
+		acm_join_group(ep, &port->base_gid, 0, 0, 0, min_rate, min_mtu);
 
 		if ((ep->state = ep->mc_dest[0].state) != ACM_READY)
 			continue;
 
 		if ((route_prot == ACM_ROUTE_PROT_ACM) &&
 		    (port->rate != min_rate || port->mtu != min_mtu))
-			acm_join_group(ep, &port_gid, 0, 0, 0, port->rate, port->mtu);
+			acm_join_group(ep, &port->base_gid, 0, 0, 0, port->rate, port->mtu);
 	}
 	acm_log(1, "joins for device %s port %d complete\n", dev->verbs->device->name,
 		port->port_num);
@@ -3206,6 +3198,9 @@ static void acm_port_up(struct acm_port *port)
 		ret = ibv_query_gid(port->dev->verbs, port->port_num, port->gid_cnt, &gid);
 		if (ret || !gid.global.interface_id)
 			break;
+
+		if (port->gid_cnt == 0)
+			port->base_gid = gid;
 	}
 
 	port->lid = attr.lid;
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
