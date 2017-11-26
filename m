From: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC rdma-next 2/2] IB/mlx5: Example use of vendor QP
Date: Sun, 26 Nov 2017 19:45:13 +0200
Message-ID: <1511718317-3381-3-git-send-email-alexma@mellanox.com>
References: <1511718317-3381-1-git-send-email-alexma@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511718317-3381-1-git-send-email-alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

An example that shows how to use the IB_QPT_VENDOR QP type
to create a DCI QP - specific only to mlx5 driver.
More specifically, validating state transition cannot be with
ib_modify_qp_is_ok() which knows only what are the  state
transition rules for InfiniBand spec QPs.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  6 ++++++
 drivers/infiniband/hw/mlx5/qp.c      | 24 +++++++++++++++++++++++-
 include/uapi/rdma/mlx5-abi.h         |  2 ++
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 189e80c..b8a3a63 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -209,6 +209,11 @@ struct mlx5_ib_flow_db {
 #define MLX5_IB_UPD_XLT_ACCESS	      BIT(5)
 #define MLX5_IB_UPD_XLT_INDIRECT      BIT(6)
 
+enum {
+	MLX5_VENDOR_QPT_DCT	= 1,
+	MLX5_VENDOR_QPT_DCI,
+};
+
 /* Private QP creation flags to be passed in ib_qp_init_attr.create_flags.
  *
  * These flags are intended for internal use by the mlx5_ib driver, and they
@@ -389,6 +394,7 @@ struct mlx5_ib_qp {
 	struct list_head	cq_send_list;
 	u32			rate_limit;
 	u32                     underlay_qpn;
+	u32			vendor_qp_type;
 };
 
 struct mlx5_ib_cq_buf {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index acb79d3..5c2bd14 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1527,6 +1527,11 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	spin_lock_init(&qp->sq.lock);
 	spin_lock_init(&qp->rq.lock);
 
+	if (init_attr->qp_type == IB_QPT_VENDOR) {
+		if (!udata)
+			return -ENOSYS;
+	}
+
 	if (init_attr->rwq_ind_tbl) {
 		if (!udata)
 			return -ENOSYS;
@@ -1596,6 +1601,7 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 			mlx5_ib_dbg(dev, "copy failed\n");
 			return -EFAULT;
 		}
+		qp->vendor_qp_type = ucmd.vendor_qp_type;
 
 		err = get_qp_user_index(to_mucontext(pd->uobject->context),
 					&ucmd, udata->inlen, &uidx);
@@ -2086,6 +2092,7 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
 	case IB_QPT_RC:
 	case IB_QPT_UC:
 	case IB_QPT_UD:
+	case IB_QPT_VENDOR:
 	case IB_QPT_SMI:
 	case MLX5_IB_QPT_HW_GSI:
 	case MLX5_IB_QPT_REG_UMR:
@@ -2934,6 +2941,15 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	return err;
 }
 
+int mlx5_ib_modify_qp_is_ok(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+			    int attr_mask, struct ib_udata *udata)
+{
+	struct mlx5_ib_qp *qp = to_mqp(ibqp);
+
+	/* put some real logic here based on value of qp->vendor_qp_type */
+	return 1;
+}
+
 int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		      int attr_mask, struct ib_udata *udata)
 {
@@ -2971,10 +2987,16 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			goto out;
 		}
 	} else if (qp_type != MLX5_IB_QPT_REG_UMR &&
-	    !ib_modify_qp_is_ok(cur_state, new_state, qp_type, attr_mask, ll)) {
+		   qp_type != IB_QPT_VENDOR &&
+		   !ib_modify_qp_is_ok(cur_state, new_state, qp_type, attr_mask, ll)) {
 		mlx5_ib_dbg(dev, "invalid QP state transition from %d to %d, qp_type %d, attr_mask 0x%x\n",
 			    cur_state, new_state, ibqp->qp_type, attr_mask);
 		goto out;
+	} else if ((qp_type == IB_QPT_VENDOR) &&
+		    !mlx5_ib_modify_qp_is_ok(ibqp, attr, attr_mask, udata)) {
+			mlx5_ib_dbg(dev, "invalid QP state transition from %d to %d, qp_type %d, attr_mask 0x%x\n",
+			    cur_state, new_state, ibqp->qp_type, attr_mask);
+			goto out;
 	}
 
 	if ((attr_mask & IB_QP_PORT) &&
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 23dba2d..6701102 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -248,6 +248,8 @@ struct mlx5_ib_create_qp {
 	__u32	uidx;
 	__u32	reserved0;
 	__u64	sq_buf_addr;
+	__u32	vendor_qp_type;
+	__u32	reserved1;
 };
 
 /* RX Hash function flags */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
