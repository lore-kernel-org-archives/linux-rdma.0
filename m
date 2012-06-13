From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] rdma/cm: Bind to a specific address family
Date: Wed, 13 Jun 2012 22:55:18 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A31551@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The rdma cm uses a single port space for all associated (tcp, udp,
etc.) port bindings, regardless of the address family that the
user binds to.  The result is that if a user binds to AF_INET,
but does not specify an IP address, the bind will occur for AF_INET6.
This causes an attempt to bind to the same port using AF_INET6 to
fail, and connection requests to AF_INET6 will match with the AF_INET
listener.  Align the behavior with sockets and restrict the bind
to AF_INET only.

Note that if a user binds to AF_INET6, we continue to bind the
specified port for AF_INET.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 79c7eeb..ef7f04c 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -139,6 +139,7 @@ struct rdma_id_private {
 	u8			srq;
 	u8			tos;
 	u8			reuseaddr;
+	u8			afonly;
 };
 
 struct cma_multicast {
@@ -1572,6 +1573,7 @@ static void cma_listen_on_dev(struct rdma_id_private *id_priv,
 	list_add_tail(&dev_id_priv->listen_list, &id_priv->listen_list);
 	atomic_inc(&id_priv->refcount);
 	dev_id_priv->internal_id = 1;
+	dev_id_priv->afonly = id_priv->afonly;
 
 	ret = rdma_listen(id, id_priv->backlog);
 	if (ret)
@@ -2183,22 +2185,24 @@ static int cma_check_port(struct rdma_bind_list *bind_list,
 	struct hlist_node *node;
 
 	addr = (struct sockaddr *) &id_priv->id.route.addr.src_addr;
-	if (cma_any_addr(addr) && !reuseaddr)
-		return -EADDRNOTAVAIL;
-
 	hlist_for_each_entry(cur_id, node, &bind_list->owners, node) {
 		if (id_priv == cur_id)
 			continue;
 
-		if ((cur_id->state == RDMA_CM_LISTEN) ||
-		    !reuseaddr || !cur_id->reuseaddr) {
-			cur_addr = (struct sockaddr *) &cur_id->id.route.addr.src_addr;
-			if (cma_any_addr(cur_addr))
-				return -EADDRNOTAVAIL;
+		if ((cur_id->state != RDMA_CM_LISTEN) && reuseaddr &&
+		    cur_id->reuseaddr)
+			continue;
 
-			if (!cma_addr_cmp(addr, cur_addr))
-				return -EADDRINUSE;
-		}
+		cur_addr = (struct sockaddr *) &cur_id->id.route.addr.src_addr;
+		if (id_priv->afonly && cur_id->afonly &&
+		    (addr->sa_family != cur_addr->sa_family))
+			continue;
+
+		if (cma_any_addr(addr) || cma_any_addr(cur_addr))
+			return -EADDRNOTAVAIL;
+
+		if (!cma_addr_cmp(addr, cur_addr))
+			return -EADDRINUSE;
 	}
 	return 0;
 }
@@ -2367,6 +2371,8 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	}
 
 	memcpy(&id->route.addr.src_addr, addr, ip_addr_size(addr));
+	if (addr->sa_family == AF_INET)
+		id_priv->afonly = 1;
 	ret = cma_get_port(id_priv);
 	if (ret)
 		goto err2;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
