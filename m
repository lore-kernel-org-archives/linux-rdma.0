From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 6/8] ib_uverbs: Avoid vendor specific masking of attributes in query_qp
Date: Fri, 16 Sep 2016 20:31:17 +0200
Message-ID: <d4523e413ed864bbd0a4e52d09d5814722b6a9dd.1474049924.git-series.knut.omang@oracle.com>
References: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
References: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This commit removes the implementation and use of the modify_qp_mask
helper function from the generic OFED implementation and into individual
device drivers.

Like with use of the ib_modify_qp_is_ok function it should be up to
each device driver how to handle bits set in the attribute masks.

With the modify_qp_mask function applied in the generic code,
drivers would not see the bits that the user process actually sets.

The restrictions imposed by the filter are also beyond what
is imposed by the Infiniband standard, and would also limit
future drivers or hardware from checking for unsupported or
invalid settings.
---
 drivers/infiniband/core/uverbs_cmd.c | 19 ++-----------------
 drivers/infiniband/hw/mlx4/qp.c      | 19 ++++++++++++++++++-
 drivers/infiniband/hw/mlx5/qp.c      | 17 +++++++++++++++++
 3 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index fa8a717..7033d10 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2316,20 +2316,6 @@ out:
 	return ret ? ret : in_len;
 }
 
-/* Remove ignored fields set in the attribute mask */
-static int modify_qp_mask(enum ib_qp_type qp_type, int mask)
-{
-	switch (qp_type) {
-	case IB_QPT_XRC_INI:
-		return mask & ~(IB_QP_MAX_DEST_RD_ATOMIC | IB_QP_MIN_RNR_TIMER);
-	case IB_QPT_XRC_TGT:
-		return mask & ~(IB_QP_MAX_QP_RD_ATOMIC | IB_QP_RETRY_CNT |
-				IB_QP_RNR_RETRY);
-	default:
-		return mask;
-	}
-}
-
 ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 			    struct ib_device *ib_dev,
 			    const char __user *buf, int in_len,
@@ -2407,10 +2393,9 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 		ret = ib_resolve_eth_dmac(qp, attr, &cmd.attr_mask);
 		if (ret)
 			goto release_qp;
-		ret = qp->device->modify_qp(qp, attr,
-			modify_qp_mask(qp->qp_type, cmd.attr_mask), &udata);
+		ret = qp->device->modify_qp(qp, attr, cmd.attr_mask, &udata);
 	} else {
-		ret = ib_modify_qp(qp, attr, modify_qp_mask(qp->qp_type, cmd.attr_mask));
+		ret = ib_modify_qp(qp, attr, cmd.attr_mask);
 	}
 
 	if (ret)
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 363b1cb..3a5061f 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2154,6 +2154,20 @@ out:
 	return err;
 }
 
+/* filter out ignored fields set in the attribute mask */
+static int modify_qp_mask(enum ib_qp_type qp_type, int mask)
+{
+	switch (qp_type) {
+	case IB_QPT_XRC_INI:
+		return mask & ~(IB_QP_MAX_DEST_RD_ATOMIC | IB_QP_MIN_RNR_TIMER);
+	case IB_QPT_XRC_TGT:
+		return mask & ~(IB_QP_MAX_QP_RD_ATOMIC | IB_QP_RETRY_CNT |
+				IB_QP_RNR_RETRY);
+	default:
+		return mask;
+	}
+}
+
 static int _mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			      int attr_mask, struct ib_udata *udata)
 {
@@ -2162,6 +2176,10 @@ static int _mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	enum ib_qp_state cur_state, new_state;
 	int err = -EINVAL;
 	int ll;
+
+	if (udata)
+		attr_mask = modify_qp_mask(ibqp->qp_type, attr_mask);
+
 	mutex_lock(&qp->mutex);
 
 	cur_state = attr_mask & IB_QP_CUR_STATE ? attr->cur_qp_state : qp->state;
@@ -3501,4 +3519,3 @@ out:
 	mutex_unlock(&qp->mutex);
 	return err;
 }
-
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 3a48d9d..5006ab0 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2737,6 +2737,20 @@ out:
 	return err;
 }
 
+/* filter out ignored fields set in the attribute mask */
+static int modify_qp_mask(enum ib_qp_type qp_type, int mask)
+{
+	switch (qp_type) {
+	case IB_QPT_XRC_INI:
+		return mask & ~(IB_QP_MAX_DEST_RD_ATOMIC | IB_QP_MIN_RNR_TIMER);
+	case IB_QPT_XRC_TGT:
+		return mask & ~(IB_QP_MAX_QP_RD_ATOMIC | IB_QP_RETRY_CNT |
+				IB_QP_RNR_RETRY);
+	default:
+		return mask;
+	}
+}
+
 int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		      int attr_mask, struct ib_udata *udata)
 {
@@ -2751,6 +2765,9 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	if (ibqp->rwq_ind_tbl)
 		return -ENOSYS;
 
+	if (udata)
+		attr_mask = modify_qp_mask(ibqp->qp_type, attr_mask);
+
 	if (unlikely(ibqp->qp_type == IB_QPT_GSI))
 		return mlx5_ib_gsi_modify_qp(ibqp, attr, attr_mask);
 
-- 
git-series 0.8.10
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
