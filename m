From: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 4/8] RDMA/qedr: Add iWARP support in existing verbs
Date: Wed, 26 Jul 2017 14:41:53 +0300
Message-ID: <1501069317-16601-5-git-send-email-Michal.Kalderon@cavium.com>
References: <1501069317-16601-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501069317-16601-1-git-send-email-Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: michal.kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: yuval.mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make slight modifications to common RoCE/iWARP code.
Add additional doorbell for iWARP post_send.
iWARP QP pbl is allocated in qed and not in qedr.

Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/qedr.h  |   3 +
 drivers/infiniband/hw/qedr/verbs.c | 171 +++++++++++++++++++++++++++++--------
 2 files changed, 139 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 349e6ae..0ddac91 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -320,6 +320,9 @@ struct qedr_qp_hwq_info {
 	/* DB */
 	void __iomem *db;
 	union db_prod32 db_data;
+
+	void __iomem *iwarp_db2;
+	union db_prod32 iwarp_db2_data;
 };
 
 #define QEDR_INC_SW_IDX(p_info, index)					\
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index b9245fc..b40c815 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -277,8 +277,13 @@ int qedr_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr *attr)
 	attr->sm_lid = 0;
 	attr->sm_sl = 0;
 	attr->port_cap_flags = IB_PORT_IP_BASED_GIDS;
-	attr->gid_tbl_len = QEDR_MAX_SGID;
-	attr->pkey_tbl_len = QEDR_ROCE_PKEY_TABLE_LEN;
+	if (rdma_protocol_iwarp(&dev->ibdev, 1)) {
+		attr->gid_tbl_len = 1;
+		attr->pkey_tbl_len = 1;
+	} else {
+		attr->gid_tbl_len = QEDR_MAX_SGID;
+		attr->pkey_tbl_len = QEDR_ROCE_PKEY_TABLE_LEN;
+	}
 	attr->bad_pkey_cntr = rdma_port->pkey_bad_counter;
 	attr->qkey_viol_cntr = 0;
 	get_link_speed_and_width(rdma_port->link_speed,
@@ -1433,6 +1438,21 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 	return rc;
 }
 
+static void qedr_set_iwarp_db_info(struct qedr_dev *dev, struct qedr_qp *qp)
+{
+	qp->sq.db = dev->db_addr +
+	    DB_ADDR_SHIFT(DQ_PWM_OFFSET_XCM_RDMA_SQ_PROD);
+	qp->sq.db_data.data.icid = qp->icid;
+
+	qp->rq.db = dev->db_addr +
+		    DB_ADDR_SHIFT(DQ_PWM_OFFSET_TCM_IWARP_RQ_PROD);
+	qp->rq.db_data.data.icid = qp->icid;
+	qp->rq.iwarp_db2 = dev->db_addr +
+			   DB_ADDR_SHIFT(DQ_PWM_OFFSET_TCM_FLAGS);
+	qp->rq.iwarp_db2_data.data.icid = qp->icid;
+	qp->rq.iwarp_db2_data.data.value = DQ_TCM_IWARP_POST_RQ_CF_CMD;
+}
+
 static int
 qedr_roce_create_kernel_qp(struct qedr_dev *dev,
 			   struct qedr_qp *qp,
@@ -1479,8 +1499,71 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 	qp->icid = out_params.icid;
 
 	qedr_set_roce_db_info(dev, qp);
+	return rc;
+}
 
