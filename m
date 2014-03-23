From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 9/9] ibacm: Restructure acm_port_join
Date: Sun, 23 Mar 2014 13:18:21 -0700
Message-ID: <1395605901-9080-10-git-send-email-sean.hefty@intel.com>
References: <1395605901-9080-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395605901-9080-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Create a subroutine to process joining a single
endpoint that can be called directly in place of
joining all endpoints on a port.

This will make it easier to handle future changes that
affect a single endpoint, such as a pkey change.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   38 ++++++++++++++++++++++++--------------
 1 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 2d9ecee..14ef71a 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -1566,32 +1566,42 @@ out:
 	free(umad);
 }
 
+static void acm_ep_join(struct acm_ep *ep)
+{
+	struct acm_port *port;
+
+	port = ep->port;
+	acm_log(1, "%s\n", ep->id_string);
+
+	ep->mc_cnt = 0;
+	acm_join_group(ep, &port->base_gid, 0, 0, 0, min_rate, min_mtu);
+
+	if ((ep->state = ep->mc_dest[0].state) != ACM_READY)
+		return;
+
+	if ((route_prot == ACM_ROUTE_PROT_ACM) &&
+	    (port->rate != min_rate || port->mtu != min_mtu))
+		acm_join_group(ep, &port->base_gid, 0, 0, 0, port->rate, port->mtu);
+
+	acm_log(1, "join for %s complete\n", ep->id_string);
+}
+
 static void acm_port_join(struct acm_port *port)
 {
-	struct acm_device *dev;
 	struct acm_ep *ep;
 	DLIST_ENTRY *ep_entry;
 
-	dev = port->dev;
-	acm_log(1, "device %s port %d\n", dev->verbs->device->name,
+	acm_log(1, "device %s port %d\n", port->dev->verbs->device->name,
 		port->port_num);
 
 	for (ep_entry = port->ep_list.Next; ep_entry != &port->ep_list;
 		 ep_entry = ep_entry->Next) {
 
 		ep = container_of(ep_entry, struct acm_ep, entry);
-		ep->mc_cnt = 0;
-		acm_join_group(ep, &port->base_gid, 0, 0, 0, min_rate, min_mtu);
-
-		if ((ep->state = ep->mc_dest[0].state) != ACM_READY)
-			continue;
-
-		if ((route_prot == ACM_ROUTE_PROT_ACM) &&
-		    (port->rate != min_rate || port->mtu != min_mtu))
-			acm_join_group(ep, &port->base_gid, 0, 0, 0, port->rate, port->mtu);
+		acm_ep_join(ep);
 	}
-	acm_log(1, "joins for device %s port %d complete\n", dev->verbs->device->name,
-		port->port_num);
+	acm_log(1, "joins for device %s port %d complete\n",
+		port->dev->verbs->device->name, port->port_num);
 }
 
 static void acm_process_timeouts(void)
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
