From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH 7/22] [for 2.6.36] rdma/cm: do not modify sa_family when setting loopback address
Date: Tue, 23 Mar 2010 11:03:02 -0700
Message-ID: <07356581EBDF4A50823E4DAFBD6BDBDC@amr.corp.intel.com>
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

cma_resolve_loopback is called after an rdma_cm_id has been
bound to a specific sa_family and port.  Once the
source sa_family for the id has been set, do not modify it.
Only the actual IP address portion of the source address
needs to be set.

As part of this fix, we can simplify setting the source address
by moving the loopback address assignment from cma_resolve_loopback
to cma_bind_loopback.  cma_bind_loopback is only invoked when
the source address is the loopback address.

Finally, add loopback support for AF_IB as part of the change.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/cma.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 0a3bbf9..7981a85 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1776,6 +1776,23 @@ err:
 }
 EXPORT_SYMBOL(rdma_resolve_route);
 
+static void cma_set_loopback(struct sockaddr *addr)
+{
+	switch (addr->sa_family) {
+	case AF_INET:
+		((struct sockaddr_in *) addr)->sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+		break;
+	case AF_INET6:
+		ipv6_addr_set(&((struct sockaddr_in6 *) addr)->sin6_addr,
+			      0, 0, 0, htonl(1));
+		break;
+	default:
+		ib_addr_set(&((struct sockaddr_ib *) addr)->sib_addr,
+			    0, 0, 0, htonl(1));
+		break;
+	}
+}
+
 static int cma_bind_loopback(struct rdma_id_private *id_priv)
 {
 	struct cma_device *cma_dev;
@@ -1816,6 +1833,7 @@ port_found:
 	ib_addr_set_pkey(&id_priv->id.route.addr.dev_addr, pkey);
 	id_priv->id.port_num = p;
 	cma_attach_to_dev(id_priv, cma_dev);
+	cma_set_loopback((struct sockaddr *) &id_priv->id.route.addr.src_addr);
 out:
 	mutex_unlock(&lock);
 	return ret;
@@ -1870,7 +1888,6 @@ out:
 static int cma_resolve_loopback(struct rdma_id_private *id_priv)
 {
 	struct cma_work *work;
-	struct sockaddr *src, *dst;
 	union ib_gid gid;
 	int ret;
 
@@ -1887,18 +1904,6 @@ static int cma_resolve_loopback(struct rdma_id_private *id_priv)
 	rdma_addr_get_sgid(&id_priv->id.route.addr.dev_addr, &gid);
 	rdma_addr_set_dgid(&id_priv->id.route.addr.dev_addr, &gid);
 
-	src = (struct sockaddr *) &id_priv->id.route.addr.src_addr;
-	if (cma_zero_addr(src)) {
-		dst = (struct sockaddr *) &id_priv->id.route.addr.dst_addr;
-		if ((src->sa_family = dst->sa_family) == AF_INET) {
-			((struct sockaddr_in *) src)->sin_addr.s_addr =
-				((struct sockaddr_in *) dst)->sin_addr.s_addr;
-		} else {
-			ipv6_addr_copy(&((struct sockaddr_in6 *) src)->sin6_addr,
-				       &((struct sockaddr_in6 *) dst)->sin6_addr);
-		}
-	}
-
 	work->id = id_priv;
 	INIT_WORK(&work->work, cma_work_handler);
 	work->old_state = CMA_ADDR_QUERY;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
