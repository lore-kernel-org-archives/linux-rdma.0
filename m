From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/4] IB/core: Limit DMAC resolution to userspace QPs
Date: Tue,  9 Jan 2018 15:24:51 +0200
Message-ID: <20180109132453.29038-3-leon@kernel.org>
References: <20180109132453.29038-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180109132453.29038-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently ah_attr is initialized by the ib_cm layer for rdma_cm
based applications. For RoCE transport ah_attr.roce.dmac is already
initialized by ib_cm, rdma_cm either from wc, path record, route
resolve, explicit path record setting depending on active or passive
side QP. Therefore avoid resolving DMAC for QP of kernel consumers.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 48 +++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 1436f8c7906a..d8f4f1b56f94 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1324,29 +1324,14 @@ static int ib_resolve_eth_dmac(struct ib_device *device,
 }
 
 /**
- * ib_modify_qp_with_udata - Modifies the attributes for the specified QP.
- * @ib_qp: The QP to modify.
- * @attr: On input, specifies the QP attributes to modify.  On output,
- *   the current values of selected QP attributes are returned.
- * @attr_mask: A bit-mask used to specify which attributes of the QP
- *   are being modified.
- * @udata: pointer to user's input output buffer information
- *   are being modified.
- * It returns 0 on success and returns appropriate error code on error.
+ * IB core internal function to perform QP attributes modification.
  */
-int ib_modify_qp_with_udata(struct ib_qp *ib_qp, struct ib_qp_attr *attr,
-			    int attr_mask, struct ib_udata *udata)
+static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
+			 int attr_mask, struct ib_udata *udata)
 {
-	struct ib_qp *qp = ib_qp->real_qp;
 	u8 port = attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
 	int ret;
 
-	if (attr_mask & IB_QP_AV) {
-		ret = ib_resolve_eth_dmac(qp->device, &attr->ah_attr);
-		if (ret)
-			return ret;
-	}
-
 	if (rdma_ib_or_roce(qp->device, port)) {
 		if (attr_mask & IB_QP_RQ_PSN && attr->rq_psn & ~0xffffff) {
 			pr_warn("%s: %s rq_psn overflow, masking to 24 bits\n",
@@ -1367,6 +1352,31 @@ int ib_modify_qp_with_udata(struct ib_qp *ib_qp, struct ib_qp_attr *attr,
 
 	return ret;
 }
+
+/**
+ * ib_modify_qp_with_udata - Modifies the attributes for the specified QP.
+ * @ib_qp: The QP to modify.
+ * @attr: On input, specifies the QP attributes to modify.  On output,
+ *   the current values of selected QP attributes are returned.
+ * @attr_mask: A bit-mask used to specify which attributes of the QP
+ *   are being modified.
+ * @udata: pointer to user's input output buffer information
+ *   are being modified.
+ * It returns 0 on success and returns appropriate error code on error.
+ */
+int ib_modify_qp_with_udata(struct ib_qp *ib_qp, struct ib_qp_attr *attr,
+			    int attr_mask, struct ib_udata *udata)
+{
+	struct ib_qp *qp = ib_qp->real_qp;
+	int ret;
+
+	if (attr_mask & IB_QP_AV) {
+		ret = ib_resolve_eth_dmac(qp->device, &attr->ah_attr);
+		if (ret)
+			return ret;
+	}
+	return _ib_modify_qp(qp, attr, attr_mask, udata);
+}
 EXPORT_SYMBOL(ib_modify_qp_with_udata);
 
 int ib_get_eth_speed(struct ib_device *dev, u8 port_num, u8 *speed, u8 *width)
@@ -1428,7 +1438,7 @@ int ib_modify_qp(struct ib_qp *qp,
 		 struct ib_qp_attr *qp_attr,
 		 int qp_attr_mask)
 {
-	return ib_modify_qp_with_udata(qp, qp_attr, qp_attr_mask, NULL);
+	return _ib_modify_qp(qp->real_qp, qp_attr, qp_attr_mask, NULL);
 }
 EXPORT_SYMBOL(ib_modify_qp);
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
