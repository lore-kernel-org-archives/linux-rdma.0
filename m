From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3 v2] rdma/cm: Allow user to restrict listens to bound
 address family
Date: Thu, 14 Jun 2012 20:31:39 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A31775@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Provide an option for the user to specify that listens should
only accept connections where the incoming address family
matches that of the locally bound address.  This is used to
support the equivalent of IPV6_V6ONLY socket option, which
allows an app to only accept connection requests directed
to IPv6 addresses.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes from v1: Need to record whether user has set afonly option before binding

 drivers/infiniband/core/cma.c  |   35 +++++++++++++++++++++++++++++++----
 drivers/infiniband/core/ucma.c |    7 +++++++
 include/rdma/rdma_cm.h         |   10 ++++++++++
 include/rdma/rdma_user_cm.h    |    1 +
 4 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 9d83491..467f2fb 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -98,6 +98,10 @@ struct rdma_bind_list {
 	unsigned short		port;
 };
 
+enum {
+	CMA_OPTION_AFONLY,
+};
+
 /*
  * Device removal can occur at anytime, so we need extra handling to
  * serialize notifying the user of device removal with other callbacks.
@@ -136,6 +140,7 @@ struct rdma_id_private {
 	u32			qkey;
 	u32			qp_num;
 	pid_t			owner;
+	u32			options;
 	u8			srq;
 	u8			tos;
 	u8			reuseaddr;
@@ -2100,6 +2105,26 @@ int rdma_set_reuseaddr(struct rdma_cm_id *id, int reuse)
 }
 EXPORT_SYMBOL(rdma_set_reuseaddr);
 
+int rdma_set_afonly(struct rdma_cm_id *id, int afonly)
+{
+	struct rdma_id_private *id_priv;
+	unsigned long flags;
+	int ret;
+
+	id_priv = container_of(id, struct rdma_id_private, id);
+	spin_lock_irqsave(&id_priv->lock, flags);
+	if (id_priv->state == RDMA_CM_IDLE || id_priv->state == RDMA_CM_ADDR_BOUND) {
+		id_priv->options |= (1 << CMA_OPTION_AFONLY);
+		id_priv->afonly = afonly;
+		ret = 0;
+	} else {
+		ret = -EINVAL;
+	}
+	spin_unlock_irqrestore(&id_priv->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(rdma_set_afonly);
+
 static void cma_bind_port(struct rdma_bind_list *bind_list,
 			  struct rdma_id_private *id_priv)
 {
@@ -2375,10 +2400,12 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	}
 
 	memcpy(&id->route.addr.src_addr, addr, ip_addr_size(addr));
-	if (addr->sa_family == AF_INET)
-		id_priv->afonly = 1;
-	else if (addr->sa_family == AF_INET6)
-		id_priv->afonly = init_net.ipv6.sysctl.bindv6only;
+	if (!(id_priv->options & (1 << CMA_OPTION_AFONLY))) {
+		if (addr->sa_family == AF_INET)
+			id_priv->afonly = 1;
+		else if (addr->sa_family == AF_INET6)
+			id_priv->afonly = init_net.ipv6.sysctl.bindv6only;
+	}
 	ret = cma_get_port(id_priv);
 	if (ret)
 		goto err2;
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 5034a87..7bf93d6 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -916,6 +916,13 @@ static int ucma_set_option_id(struct ucma_context *ctx, int optname,
 		}
 		ret = rdma_set_reuseaddr(ctx->cm_id, *((int *) optval) ? 1 : 0);
 		break;
+	case RDMA_OPTION_ID_AFONLY:
+		if (optlen != sizeof(int)) {
+			ret = -EINVAL;
+			break;
+		}
+		ret = rdma_set_afonly(ctx->cm_id, *((int *) optval) ? 1 : 0);
+		break;
 	default:
 		ret = -ENOSYS;
 	}
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index 51988f8..ad3a314 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -357,4 +357,14 @@ void rdma_set_service_type(struct rdma_cm_id *id, int tos);
  */
 int rdma_set_reuseaddr(struct rdma_cm_id *id, int reuse);
 
+/**
+ * rdma_set_afonly - Specify that listens are restricted to the
+ *    bound address family only.
+ * @id: Communication identifer to configure.
+ * @afonly: Value indicating if listens are restricted.
+ *
+ * Must be set before identifier is in the listening state.
+ */
+int rdma_set_afonly(struct rdma_cm_id *id, int afonly);
+
 #endif /* RDMA_CM_H */
diff --git a/include/rdma/rdma_user_cm.h b/include/rdma/rdma_user_cm.h
index 5348a00..1ee9239 100644
--- a/include/rdma/rdma_user_cm.h
+++ b/include/rdma/rdma_user_cm.h
@@ -224,6 +224,7 @@ enum {
 enum {
 	RDMA_OPTION_ID_TOS	 = 0,
 	RDMA_OPTION_ID_REUSEADDR = 1,
+	RDMA_OPTION_ID_AFONLY	 = 2,
 	RDMA_OPTION_IB_PATH	 = 1
 };
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