-	return 0;
+static int
+qedr_iwarp_create_kernel_qp(struct qedr_dev *dev,
+			    struct qedr_qp *qp,
+			    struct qed_rdma_create_qp_in_params *in_params,
+			    u32 n_sq_elems, u32 n_rq_elems)
+{
+	struct qed_rdma_create_qp_out_params out_params;
+	struct qed_chain_ext_pbl ext_pbl;
+	int rc;
+
+	in_params->sq_num_pages = QED_CHAIN_PAGE_CNT(n_sq_elems,
+						     QEDR_SQE_ELEMENT_SIZE,
+						     QED_CHAIN_MODE_PBL);
+	in_params->rq_num_pages = QED_CHAIN_PAGE_CNT(n_rq_elems,
+						     QEDR_RQE_ELEMENT_SIZE,
+						     QED_CHAIN_MODE_PBL);
+
+	qp->qed_qp = dev->ops->rdma_create_qp(dev->rdma_ctx,
+					      in_params, &out_params);
+
+	if (!qp->qed_qp)
+		return -EINVAL;
+
+	/* Now we allocate the chain */
+	ext_pbl.p_pbl_virt = out_params.sq_pbl_virt;
+	ext_pbl.p_pbl_phys = out_params.sq_pbl_phys;
+
+	rc = dev->ops->common->chain_alloc(dev->cdev,
+					   QED_CHAIN_USE_TO_PRODUCE,
+					   QED_CHAIN_MODE_PBL,
+					   QED_CHAIN_CNT_TYPE_U32,
+					   n_sq_elems,
+					   QEDR_SQE_ELEMENT_SIZE,
+					   &qp->sq.pbl, &ext_pbl);
+
+	if (rc)
+		goto err;
+
+	ext_pbl.p_pbl_virt = out_params.rq_pbl_virt;
+	ext_pbl.p_pbl_phys = out_params.rq_pbl_phys;
+
+	rc = dev->ops->common->chain_alloc(dev->cdev,
+					   QED_CHAIN_USE_TO_CONSUME_PRODUCE,
+					   QED_CHAIN_MODE_PBL,
+					   QED_CHAIN_CNT_TYPE_U32,
+					   n_rq_elems,
+					   QEDR_RQE_ELEMENT_SIZE,
+					   &qp->rq.pbl, &ext_pbl);
+
+	if (rc)
+		goto err;
+
+	qp->qp_id = out_params.qp_id;
+	qp->icid = out_params.icid;
+
+	qedr_set_iwarp_db_info(dev, qp);
+	return rc;
+
+err:
+	dev->ops->rdma_destroy_qp(dev->rdma_ctx, qp->qed_qp);
+
+	return rc;
 }
 
 static void qedr_cleanup_kernel(struct qedr_dev *dev, struct qedr_qp *qp)
