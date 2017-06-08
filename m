From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next v3 1/7] IB/core: Convert ah_attr from OPA to IB when copying to user
Date: Thu,  8 Jun 2017 13:37:43 -0400
Message-ID: <1496943469-44017-2-git-send-email-don.hiatt@intel.com>
References: <1496943469-44017-1-git-send-email-don.hiatt@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496943469-44017-1-git-send-email-don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

OPA address handle atttibutes that have 32 bit LIDs would have to
be converted to IB address handle attribute with the LID field
programmed in the GID before copying to user space.

Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/ucm.c             |  2 +-
 drivers/infiniband/core/ucma.c            | 10 ++++---
 drivers/infiniband/core/uverbs_marshall.c | 48 +++++++++++++++++++++++++++----
 include/rdma/ib_marshall.h                |  6 ++--
 4 files changed, 54 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 80d0fca..f9e8958 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -618,7 +618,7 @@ static ssize_t ib_ucm_init_qp_attr(struct ib_ucm_file *file,
 	if (result)
 		goto out;
 
-	ib_copy_qp_attr_to_user(&resp, &qp_attr);
+	ib_copy_qp_attr_to_user(ctx->cm_id->device, &resp, &qp_attr);
 
 	if (copy_to_user((void __user *)(unsigned long)cmd.response,
 			 &resp, sizeof(resp)))
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 276f0ef..eb85b54 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -248,14 +248,15 @@ static void ucma_copy_conn_event(struct rdma_ucm_conn_param *dst,
 	dst->qp_num = src->qp_num;
 }
 
-static void ucma_copy_ud_event(struct rdma_ucm_ud_param *dst,
+static void ucma_copy_ud_event(struct ib_device *device,
+			       struct rdma_ucm_ud_param *dst,
 			       struct rdma_ud_param *src)
 {
 	if (src->private_data_len)
 		memcpy(dst->private_data, src->private_data,
 		       src->private_data_len);
 	dst->private_data_len = src->private_data_len;
-	ib_copy_ah_attr_to_user(&dst->ah_attr, &src->ah_attr);
+	ib_copy_ah_attr_to_user(device, &dst->ah_attr, &src->ah_attr);
 	dst->qp_num = src->qp_num;
 	dst->qkey = src->qkey;
 }
@@ -335,7 +336,8 @@ static int ucma_event_handler(struct rdma_cm_id *cm_id,
 	uevent->resp.event = event->event;
 	uevent->resp.status = event->status;
 	if (cm_id->qp_type == IB_QPT_UD)
-		ucma_copy_ud_event(&uevent->resp.param.ud, &event->param.ud);
+		ucma_copy_ud_event(cm_id->device, &uevent->resp.param.ud,
+				   &event->param.ud);
 	else
 		ucma_copy_conn_event(&uevent->resp.param.conn,
 				     &event->param.conn);
@@ -1157,7 +1159,7 @@ static ssize_t ucma_init_qp_attr(struct ucma_file *file,
 	if (ret)
 		goto out;
 
-	ib_copy_qp_attr_to_user(&resp, &qp_attr);
+	ib_copy_qp_attr_to_user(ctx->cm_id->device, &resp, &qp_attr);
 	if (copy_to_user((void __user *)(unsigned long)cmd.response,
 			 &resp, sizeof(resp)))
 		ret = -EFAULT;
diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index 8b9587f..92a6475 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -33,10 +33,47 @@
 #include <linux/export.h>
 #include <rdma/ib_marshall.h>
 
-void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
-			     struct rdma_ah_attr *src)
+#define OPA_DEFAULT_GID_PREFIX cpu_to_be64(0xfe80000000000000ULL)
+static int rdma_ah_conv_opa_to_ib(struct ib_device *dev,
+				  struct rdma_ah_attr *ib,
+				  struct rdma_ah_attr *opa)
 {
+	struct ib_port_attr port_attr;
+	int ret = 0;
+
+	/* Do structure copy and the over-write fields */
+	*ib = *opa;
+
+	ib->type = RDMA_AH_ATTR_TYPE_IB;
+	rdma_ah_set_grh(ib, NULL, 0, 0, 1, 0);
+
+	if (ib_query_port(dev, opa->port_num, &port_attr)) {
+		/* Set to default subnet to indicate error */
+		rdma_ah_set_subnet_prefix(ib, OPA_DEFAULT_GID_PREFIX);
+		ret = -EINVAL;
+	} else {
+		rdma_ah_set_subnet_prefix(ib,
+					  cpu_to_be64(port_attr.subnet_prefix));
+	}
+	rdma_ah_set_interface_id(ib, OPA_MAKE_ID(rdma_ah_get_dlid(opa)));
+	return ret;
+}
+
+void ib_copy_ah_attr_to_user(struct ib_device *device,
+			     struct ib_uverbs_ah_attr *dst,
+			     struct rdma_ah_attr *ah_attr)
+{
+	struct rdma_ah_attr *src = ah_attr;
+	struct rdma_ah_attr conv_ah;
+
 	memset(&dst->grh.reserved, 0, sizeof(dst->grh.reserved));
+
+	if ((ah_attr->type == RDMA_AH_ATTR_TYPE_OPA) &&
+	    (rdma_ah_get_dlid(ah_attr) >=
+	     be16_to_cpu(IB_MULTICAST_LID_BASE)) &&
+	    (!rdma_ah_conv_opa_to_ib(device, &conv_ah, ah_attr)))
+		src = &conv_ah;
+
 	dst->dlid		   = rdma_ah_get_dlid(src);
 	dst->sl			   = rdma_ah_get_sl(src);
 	dst->src_path_bits	   = rdma_ah_get_path_bits(src);
@@ -57,7 +94,8 @@ void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
 }
 EXPORT_SYMBOL(ib_copy_ah_attr_to_user);
 
-void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
+void ib_copy_qp_attr_to_user(struct ib_device *device,
+			     struct ib_uverbs_qp_attr *dst,
 			     struct ib_qp_attr *src)
 {
 	dst->qp_state	        = src->qp_state;
@@ -76,8 +114,8 @@ void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
 	dst->max_recv_sge	= src->cap.max_recv_sge;
 	dst->max_inline_data	= src->cap.max_inline_data;
 
-	ib_copy_ah_attr_to_user(&dst->ah_attr, &src->ah_attr);
-	ib_copy_ah_attr_to_user(&dst->alt_ah_attr, &src->alt_ah_attr);
+	ib_copy_ah_attr_to_user(device, &dst->ah_attr, &src->ah_attr);
+	ib_copy_ah_attr_to_user(device, &dst->alt_ah_attr, &src->alt_ah_attr);
 
 	dst->pkey_index		= src->pkey_index;
 	dst->alt_pkey_index	= src->alt_pkey_index;
diff --git a/include/rdma/ib_marshall.h b/include/rdma/ib_marshall.h
index 68cef3b..8ebf84a 100644
--- a/include/rdma/ib_marshall.h
+++ b/include/rdma/ib_marshall.h
@@ -38,10 +38,12 @@
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_user_sa.h>
 
-void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
+void ib_copy_qp_attr_to_user(struct ib_device *device,
+			     struct ib_uverbs_qp_attr *dst,
 			     struct ib_qp_attr *src);
 
-void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
+void ib_copy_ah_attr_to_user(struct ib_device *device,
+			     struct ib_uverbs_ah_attr *dst,
 			     struct rdma_ah_attr *src);
 
 void ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
