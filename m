From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH 4/22] [for 2.6.36] ib/addr: add AF_IB support to ip_addr_size
Date: Tue, 23 Mar 2010 10:57:20 -0700
Message-ID: <6FC0868C919240BE8297BEEF32F383D7@amr.corp.intel.com>
References: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2F3826558E79459EAD2A457A604221C1-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add support for AF_IB to ip_addr_size, and rename the function
to account for the change.  Give the compiler more control over
whether the call should be inline or not by moving the definition
into the .c file, removing the static inline, and exporting it.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/addr.c |   20 ++++++++++++++++++--
 drivers/infiniband/core/cma.c  |   12 ++++++------
 include/rdma/ib_addr.h         |    6 +-----
 3 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index abbb069..f73c5de 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -43,6 +43,7 @@
 #include <net/addrconf.h>
 #include <net/ip6_route.h>
 #include <rdma/ib_addr.h>
+#include <rdma/ib.h>
 
 MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("IB Address Translation");
@@ -68,6 +69,21 @@ static LIST_HEAD(req_list);
 static DECLARE_DELAYED_WORK(work, process_req);
 static struct workqueue_struct *addr_wq;
 
+int rdma_addr_size(struct sockaddr *addr)
+{
+	switch (addr->sa_family) {
+	case AF_INET:
+		return sizeof(struct sockaddr_in);
+	case AF_INET6:
+		return sizeof(struct sockaddr_in6);
+	case AF_IB:
+		return sizeof(struct sockaddr_ib);
+	default:
+		return 0;
+	}
+}
+EXPORT_SYMBOL(rdma_addr_size);
+
 void rdma_addr_register_client(struct rdma_addr_client *client)
 {
 	atomic_set(&client->refcount, 1);
@@ -366,12 +382,12 @@ int rdma_resolve_ip(struct rdma_addr_client *client,
 			goto err;
 		}
 
-		memcpy(src_in, src_addr, ip_addr_size(src_addr));
+		memcpy(src_in, src_addr, rdma_addr_size(src_addr));
 	} else {
 		src_in->sa_family = dst_addr->sa_family;
 	}
 
-	memcpy(dst_in, dst_addr, ip_addr_size(dst_addr));
+	memcpy(dst_in, dst_addr, rdma_addr_size(dst_addr));
 	req->addr = addr;
 	req->callback = callback;
 	req->context = context;
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 6460fbf..ac57155 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1468,7 +1468,7 @@ static void cma_listen_on_dev(struct rdma_id_private *id_priv,
 
 	dev_id_priv->state = CMA_ADDR_BOUND;
 	memcpy(&id->route.addr.src_addr, &id_priv->id.route.addr.src_addr,
-	       ip_addr_size((struct sockaddr *) &id_priv->id.route.addr.src_addr));
+	       rdma_addr_size((struct sockaddr *) &id_priv->id.route.addr.src_addr));
 
 	cma_attach_to_dev(dev_id_priv, cma_dev);
 	list_add_tail(&dev_id_priv->listen_list, &id_priv->listen_list);
@@ -1834,7 +1834,7 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 		event.status = status;
 	} else {
 		memcpy(&id_priv->id.route.addr.src_addr, src_addr,
-		       ip_addr_size(src_addr));
+		       rdma_addr_size(src_addr));
 		event.event = RDMA_CM_EVENT_ADDR_RESOLVED;
 	}
 
@@ -1924,7 +1924,7 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 		return -EINVAL;
 
 	atomic_inc(&id_priv->refcount);
-	memcpy(&id->route.addr.dst_addr, dst_addr, ip_addr_size(dst_addr));
+	memcpy(&id->route.addr.dst_addr, dst_addr, rdma_addr_size(dst_addr));
 	if (cma_any_addr(dst_addr))
 		ret = cma_resolve_loopback(id_priv);
 	else
@@ -2147,7 +2147,7 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 			goto err1;
 	}
 
-	memcpy(&id->route.addr.src_addr, addr, ip_addr_size(addr));
+	memcpy(&id->route.addr.src_addr, addr, rdma_addr_size(addr));
 	ret = cma_get_port(id_priv);
 	if (ret)
 		goto err2;
@@ -2807,7 +2807,7 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	if (!mc)
 		return -ENOMEM;
 
-	memcpy(&mc->addr, addr, ip_addr_size(addr));
+	memcpy(&mc->addr, addr, rdma_addr_size(addr));
 	mc->context = context;
 	mc->id_priv = id_priv;
 
@@ -2842,7 +2842,7 @@ void rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 	id_priv = container_of(id, struct rdma_id_private, id);
 	spin_lock_irq(&id_priv->lock);
 	list_for_each_entry(mc, &id_priv->mc_list, list) {
-		if (!memcmp(&mc->addr, addr, ip_addr_size(addr))) {
+		if (!memcmp(&mc->addr, addr, rdma_addr_size(addr))) {
 			list_del(&mc->list);
 			spin_unlock_irq(&id_priv->lock);
 
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index fa0d52b..9e06769 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -99,11 +99,7 @@ void rdma_addr_cancel(struct rdma_dev_addr *addr);
 int rdma_copy_addr(struct rdma_dev_addr *dev_addr, struct net_device *dev,
 	      const unsigned char *dst_dev_addr);
 
-static inline int ip_addr_size(struct sockaddr *addr)
-{
-	return addr->sa_family == AF_INET6 ?
-	       sizeof(struct sockaddr_in6) : sizeof(struct sockaddr_in);
-}
+int rdma_addr_size(struct sockaddr *addr);
 
 static inline u16 ib_addr_get_pkey(struct rdma_dev_addr *dev_addr)
 {



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