@@ -1555,8 +1638,12 @@ static int qedr_create_kernel_qp(struct qedr_dev *dev,
 
 	n_rq_elems = qp->rq.max_wr * QEDR_MAX_RQE_ELEMENTS_PER_RQE;
 
-	rc = qedr_roce_create_kernel_qp(dev, qp, &in_params,
-					n_sq_elems, n_rq_elems);
+	if (rdma_protocol_iwarp(&dev->ibdev, 1))
+		rc = qedr_iwarp_create_kernel_qp(dev, qp, &in_params,
+						 n_sq_elems, n_rq_elems);
+	else
+		rc = qedr_roce_create_kernel_qp(dev, qp, &in_params,
+						n_sq_elems, n_rq_elems);
 	if (rc)
 		qedr_cleanup_kernel(dev, qp);
 
@@ -1703,10 +1790,13 @@ static int qedr_update_qp_state(struct qedr_dev *dev,
 			/* Update doorbell (in case post_recv was
 			 * done before move to RTR)
 			 */
-			wmb();
-			writel(qp->rq.db_data.raw, qp->rq.db);
-			/* Make sure write takes effect */
-			mmiowb();
+
+			if (rdma_protocol_roce(&dev->ibdev, 1)) {
+				wmb();
+				writel(qp->rq.db_data.raw, qp->rq.db);
+				/* Make sure write takes effect */
+				mmiowb();
+			}
 			break;
 		case QED_ROCE_QP_STATE_ERR:
 			break;
@@ -1800,16 +1890,18 @@ int qedr_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	else
 		new_qp_state = old_qp_state;
 
-	if (!ib_modify_qp_is_ok
-	    (old_qp_state, new_qp_state, ibqp->qp_type, attr_mask,
-	     IB_LINK_LAYER_ETHERNET)) {
-		DP_ERR(dev,
-		       "modify qp: invalid attribute mask=0x%x specified for\n"
-		       "qpn=0x%x of type=0x%x old_qp_state=0x%x, new_qp_state=0x%x\n",
-		       attr_mask, qp->qp_id, ibqp->qp_type, old_qp_state,
-		       new_qp_state);
-		rc = -EINVAL;
-		goto err;
+	if (rdma_protocol_roce(&dev->ibdev, 1)) {
+		if (!ib_modify_qp_is_ok(old_qp_state, new_qp_state,
+					ibqp->qp_type, attr_mask,
+					IB_LINK_LAYER_ETHERNET)) {
+			DP_ERR(dev,
+			       "modify qp: invalid attribute mask=0x%x specified for\n"
+			       "qpn=0x%x of type=0x%x old_qp_state=0x%x, new_qp_state=0x%x\n",
+			       attr_mask, qp->qp_id, ibqp->qp_type,
+			       old_qp_state, new_qp_state);
+			rc = -EINVAL;
+			goto err;
+		}
 	}
 
 	/* Translate the masks... */
@@ -2125,15 +2217,17 @@ int qedr_destroy_qp(struct ib_qp *ibqp)
 	DP_DEBUG(dev, QEDR_MSG_QP, "destroy qp: destroying %p, qp type=%d\n",
 		 qp, qp->qp_type);
 
-	if ((qp->state != QED_ROCE_QP_STATE_RESET) &&
-	    (qp->state != QED_ROCE_QP_STATE_ERR) &&
-	    (qp->state != QED_ROCE_QP_STATE_INIT)) {
+	if (rdma_protocol_roce(&dev->ibdev, 1)) {
+		if ((qp->state != QED_ROCE_QP_STATE_RESET) &&
+		    (qp->state != QED_ROCE_QP_STATE_ERR) &&
+		    (qp->state != QED_ROCE_QP_STATE_INIT)) {
 
-		attr.qp_state = IB_QPS_ERR;
-		attr_mask |= IB_QP_STATE;
+			attr.qp_state = IB_QPS_ERR;
+			attr_mask |= IB_QP_STATE;
 
-		/* Change the QP state to ERROR */
-		qedr_modify_qp(ibqp, &attr, attr_mask, NULL);
+			/* Change the QP state to ERROR */
+			qedr_modify_qp(ibqp, &attr, attr_mask, NULL);
+		}
 	}
 
 	if (qp->qp_type == IB_QPT_GSI)
@@ -3028,15 +3122,17 @@ int qedr_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 	spin_lock_irqsave(&qp->q_lock, flags);
 
-	if ((qp->state != QED_ROCE_QP_STATE_RTS) &&
-	    (qp->state != QED_ROCE_QP_STATE_ERR) &&
-	    (qp->state != QED_ROCE_QP_STATE_SQD)) {
-		spin_unlock_irqrestore(&qp->q_lock, flags);
-		*bad_wr = wr;
-		DP_DEBUG(dev, QEDR_MSG_CQ,
-			 "QP in wrong state! QP icid=0x%x state %d\n",
-			 qp->icid, qp->state);
-		return -EINVAL;
+	if (rdma_protocol_roce(&dev->ibdev, 1)) {
+		if ((qp->state != QED_ROCE_QP_STATE_RTS) &&
+		    (qp->state != QED_ROCE_QP_STATE_ERR) &&
+		    (qp->state != QED_ROCE_QP_STATE_SQD)) {
+			spin_unlock_irqrestore(&qp->q_lock, flags);
+			*bad_wr = wr;
+			DP_DEBUG(dev, QEDR_MSG_CQ,
+				 "QP in wrong state! QP icid=0x%x state %d\n",
+				 qp->icid, qp->state);
+			return -EINVAL;
+		}
 	}
 
 	while (wr) {
@@ -3156,6 +3252,11 @@ int qedr_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 		/* Make sure write sticks */
 		mmiowb();
 
+		if (rdma_protocol_iwarp(&dev->ibdev, 1)) {
+			writel(qp->rq.iwarp_db2_data.raw, qp->rq.iwarp_db2);
+			mmiowb();	/* for second doorbell */
+		}
+
 		wr = wr->next;
 	}
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
