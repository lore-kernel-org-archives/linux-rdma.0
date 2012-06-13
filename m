From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] rdma/cm: Allow user to restrict listens to bound
 address family
Date: Wed, 13 Jun 2012 22:54:32 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A31536@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Provide an option for the user to specify that listens should
only accept connections where the incoming address family
matches that of the locally bound address.  This is used to
support the equivalent of IPV6_V6ONLY socket option, which
allows an app to only accept connection requests directed
to IPv6 addresses.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c  |   19 +++++++++++++++++++
 drivers/infiniband/core/ucma.c |    7 +++++++
 include/rdma/rdma_cm.h         |   10 ++++++++++
 include/rdma/rdma_user_cm.h    |    1 +
 4 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 72b0b06..461bf98 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2100,6 +2100,25 @@ int rdma_set_reuseaddr(struct rdma_cm_id *id, int reuse)
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
