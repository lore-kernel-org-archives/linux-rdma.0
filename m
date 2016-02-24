From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 6/8] Add ibv_query_rt_values_ex
Date: Wed, 24 Feb 2016 11:42:02 +0200
Message-ID: <1456306924-31298-7-git-send-email-yishaih@mellanox.com>
References: <1456306924-31298-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456306924-31298-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add an extension verb to query certain real time values of a device.
Currently, only IBV_VALUES_MASK_RAW_CLOCK is supported, but this
verb could support other flags like IBV_VALUES_MASK_TEMP_SENSOR,
IBV_VALUES_MASK_CORE_FREQ, etc.
This extension verb only calls the provider.
The provider has to query this value somehow and mark the queried
values in comp_mask.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 67a2cb1..49de86c 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -1267,6 +1267,16 @@ struct ibv_cq_init_attr_ex {
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
@@ -1283,6 +1293,8 @@ struct ibv_poll_cq_ex_attr {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*query_rt_values)(struct ibv_context *context,
+			       struct ibv_values_ex *values);
 	struct ibv_cq *(*create_cq_ex)(struct ibv_context *context,
 				       struct ibv_cq_init_attr_ex *);
 	struct verbs_ex_private *priv;
@@ -1817,6 +1829,27 @@ ibv_create_qp_ex(struct ibv_context *context, struct ibv_qp_init_attr_ex *qp_ini
 }
 
 /**
+ * ibv_query_rt_values_ex - Get current real time @values of a device.
+ * @values - in/out - defines the attributes we need to query/queried.
+ * (Or's bits of enum ibv_values_mask on values->comp_mask field)
+ */
+static inline int
+ibv_query_rt_values_ex(struct ibv_context *context,
+		       struct ibv_values_ex *values)
+{
+	struct verbs_context *vctx;
+
+	vctx = verbs_get_ctx_op(context, query_rt_values);
+	if (!vctx)
+		return ENOSYS;
+
+	if (values->comp_mask & ~(IBV_VALUES_MASK_RESERVED - 1))
+		return EINVAL;
+
+	return vctx->query_rt_values(context, values);
+}
+
+/**
  * ibv_query_device_ex - Get extended device properties
  */
 static inline int
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
