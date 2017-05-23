From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/2] IB/core: Introduce modify QP operation with udata
Date: Tue, 23 May 2017 11:26:08 +0300
Message-ID: <20170523082609.12603-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds new function ib_modify_qp_with_udata so that
uverbs layer can avoid handling L2 mac address at verbs layer
and depend on the core layer to resolve the mac address consistently
for all required QPs.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 32 ++++++++++++++++++++++++--------
 include/rdma/ib_verbs.h         | 16 ++++++++++++++++
 2 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 4792f5209ac2..d93ddb6da8a2 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1253,20 +1253,36 @@ int ib_resolve_eth_dmac(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_resolve_eth_dmac);
 
-int ib_modify_qp(struct ib_qp *qp,
-		 struct ib_qp_attr *qp_attr,
-		 int qp_attr_mask)
+/**
+ * ib_modify_qp_with_udata - Modifies the attributes for the specified QP.
+ * @qp: The QP to modify.
+ * @attr: On input, specifies the QP attributes to modify.  On output,
+ *   the current values of selected QP attributes are returned.
+ * @attr_mask: A bit-mask used to specify which attributes of the QP
+ *   are being modified.
+ * @udata: pointer to user's input output buffer information
+ *   are being modified.
+ * It returns 0 on success and returns appropriate error code on error.
+ */
+int ib_modify_qp_with_udata(struct ib_qp *qp, struct ib_qp_attr *attr,
+			    int attr_mask, struct ib_udata *udata)
 {
+	int ret;
 
-	if (qp_attr_mask & IB_QP_AV) {
-		int ret;
-
-		ret = ib_resolve_eth_dmac(qp->device, &qp_attr->ah_attr);
+	if (attr_mask & IB_QP_AV) {
+		ret = ib_resolve_eth_dmac(qp->device, &attr->ah_attr);
 		if (ret)
 			return ret;
 	}
+	return qp->device->modify_qp(qp->real_qp, attr, attr_mask, udata);
+}
+EXPORT_SYMBOL(ib_modify_qp_with_udata);
 
-	return qp->device->modify_qp(qp->real_qp, qp_attr, qp_attr_mask, NULL);
+int ib_modify_qp(struct ib_qp *qp,
+		 struct ib_qp_attr *qp_attr,
+		 int qp_attr_mask)
+{
+	return ib_modify_qp_with_udata(qp, qp_attr, qp_attr_mask, NULL);
 }
 EXPORT_SYMBOL(ib_modify_qp);
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index f0cb4906478a..49a8c6777991 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2898,6 +2898,22 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 			   struct ib_qp_init_attr *qp_init_attr);
 
 /**
+ * ib_modify_qp_with_udata - Modifies the attributes for the specified QP.
+ * @qp: The QP to modify.
+ * @attr: On input, specifies the QP attributes to modify.  On output,
+ *   the current values of selected QP attributes are returned.
+ * @attr_mask: A bit-mask used to specify which attributes of the QP
+ *   are being modified.
+ * @udata: pointer to user's input output buffer information
+ *   are being modified.
+ * It returns 0 on success and returns appropriate error code on error.
+ */
+int ib_modify_qp_with_udata(struct ib_qp *qp,
+			    struct ib_qp_attr *attr,
+			    int attr_mask,
+			    struct ib_udata *udata);
+
+/**
  * ib_modify_qp - Modifies the attributes for the specified QP and then
  *   transitions the QP to the given state.
  * @qp: The QP to modify.
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
