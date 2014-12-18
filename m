From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 12/14] RDMA/ocrdma: remove reference of ocrdma_dev out of ocrdma_qp structure.
Date: Thu, 18 Dec 2014 14:13:06 +0530
Message-ID: <2520dbfb-7fe1-4128-8cea-bfbffa4339dc@CMEXHTCAS1.ad.emulex.com>
References: <1418892188-6623-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418892188-6623-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Use get_ocrdma_dev(ocrdma_qp->ibqp.device) function to access ocrdma
device pointer.

Signed-off-by: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |    1 -
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   44 +++++++++++++++-----------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   18 +++++-----
 3 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index b9fee0e..4dcec05 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -370,7 +370,6 @@ struct ocrdma_srq {
 
 struct ocrdma_qp {
 	struct ib_qp ibqp;
-	struct ocrdma_dev *dev;
 
 	u8 __iomem *sq_db;
 	struct ocrdma_qp_hwq_info sq;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index dc1e3d7..6e58f39 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2042,8 +2042,9 @@ void ocrdma_flush_qp(struct ocrdma_qp *qp)
 {
 	bool found;
 	unsigned long flags;
+	struct ocrdma_dev *dev = get_ocrdma_dev(qp->ibqp.device);
 
-	spin_lock_irqsave(&qp->dev->flush_q_lock, flags);
+	spin_lock_irqsave(&dev->flush_q_lock, flags);
 	found = ocrdma_is_qp_in_sq_flushlist(qp->sq_cq, qp);
 	if (!found)
 		list_add_tail(&qp->sq_entry, &qp->sq_cq->sq_head);
@@ -2052,7 +2053,7 @@ void ocrdma_flush_qp(struct ocrdma_qp *qp)
 		if (!found)
 			list_add_tail(&qp->rq_entry, &qp->rq_cq->rq_head);
 	}
-	spin_unlock_irqrestore(&qp->dev->flush_q_lock, flags);
+	spin_unlock_irqrestore(&dev->flush_q_lock, flags);
 }
 
 static void ocrdma_init_hwq_ptr(struct ocrdma_qp *qp)
@@ -2118,7 +2119,8 @@ static int ocrdma_set_create_qp_sq_cmd(struct ocrdma_create_qp_req *cmd,
 	int status;
 	u32 len, hw_pages, hw_page_size;
 	dma_addr_t pa;
-	struct ocrdma_dev *dev = qp->dev;
+	struct ocrdma_pd *pd = qp->pd;
+	struct ocrdma_dev *dev = get_ocrdma_dev(pd->ibpd.device);
 	struct pci_dev *pdev = dev->nic_info.pdev;
 	u32 max_wqe_allocated;
 	u32 max_sges = attrs->cap.max_send_sge;
@@ -2173,7 +2175,8 @@ static int ocrdma_set_create_qp_rq_cmd(struct ocrdma_create_qp_req *cmd,
 	int status;
 	u32 len, hw_pages, hw_page_size;
 	dma_addr_t pa = 0;
-	struct ocrdma_dev *dev = qp->dev;
+	struct ocrdma_pd *pd = qp->pd;
+	struct ocrdma_dev *dev = get_ocrdma_dev(pd->ibpd.device);
 	struct pci_dev *pdev = dev->nic_info.pdev;
 	u32 max_rqe_allocated = attrs->cap.max_recv_wr + 1;
 
@@ -2232,7 +2235,8 @@ static void ocrdma_set_create_qp_dpp_cmd(struct ocrdma_create_qp_req *cmd,
 static int ocrdma_set_create_qp_ird_cmd(struct ocrdma_create_qp_req *cmd,
 					struct ocrdma_qp *qp)
 {
-	struct ocrdma_dev *dev = qp->dev;
+	struct ocrdma_pd *pd = qp->pd;
+	struct ocrdma_dev *dev = get_ocrdma_dev(pd->ibpd.device);
 	struct pci_dev *pdev = dev->nic_info.pdev;
 	dma_addr_t pa = 0;
 	int ird_page_size = dev->attr.ird_page_size;
@@ -2303,8 +2307,8 @@ int ocrdma_mbx_create_qp(struct ocrdma_qp *qp, struct ib_qp_init_attr *attrs,
 {
 	int status = -ENOMEM;
 	u32 flags = 0;
-	struct ocrdma_dev *dev = qp->dev;
 	struct ocrdma_pd *pd = qp->pd;
+	struct ocrdma_dev *dev = get_ocrdma_dev(pd->ibpd.device);
 	struct pci_dev *pdev = dev->nic_info.pdev;
 	struct ocrdma_cq *cq;
 	struct ocrdma_create_qp_req *cmd;
@@ -2427,11 +2431,12 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	union ib_gid sgid, zgid;
 	u32 vlan_id;
 	u8 mac_addr[6];
+	struct ocrdma_dev *dev = get_ocrdma_dev(qp->ibqp.device);
 
 	if ((ah_attr->ah_flags & IB_AH_GRH) == 0)
 		return -EINVAL;
-	if (atomic_cmpxchg(&qp->dev->update_sl, 1, 0))
-		ocrdma_init_service_level(qp->dev);
+	if (atomic_cmpxchg(&dev->update_sl, 1, 0))
+		ocrdma_init_service_level(dev);
 	cmd->params.tclass_sq_psn |=
 	    (ah_attr->grh.traffic_class << OCRDMA_QP_PARAMS_TCLASS_SHIFT);
 	cmd->params.rnt_rc_sl_fl |=
@@ -2442,7 +2447,7 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	cmd->flags |= OCRDMA_QP_PARA_FLOW_LBL_VALID;
 	memcpy(&cmd->params.dgid[0], &ah_attr->grh.dgid.raw[0],
 	       sizeof(cmd->params.dgid));
-	status = ocrdma_query_gid(&qp->dev->ibdev, 1,
+	status = ocrdma_query_gid(&dev->ibdev, 1,
 			ah_attr->grh.sgid_index, &sgid);
 	if (status)
 		return status;
@@ -2453,7 +2458,7 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 
 	qp->sgid_idx = ah_attr->grh.sgid_index;
 	memcpy(&cmd->params.sgid[0], &sgid.raw[0], sizeof(cmd->params.sgid));
-	status = ocrdma_resolve_dmac(qp->dev, ah_attr, &mac_addr[0]);
+	status = ocrdma_resolve_dmac(dev, ah_attr, &mac_addr[0]);
 	if (status)
 		return status;
 	cmd->params.dmac_b0_to_b3 = mac_addr[0] | (mac_addr[1] << 8) |
@@ -2468,7 +2473,7 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 		    vlan_id << OCRDMA_QP_PARAMS_VLAN_SHIFT;
 		cmd->flags |= OCRDMA_QP_PARA_VLAN_EN_VALID;
 		cmd->params.rnt_rc_sl_fl |=
-			(qp->dev->sl & 0x07) << OCRDMA_QP_PARAMS_SL_SHIFT;
+			(dev->sl & 0x07) << OCRDMA_QP_PARAMS_SL_SHIFT;
 	}
 	return 0;
 }
@@ -2478,6 +2483,7 @@ static int ocrdma_set_qp_params(struct ocrdma_qp *qp,
 				struct ib_qp_attr *attrs, int attr_mask)
 {
 	int status = 0;
+	struct ocrdma_dev *dev = get_ocrdma_dev(qp->ibqp.device);
 
 	if (attr_mask & IB_QP_PKEY_INDEX) {
 		cmd->params.path_mtu_pkey_indx |= (attrs->pkey_index &
@@ -2495,12 +2501,12 @@ static int ocrdma_set_qp_params(struct ocrdma_qp *qp,
 			return status;
 	} else if (qp->qp_type == IB_QPT_GSI || qp->qp_type == IB_QPT_UD) {
 		/* set the default mac address for UD, GSI QPs */
-		cmd->params.dmac_b0_to_b3 = qp->dev->nic_info.mac_addr[0] |
-			(qp->dev->nic_info.mac_addr[1] << 8) |
-			(qp->dev->nic_info.mac_addr[2] << 16) |
-			(qp->dev->nic_info.mac_addr[3] << 24);
-		cmd->params.vlan_dmac_b4_to_b5 = qp->dev->nic_info.mac_addr[4] |
-					(qp->dev->nic_info.mac_addr[5] << 8);
+		cmd->params.dmac_b0_to_b3 = dev->nic_info.mac_addr[0] |
+			(dev->nic_info.mac_addr[1] << 8) |
+			(dev->nic_info.mac_addr[2] << 16) |
+			(dev->nic_info.mac_addr[3] << 24);
+		cmd->params.vlan_dmac_b4_to_b5 = dev->nic_info.mac_addr[4] |
+					(dev->nic_info.mac_addr[5] << 8);
 	}
 	if ((attr_mask & IB_QP_EN_SQD_ASYNC_NOTIFY) &&
 	    attrs->en_sqd_async_notify) {
@@ -2557,7 +2563,7 @@ static int ocrdma_set_qp_params(struct ocrdma_qp *qp,
 		cmd->flags |= OCRDMA_QP_PARA_RQPSN_VALID;
 	}
 	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC) {
-		if (attrs->max_rd_atomic > qp->dev->attr.max_ord_per_qp) {
+		if (attrs->max_rd_atomic > dev->attr.max_ord_per_qp) {
 			status = -EINVAL;
 			goto pmtu_err;
 		}
@@ -2565,7 +2571,7 @@ static int ocrdma_set_qp_params(struct ocrdma_qp *qp,
 		cmd->flags |= OCRDMA_QP_PARA_MAX_ORD_VALID;
 	}
 	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC) {
-		if (attrs->max_dest_rd_atomic > qp->dev->attr.max_ird_per_qp) {
+		if (attrs->max_dest_rd_atomic > dev->attr.max_ird_per_qp) {
 			status = -EINVAL;
 			goto pmtu_err;
 		}
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 793d9fb..27def39 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1219,8 +1219,8 @@ static int ocrdma_copy_qp_uresp(struct ocrdma_qp *qp,
 	int status = 0;
 	u64 usr_db;
 	struct ocrdma_create_qp_uresp uresp;
-	struct ocrdma_dev *dev = qp->dev;
 	struct ocrdma_pd *pd = qp->pd;
+	struct ocrdma_dev *dev = get_ocrdma_dev(pd->ibpd.device);
 
 	memset(&uresp, 0, sizeof(uresp));
 	usr_db = dev->nic_info.unmapped_db +
@@ -1359,7 +1359,6 @@ struct ib_qp *ocrdma_create_qp(struct ib_pd *ibpd,
 		status = -ENOMEM;
 		goto gen_err;
 	}
-	qp->dev = dev;
 	ocrdma_set_qp_init_params(qp, pd, attrs);
 	if (udata == NULL)
 		qp->cap_flags |= (OCRDMA_QP_MW_BIND | OCRDMA_QP_LKEY0 |
@@ -1418,7 +1417,7 @@ int _ocrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	enum ib_qp_state old_qps;
 
 	qp = get_ocrdma_qp(ibqp);
-	dev = qp->dev;
+	dev = get_ocrdma_dev(ibqp->device);
 	if (attr_mask & IB_QP_STATE)
 		status = ocrdma_qp_state_change(qp, attr->qp_state, &old_qps);
 	/* if new and previous states are same hw doesn't need to
@@ -1441,7 +1440,7 @@ int ocrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	enum ib_qp_state old_qps, new_qps;
 
 	qp = get_ocrdma_qp(ibqp);
-	dev = qp->dev;
+	dev = get_ocrdma_dev(ibqp->device);
 
 	/* syncronize with multiple context trying to change, retrive qps */
 	mutex_lock(&dev->dev_lock);
@@ -1508,7 +1507,7 @@ int ocrdma_query_qp(struct ib_qp *ibqp,
 	u32 qp_state;
 	struct ocrdma_qp_params params;
 	struct ocrdma_qp *qp = get_ocrdma_qp(ibqp);
-	struct ocrdma_dev *dev = qp->dev;
+	struct ocrdma_dev *dev = get_ocrdma_dev(ibqp->device);
 
 	memset(&params, 0, sizeof(params));
 	mutex_lock(&dev->dev_lock);
@@ -1704,7 +1703,7 @@ void ocrdma_del_flush_qp(struct ocrdma_qp *qp)
 {
 	int found = false;
 	unsigned long flags;
-	struct ocrdma_dev *dev = qp->dev;
+	struct ocrdma_dev *dev = get_ocrdma_dev(qp->ibqp.device);
 	/* sync with any active CQ poll */
 
 	spin_lock_irqsave(&dev->flush_q_lock, flags);
@@ -1729,7 +1728,7 @@ int ocrdma_destroy_qp(struct ib_qp *ibqp)
 	unsigned long flags;
 
 	qp = get_ocrdma_qp(ibqp);
-	dev = qp->dev;
+	dev = get_ocrdma_dev(ibqp->device);
 
 	attrs.qp_state = IB_QPS_ERR;
 	pd = qp->pd;
@@ -2114,11 +2113,12 @@ static int ocrdma_build_fr(struct ocrdma_qp *qp, struct ocrdma_hdr_wqe *hdr,
 	u64 fbo;
 	struct ocrdma_ewqe_fr *fast_reg = (struct ocrdma_ewqe_fr *)(hdr + 1);
 	struct ocrdma_mr *mr;
+	struct ocrdma_dev *dev = get_ocrdma_dev(qp->ibqp.device);
 	u32 wqe_size = sizeof(*fast_reg) + sizeof(*hdr);
 
 	wqe_size = roundup(wqe_size, OCRDMA_WQE_ALIGN_BYTES);
 
-	if (wr->wr.fast_reg.page_list_len > qp->dev->attr.max_pages_per_frmr)
+	if (wr->wr.fast_reg.page_list_len > dev->attr.max_pages_per_frmr)
 		return -EINVAL;
 
 	hdr->cw |= (OCRDMA_FR_MR << OCRDMA_WQE_OPCODE_SHIFT);
@@ -2146,7 +2146,7 @@ static int ocrdma_build_fr(struct ocrdma_qp *qp, struct ocrdma_hdr_wqe *hdr,
 	fast_reg->size_sge =
 		get_encoded_page_size(1 << wr->wr.fast_reg.page_shift);
 	mr = (struct ocrdma_mr *) (unsigned long)
-		qp->dev->stag_arr[(hdr->lkey >> 8) & (OCRDMA_MAX_STAG - 1)];
+		dev->stag_arr[(hdr->lkey >> 8) & (OCRDMA_MAX_STAG - 1)];
 	build_frmr_pbes(wr, mr->hwmr.pbl_table, &mr->hwmr);
 	return 0;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
