From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 5/9] IB/hns: Add phy_port for computing GSI/QPN
Date: Tue, 13 Sep 2016 20:49:26 +0100
Message-ID: <20160913194930.273964-6-salil.mehta@huawei.com>
References: <20160913194930.273964-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160913194930.273964-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

This patch mainly adds phy_port to HNS RoCE QP. This shall be
used in calculating the GSI QPN for the port.
Initally when RDMA is being established, all IB ports share a
QPN which later needs to be re-assigned to a particular GSI/QPN
and which is per-port.
This also fixes a bug in base driver where iboe port was being
used instead of phy_port at some places. This values might not
be same always.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Reviewed-by: Wei Hu <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  | 30 +++++++++++++++--------------
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 13 ++++++-------
 3 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index e943b98..833742b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -409,6 +409,7 @@ struct hns_roce_qp {
 	u32			buff_size;
 	struct mutex		mutex;
 	u8			port;
+	u8			phy_port;
 	u8			sl;
 	u8			resp_depth;
 	u8			state;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index aaea95c..581e542 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -162,7 +162,7 @@ int hns_roce_v1_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			roce_set_field(ud_sq_wqe->u32_36,
 				       UD_SEND_WQE_U32_36_SGID_INDEX_M,
 				       UD_SEND_WQE_U32_36_SGID_INDEX_S,
-				       hns_get_gid_index(hr_dev, qp->port,
+				       hns_get_gid_index(hr_dev, qp->phy_port,
 							 ah->av.gid_index));
 
 			roce_set_field(ud_sq_wqe->u32_40,
@@ -282,7 +282,7 @@ out:
 			       SQ_DOORBELL_U32_4_SQ_HEAD_S,
 			      (qp->sq.head & ((qp->sq.wqe_cnt << 1) - 1)));
 		roce_set_field(sq_db.u32_4, SQ_DOORBELL_U32_4_PORT_M,
-			       SQ_DOORBELL_U32_4_PORT_S, qp->port);
+			       SQ_DOORBELL_U32_4_PORT_S, qp->phy_port);
 		roce_set_field(sq_db.u32_8, SQ_DOORBELL_U32_8_QPN_M,
 			       SQ_DOORBELL_U32_8_QPN_S, qp->doorbell_qpn);
 		roce_set_bit(sq_db.u32_8, SQ_DOORBELL_HW_SYNC_S, 1);
@@ -362,14 +362,14 @@ out:
 			/* SW update GSI rq header */
 			reg_val = roce_read(to_hr_dev(ibqp->device),
 					    ROCEE_QP1C_CFG3_0_REG +
-					    QP1C_CFGN_OFFSET * hr_qp->port);
+					    QP1C_CFGN_OFFSET * hr_qp->phy_port);
 			roce_set_field(reg_val,
 				       ROCEE_QP1C_CFG3_0_ROCEE_QP1C_RQ_HEAD_M,
 				       ROCEE_QP1C_CFG3_0_ROCEE_QP1C_RQ_HEAD_S,
 				       hr_qp->rq.head);
 			roce_write(to_hr_dev(ibqp->device),
 				   ROCEE_QP1C_CFG3_0_REG +
-				   QP1C_CFGN_OFFSET * hr_qp->port, reg_val);
+				   QP1C_CFGN_OFFSET * hr_qp->phy_port, reg_val);
 		} else {
 			rq_db.u32_4 = 0;
 			rq_db.u32_8 = 0;
@@ -1730,7 +1730,7 @@ static int hns_roce_v1_m_sqp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 		roce_set_field(context->qp1c_bytes_16, QP1C_BYTES_16_RQ_HEAD_M,
 			       QP1C_BYTES_16_RQ_HEAD_S, hr_qp->rq.head);
 		roce_set_field(context->qp1c_bytes_16, QP1C_BYTES_16_PORT_NUM_M,
-			       QP1C_BYTES_16_PORT_NUM_S, hr_qp->port);
+			       QP1C_BYTES_16_PORT_NUM_S, hr_qp->phy_port);
 		roce_set_bit(context->qp1c_bytes_16,
 			     QP1C_BYTES_16_SIGNALING_TYPE_S,
 			     hr_qp->sq_signal_bits);
@@ -1781,7 +1781,7 @@ static int hns_roce_v1_m_sqp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 
 		/* Copy context to QP1C register */
 		addr = (u32 *)(hr_dev->reg_base + ROCEE_QP1C_CFG0_0_REG +
-			hr_qp->port * sizeof(*context));
+			hr_qp->phy_port * sizeof(*context));
 
 		writel(context->qp1c_bytes_4, addr);
 		writel(context->sq_rq_bt_l, addr + 1);
