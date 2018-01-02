From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V4 for-next 3/6] RDMA/hns: Set access flags of hip08 RoCE
Date: Tue, 2 Jan 2018 20:49:28 +0800
Message-ID: <1514897371-52553-4-git-send-email-oulijun@huawei.com>
References: <1514897371-52553-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514897371-52553-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch refactors the code of setting access flags
for RDMA operation as well as adds the scene when
attr->max_dest_rd_atomic is zero.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 48 +++++++++++++++++++++--------
 2 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 8d123d3..4afa070 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -483,6 +483,7 @@ struct hns_roce_qp {
 	u8			resp_depth;
 	u8			state;
 	u32			access_flags;
+	u32                     atomic_rd_en;
 	u32			pkey_index;
 	void			(*event)(struct hns_roce_qp *,
 					 enum hns_roce_event);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 3ade767..9758bdb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1931,6 +1931,36 @@ static int hns_roce_v2_qp_modify(struct hns_roce_dev *hr_dev,
 	return ret;
 }
 
+static void set_access_flags(struct hns_roce_qp *hr_qp,
+			     struct hns_roce_v2_qp_context *context,
+			     struct hns_roce_v2_qp_context *qpc_mask,
+			     const struct ib_qp_attr *attr, int attr_mask)
+{
+	u8 dest_rd_atomic;
+	u32 access_flags;
+
+	dest_rd_atomic = !!(attr_mask & IB_QP_MAX_DEST_RD_ATOMIC) ?
+			 attr->max_dest_rd_atomic : hr_qp->resp_depth;
+
+	access_flags = !!(attr_mask & IB_QP_ACCESS_FLAGS) ?
+		       attr->qp_access_flags : hr_qp->atomic_rd_en;
+
+	if (!dest_rd_atomic)
+		access_flags &= IB_ACCESS_REMOTE_WRITE;
+
+	roce_set_bit(context->byte_76_srqn_op_en, V2_QPC_BYTE_76_RRE_S,
+		     !!(access_flags & IB_ACCESS_REMOTE_READ));
+	roce_set_bit(qpc_mask->byte_76_srqn_op_en, V2_QPC_BYTE_76_RRE_S, 0);
+
+	roce_set_bit(context->byte_76_srqn_op_en, V2_QPC_BYTE_76_RWE_S,
+		     !!(access_flags & IB_ACCESS_REMOTE_WRITE));
+	roce_set_bit(qpc_mask->byte_76_srqn_op_en, V2_QPC_BYTE_76_RWE_S, 0);
+
+	roce_set_bit(context->byte_76_srqn_op_en, V2_QPC_BYTE_76_ATE_S,
+		     !!(access_flags & IB_ACCESS_REMOTE_ATOMIC));
+	roce_set_bit(qpc_mask->byte_76_srqn_op_en, V2_QPC_BYTE_76_ATE_S, 0);
+}
+
 static void modify_qp_reset_to_init(struct ib_qp *ibqp,
 				    const struct ib_qp_attr *attr,
 				    struct hns_roce_v2_qp_context *context,
@@ -2016,18 +2046,6 @@ static void modify_qp_reset_to_init(struct ib_qp *ibqp,
 	roce_set_bit(qpc_mask->byte_28_at_fl, V2_QPC_BYTE_28_CNP_TX_FLAG_S, 0);
 	roce_set_bit(qpc_mask->byte_28_at_fl, V2_QPC_BYTE_28_CE_FLAG_S, 0);
 
-	roce_set_bit(context->byte_76_srqn_op_en, V2_QPC_BYTE_76_RRE_S,
-		     !!(attr->qp_access_flags & IB_ACCESS_REMOTE_READ));
-	roce_set_bit(qpc_mask->byte_76_srqn_op_en, V2_QPC_BYTE_76_RRE_S, 0);
-
-	roce_set_bit(context->byte_76_srqn_op_en, V2_QPC_BYTE_76_RWE_S,
-		     !!(attr->qp_access_flags & IB_ACCESS_REMOTE_WRITE));
-	roce_set_bit(qpc_mask->byte_76_srqn_op_en, V2_QPC_BYTE_76_RWE_S, 0);
-
-	roce_set_bit(context->byte_76_srqn_op_en, V2_QPC_BYTE_76_ATE_S,
-		     !!(attr->qp_access_flags & IB_ACCESS_REMOTE_ATOMIC));
-	roce_set_bit(qpc_mask->byte_76_srqn_op_en, V2_QPC_BYTE_76_ATE_S, 0);
-
 	roce_set_bit(context->byte_76_srqn_op_en, V2_QPC_BYTE_76_RQIE_S, 1);
 	roce_set_bit(qpc_mask->byte_76_srqn_op_en, V2_QPC_BYTE_76_RQIE_S, 0);
 
@@ -2907,6 +2925,9 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 		goto out;
 	}
 
+	if (attr_mask & (IB_QP_ACCESS_FLAGS | IB_QP_MAX_DEST_RD_ATOMIC))
+		set_access_flags(hr_qp, context, qpc_mask, attr, attr_mask);
+
 	/* Every status migrate must change state */
 	roce_set_field(context->byte_60_qpst_mapid, V2_QPC_BYTE_60_QP_ST_M,
 		       V2_QPC_BYTE_60_QP_ST_S, new_state);
@@ -2923,6 +2944,9 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 
 	hr_qp->state = new_state;
 
+	if (attr_mask & IB_QP_ACCESS_FLAGS)
+		hr_qp->atomic_rd_en = attr->qp_access_flags;
+
 	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC)
 		hr_qp->resp_depth = attr->max_dest_rd_atomic;
 	if (attr_mask & IB_QP_PORT) {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
