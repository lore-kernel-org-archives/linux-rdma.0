From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 5/5] Add ibv_query_values_ex
Date: Tue, 27 Oct 2015 18:51:40 +0200
Message-ID: <1445964700-13235-6-git-send-email-matanb@mellanox.com>
References: <1445964700-13235-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445964700-13235-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add an extension verb to query certain values of device.
Currently, only IBV_VALUES_HW_CLOCK is supported, but this
verb could support other flags like IBV_VALUES_TEMP_SENSOR,
IBV_VALUES_CORE_FREQ, etc.
This extension verb only calls the provider.
The provider has to query this value somehow and mark the queried
values in comp_mask.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 3d66726..4829dac 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -1234,6 +1234,16 @@ struct ibv_create_cq_attr_ex {
 	uint32_t		flags;
 };
 
+enum ibv_values_mask {
+	IBV_VALUES_MASK_RAW_CLOCK	= 1 << 0,
+	IBV_VALUES_MASK_RESERVED	= 1 << 1
+};
+
+struct ibv_values_ex {
+	uint32_t	comp_mask;
+	struct timespec raw_clock;
+};
+
 enum verbs_context_mask {
 	VERBS_CONTEXT_XRCD	= 1 << 0,
 	VERBS_CONTEXT_SRQ	= 1 << 1,
@@ -1250,6 +1260,8 @@ struct ibv_poll_cq_ex_attr {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*query_values)(struct ibv_context *context,
+			    struct ibv_values_ex *values);
 	struct ibv_cq *(*create_cq_ex)(struct ibv_context *context,
 				       struct ibv_create_cq_attr_ex *);
 	void *priv;
@@ -1730,6 +1742,27 @@ ibv_create_qp_ex(struct ibv_context *context, struct ibv_qp_init_attr_ex *qp_ini
 }
 
 /**
+ * ibv_query_values_ex - Get current @q_values of device,
+ * @q_values is mask (Or's bits of enum ibv_values_mask) of the attributes
+ *	we need to query.
+ */
+static inline int
+ibv_query_values_ex(struct ibv_context *context,
+		    struct ibv_values_ex *values)
+{
+	struct verbs_context *vctx;
+
+	vctx = verbs_get_ctx_op(context, query_values);
+	if (!vctx)
+		return ENOSYS;
+
+	if (values->comp_mask & ~(IBV_VALUES_MASK_RESERVED - 1))
+		return EINVAL;
+
+	return vctx->query_values(context, values);
+}
+
+/**
  * ibv_query_device_ex - Get extended device properties
  */
 static inline int
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