@@ -1797,11 +1797,11 @@ static int hns_roce_v1_m_sqp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 
 	/* Modify QP1C status */
 	reg_val = roce_read(hr_dev, ROCEE_QP1C_CFG0_0_REG +
-			    hr_qp->port * sizeof(*context));
+			    hr_qp->phy_port * sizeof(*context));
 	roce_set_field(reg_val, ROCEE_QP1C_CFG0_0_ROCEE_QP1C_QP_ST_M,
 		       ROCEE_QP1C_CFG0_0_ROCEE_QP1C_QP_ST_S, new_state);
 	roce_write(hr_dev, ROCEE_QP1C_CFG0_0_REG +
-		    hr_qp->port * sizeof(*context), reg_val);
+		    hr_qp->phy_port * sizeof(*context), reg_val);
 
 	hr_qp->state = new_state;
 	if (new_state == IB_QPS_RESET) {
@@ -2184,7 +2184,7 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 		roce_set_field(context->qpc_bytes_156,
 			       QP_CONTEXT_QPC_BYTES_156_PORT_NUM_M,
 			       QP_CONTEXT_QPC_BYTES_156_PORT_NUM_S,
-			       hr_qp->port);
+			       hr_qp->phy_port);
 		roce_set_field(context->qpc_bytes_156,
 			       QP_CONTEXT_QPC_BYTES_156_SL_M,
 			       QP_CONTEXT_QPC_BYTES_156_SL_S, attr->ah_attr.sl);
@@ -2290,7 +2290,7 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 		roce_set_field(context->qpc_bytes_156,
 			       QP_CONTEXT_QPC_BYTES_156_PORT_NUM_M,
 			       QP_CONTEXT_QPC_BYTES_156_PORT_NUM_S,
-			       hr_qp->port);
+			       hr_qp->phy_port);
 		roce_set_field(context->qpc_bytes_156,
 			       QP_CONTEXT_QPC_BYTES_156_SL_M,
 			       QP_CONTEXT_QPC_BYTES_156_SL_S, attr->ah_attr.sl);
@@ -2398,13 +2398,13 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 		if (hr_qp->ibqp.qp_type == IB_QPT_GSI) {
 			/* SW update GSI rq header */
 			reg_val = roce_read(hr_dev, ROCEE_QP1C_CFG3_0_REG +
-					    QP1C_CFGN_OFFSET * hr_qp->port);
+					    QP1C_CFGN_OFFSET * hr_qp->phy_port);
 			roce_set_field(reg_val,
 				       ROCEE_QP1C_CFG3_0_ROCEE_QP1C_RQ_HEAD_M,
 				       ROCEE_QP1C_CFG3_0_ROCEE_QP1C_RQ_HEAD_S,
 				       hr_qp->rq.head);
 			roce_write(hr_dev, ROCEE_QP1C_CFG3_0_REG +
-				    QP1C_CFGN_OFFSET * hr_qp->port, reg_val);
+				   QP1C_CFGN_OFFSET * hr_qp->phy_port, reg_val);
 		} else {
 			rq_db.u32_4 = 0;
 			rq_db.u32_8 = 0;
@@ -2430,8 +2430,10 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 
 	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC)
 		hr_qp->resp_depth = attr->max_dest_rd_atomic;
-	if (attr_mask & IB_QP_PORT)
-		hr_qp->port = (attr->port_num - 1);
+	if (attr_mask & IB_QP_PORT) {
+		hr_qp->port = attr->port_num - 1;
+		hr_qp->phy_port = hr_dev->iboe.phy_port[hr_qp->port];
+	}
 
 	if (new_state == IB_QPS_RESET && !ibqp->uobject) {
 		hns_roce_v1_cq_clean(to_hr_cq(ibqp->recv_cq), hr_qp->qpn,
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 645c18d..089da7f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -617,21 +617,20 @@ struct ib_qp *hns_roce_create_qp(struct ib_pd *pd,
 			return ERR_PTR(-ENOMEM);
 
 		hr_qp = &hr_sqp->hr_qp;
+		hr_qp->port = init_attr->port_num - 1;
+		hr_qp->phy_port = hr_dev->iboe.phy_port[hr_qp->port];
+		hr_qp->ibqp.qp_num = hr_dev->caps.sqp_start +
+				     HNS_ROCE_MAX_PORTS +
+				     hr_dev->iboe.phy_port[hr_qp->port];
 
 		ret = hns_roce_create_qp_common(hr_dev, pd, init_attr, udata,
-						hr_dev->caps.sqp_start +
-						hr_dev->caps.num_ports +
-						init_attr->port_num - 1, hr_qp);
+						hr_qp->ibqp.qp_num, hr_qp);
 		if (ret) {
 			dev_err(dev, "Create GSI QP failed!\n");
 			kfree(hr_sqp);
 			return ERR_PTR(ret);
 		}
 
-		hr_qp->port = (init_attr->port_num - 1);
-		hr_qp->ibqp.qp_num = hr_dev->caps.sqp_start +
-				     hr_dev->caps.num_ports +
-				     init_attr->port_num - 1;
 		break;
 	}
 	default:{
-- 
1.9.1
