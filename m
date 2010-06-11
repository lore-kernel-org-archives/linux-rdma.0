From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Fri, 11 Jun 2010 07:47:46 -0500
Message-ID: <20100611124746.GA2292@CTUNG-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Current iWARP implementations make use of the TCP port space for iWARP
connections without synchornizing with the host TCP stack.  This can
lead to both host TCP and offloaded iWARP connections for the iWARP
interface to use the same TCP port.  The combined traffic will result
in undesirable behaviors from connection failures to resets.

This patch resolves the issue by allocating a kernel socket consuming
the TCP port for the iWARP connection upon connection creation and
freeing the socket once the iWARP connection is destroyed.

This functionality is needed for iWARP adapters that are both a L2 and
offload iWARP device.  Applications can create and use host TCP and
iWARP connections over the same interface without additional
administrative overhead and complication needed to manage TCP port space
manually.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
V2 changes:

*  Fix compilation warning in cma_0100_unified_tcp_ports.patch

   Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

  -			ip_addr_size(&id_priv->id.route.addr.src_addr));
  +			ip_addr_size((struct sockaddr *) &id_priv->id.route.addr.src_addr));


*  IB/core: fix build warning

   Eliminates the following build warning:

      CC [M]  ./drivers/infiniband/core/cma.o
    ./drivers/infiniband/core/cma.c: In function 'cma_get_tcp_port':
    ./drivers/infiniband/core/cma.c:2076: warning: passing argument 1 of 'ip_addr_size' from incompatible pointer type

    Signed-off-by: John Gregor <john.gregor-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Yannick Cote <yannick.cote-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

  -	size = ip_addr_size(&id_priv->id.route.addr.src_addr);
  +	size = ip_addr_size((struct sockaddr *) &id_priv->id.route.addr.src_addr);

* Add getname

  Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

* Change default unify_tcp_port_space to 1

  Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

 drivers/infiniband/core/cma.c |   46 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index b930b81..d5855f9 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -56,6 +56,11 @@ MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("Generic RDMA CM Agent");
 MODULE_LICENSE("Dual BSD/GPL");
 
+int unify_tcp_port_space = 1;
+module_param(unify_tcp_port_space, int, 0644);
+MODULE_PARM_DESC(unify_tcp_port_space, "Unify the host TCP and RDMA port "
+		 "space allocation (default=1)");
+
 #define CMA_CM_RESPONSE_TIMEOUT 20
 #define CMA_MAX_CM_RETRIES 15
 #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)
@@ -118,6 +123,7 @@ struct rdma_id_private {
 	struct rdma_cm_id	id;
 
 	struct rdma_bind_list	*bind_list;
+	struct socket		*sock;
 	struct hlist_node	node;
 	struct list_head	list; /* listen_any_list or cma_device.list */
 	struct list_head	listen_list; /* per device listens */
@@ -806,6 +812,8 @@ static void cma_release_port(struct rdma_id_private *id_priv)
 		kfree(bind_list);
 	}
 	mutex_unlock(&lock);
+	if (id_priv->sock)
+		sock_release(id_priv->sock);
 }
 
 static void cma_leave_mc_groups(struct rdma_id_private *id_priv)
@@ -2035,6 +2043,37 @@ static int cma_use_port(struct idr *ps, struct rdma_id_private *id_priv)
 	return 0;
 }
 
+static int cma_get_tcp_port(struct rdma_id_private *id_priv)
+{
+	int ret;
+	int size;
+	struct socket *sock;
+
+	ret = sock_create_kern(AF_INET, SOCK_STREAM, IPPROTO_TCP, &sock);
+	if (ret)
+		return ret;
+
+	size = ip_addr_size((struct sockaddr *) &id_priv->id.route.addr.src_addr);
+
+	ret = sock->ops->bind(sock,
+			(struct sockaddr *) &id_priv->id.route.addr.src_addr,
+			size);
+	if (ret)
+		goto err;
+
+	ret = sock->ops->getname(sock,
+			(struct sockaddr *) &id_priv->id.route.addr.src_addr,
+			&size, 0);
+	if (ret)
+		goto err;
+
+	id_priv->sock = sock;
+	return 0;
+err:
+	sock_release(sock);
+	return ret;
+}
+
 static int cma_get_port(struct rdma_id_private *id_priv)
 {
 	struct idr *ps;
@@ -2046,6 +2085,11 @@ static int cma_get_port(struct rdma_id_private *id_priv)
 		break;
 	case RDMA_PS_TCP:
 		ps = &tcp_ps;
+		if (unify_tcp_port_space) {
+			ret = cma_get_tcp_port(id_priv);
+			if (ret)
+				goto out;
+		}
 		break;
 	case RDMA_PS_UDP:
 		ps = &udp_ps;
@@ -2063,7 +2107,7 @@ static int cma_get_port(struct rdma_id_private *id_priv)
 	else
 		ret = cma_use_port(ps, id_priv);
 	mutex_unlock(&lock);
-
+out:
 	return ret;
 }
 
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
