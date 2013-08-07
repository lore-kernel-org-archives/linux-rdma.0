From: <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/6] RDMA/ocrdma: Style and redundant code cleanup.
Date: Wed, 7 Aug 2013 12:52:32 +0530
Message-ID: <1bf6de3d-0bef-440d-8d41-2e41956a3e4c@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Code cleanup and remove redunt code. More details of cleanup below.
1) redundant initialization removed
2) braces changed as per CodingStyle.
3) redundant checks removed
4) extra braces in return statements removed.
5) removed unused pd pointer from mr.
6) reorganized get_dma_mr()
7) fixed set_av() to return error on invalid sgid index.
8) reference to ocrdma_dev removed from struct ocrdma_pd.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |   3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |   4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  75 ++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 104 +++++++++++++++-------------
 4 files changed, 96 insertions(+), 90 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index d540180..5c00600 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -317,7 +317,6 @@ struct ocrdma_mr {
 	struct ib_mr ibmr;
 	struct ib_umem *umem;
 	struct ocrdma_hw_mr hwmr;
-	struct ocrdma_pd *pd;
 };
 
 struct ocrdma_ucontext {
@@ -393,7 +392,7 @@ static inline int is_cqe_valid(struct ocrdma_cq *cq, struct ocrdma_cqe *cqe)
 {
 	int cqe_valid;
 	cqe_valid = le32_to_cpu(cqe->flags_status_srcqpn) & OCRDMA_CQE_VALID;
-	return ((cqe_valid == cq->phase) ? 1 : 0);
+	return (cqe_valid == cq->phase);
 }
 
 static inline int is_cqe_for_sq(struct ocrdma_cqe *cqe)
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index a877a8e..55f94ac 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -93,7 +93,7 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 	int status;
 	struct ocrdma_ah *ah;
 	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
-	struct ocrdma_dev *dev = pd->dev;
+	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
 
 	if (!(attr->ah_flags & IB_AH_GRH))
 		return ERR_PTR(-EINVAL);
@@ -101,7 +101,7 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 	ah = kzalloc(sizeof *ah, GFP_ATOMIC);
 	if (!ah)
 		return ERR_PTR(-ENOMEM);
-	ah->dev = pd->dev;
+	ah->dev = dev;
 
 	status = ocrdma_alloc_av(dev, ah);
 	if (status)
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 0965278..eb41a1c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -94,7 +94,7 @@ enum cqe_status {
 
 static inline void *ocrdma_get_eqe(struct ocrdma_eq *eq)
 {
-	return (u8 *)eq->q.va + (eq->q.tail * sizeof(struct ocrdma_eqe));
+	return eq->q.va + (eq->q.tail * sizeof(struct ocrdma_eqe));
 }
 
 static inline void ocrdma_eq_inc_tail(struct ocrdma_eq *eq)
@@ -105,8 +105,7 @@ static inline void ocrdma_eq_inc_tail(struct ocrdma_eq *eq)
 static inline void *ocrdma_get_mcqe(struct ocrdma_dev *dev)
 {
 	struct ocrdma_mcqe *cqe = (struct ocrdma_mcqe *)
-	    ((u8 *) dev->mq.cq.va +
-	     (dev->mq.cq.tail * sizeof(struct ocrdma_mcqe)));
+	    (dev->mq.cq.va + (dev->mq.cq.tail * sizeof(struct ocrdma_mcqe)));
 
 	if (!(le32_to_cpu(cqe->valid_ae_cmpl_cons) & OCRDMA_MCQE_VALID_MASK))
 		return NULL;
@@ -120,9 +119,7 @@ static inline void ocrdma_mcq_inc_tail(struct ocrdma_dev *dev)
 
 static inline struct ocrdma_mqe *ocrdma_get_mqe(struct ocrdma_dev *dev)
 {
-	return (struct ocrdma_mqe *)((u8 *) dev->mq.sq.va +
-				     (dev->mq.sq.head *
-				      sizeof(struct ocrdma_mqe)));
+	return dev->mq.sq.va + (dev->mq.sq.head * sizeof(struct ocrdma_mqe));
 }
 
 static inline void ocrdma_mq_inc_head(struct ocrdma_dev *dev)
@@ -132,8 +129,7 @@ static inline void ocrdma_mq_inc_head(struct ocrdma_dev *dev)
 
 static inline void *ocrdma_get_mqe_rsp(struct ocrdma_dev *dev)
 {
-	return (void *)((u8 *) dev->mq.sq.va +
-			(dev->mqe_ctx.tag * sizeof(struct ocrdma_mqe)));
+	return dev->mq.sq.va + (dev->mqe_ctx.tag * sizeof(struct ocrdma_mqe));
 }
 
 enum ib_qp_state get_ibqp_state(enum ocrdma_qp_state qps)
@@ -181,7 +177,7 @@ static enum ocrdma_qp_state get_ocrdma_qp_state(enum ib_qp_state qps)
 
 static int ocrdma_get_mbx_errno(u32 status)
 {
-	int err_num = -EFAULT;
+	int err_num;
 	u8 mbox_status = (status & OCRDMA_MBX_RSP_STATUS_MASK) >>
 					OCRDMA_MBX_RSP_STATUS_SHIFT;
 	u8 add_status = (status & OCRDMA_MBX_RSP_ASTATUS_MASK) >>
@@ -438,9 +434,9 @@ static int ocrdma_mbx_create_eq(struct ocrdma_dev *dev, struct ocrdma_eq *eq)
 				 NULL);
 	if (!status) {
 		eq->q.id = rsp->vector_eqid & 0xffff;
-		if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY)
+		if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
 			ocrdma_assign_eq_vect_gen2(dev, eq);
-		else {
+		} else {
 			eq->vector = (rsp->vector_eqid >> 16) & 0xffff;
 			dev->nic_info.msix.start_vector += 1;
 		}
@@ -746,8 +742,9 @@ static void ocrdma_dispatch_ibevent(struct ocrdma_dev *dev,
 			qp->srq->ibsrq.event_handler(&ib_evt,
 						     qp->srq->ibsrq.
 						     srq_context);
-	} else if (dev_event)
+	} else if (dev_event) {
 		ib_dispatch_event(&ib_evt);
+	}
 
 }
 
@@ -957,9 +954,8 @@ static int ocrdma_mbx_cmd(struct ocrdma_dev *dev, struct ocrdma_mqe *mqe)
 	rsp = ocrdma_get_mqe_rsp(dev);
 	ocrdma_copy_le32_to_cpu(mqe, rsp, (sizeof(*mqe)));
 	if (cqe_status || ext_status) {
-		pr_err
-		    ("%s() opcode=0x%x, cqe_status=0x%x, ext_status=0x%x\n",
-		     __func__,
+		pr_err("%s() opcode=0x%x, cqe_status=0x%x, ext_status=0x%x\n",
+		       __func__,
 		     (rsp->u.rsp.subsys_op & OCRDMA_MBX_RSP_OPCODE_MASK) >>
 		     OCRDMA_MBX_RSP_OPCODE_SHIFT, cqe_status, ext_status);
 		status = ocrdma_get_mbx_cqe_errno(cqe_status);
@@ -1377,15 +1373,13 @@ int ocrdma_mbx_create_cq(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
 	cmd->cmd.pgsz_pgcnt |= hw_pages;
 	cmd->cmd.ev_cnt_flags = OCRDMA_CREATE_CQ_DEF_FLAGS;
 
-	if (dev->eq_cnt < 0)
-		goto eq_err;
 	cq->eqn = ocrdma_bind_eq(dev);
 	cmd->cmd.req.rsvd_version = OCRDMA_CREATE_CQ_VER2;
 	cqe_count = cq->len / cqe_size;
-	if (cqe_count > 1024)
+	if (cqe_count > 1024) {
 		/* Set cnt to 3 to indicate more than 1024 cq entries */
 		cmd->cmd.ev_cnt_flags |= (0x3 << OCRDMA_CREATE_CQ_CNT_SHIFT);
-	else {
+	} else {
 		u8 count = 0;
 		switch (cqe_count) {
 		case 256:
@@ -1427,7 +1421,6 @@ int ocrdma_mbx_create_cq(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
 	return 0;
 mbx_err:
 	ocrdma_unbind_eq(dev, cq->eqn);
-eq_err:
 	dma_free_coherent(&pdev->dev, cq->len, cq->va, cq->pa);
 mem_err:
 	kfree(cmd);
@@ -2057,9 +2050,10 @@ int ocrdma_mbx_create_qp(struct ocrdma_qp *qp, struct ib_qp_init_attr *attrs,
 	qp->rq_cq = cq;
 
 	if (pd->dpp_enabled && attrs->cap.max_inline_data && pd->num_dpp_qp &&
-	    (attrs->cap.max_inline_data <= dev->attr.max_inline_data))
+	    (attrs->cap.max_inline_data <= dev->attr.max_inline_data)) {
 		ocrdma_set_create_qp_dpp_cmd(cmd, pd, qp, enable_dpp_cq,
 					     dpp_cq_id);
+	}
 
 	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
 	if (status)
@@ -2108,27 +2102,28 @@ int ocrdma_resolve_dgid(struct ocrdma_dev *dev, union ib_gid *dgid,
 	struct in6_addr in6;
 
 	memcpy(&in6, dgid, sizeof in6);
-	if (rdma_is_multicast_addr(&in6))
+	if (rdma_is_multicast_addr(&in6)) {
 		rdma_get_mcast_mac(&in6, mac_addr);
-	else if (rdma_link_local_addr(&in6))
+	} else if (rdma_link_local_addr(&in6)) {
 		rdma_get_ll_mac(&in6, mac_addr);
-	else {
+	} else {
 		pr_err("%s() fail to resolve mac_addr.\n", __func__);
 		return -EINVAL;
 	}
 	return 0;
 }
 
-static void ocrdma_set_av_params(struct ocrdma_qp *qp,
+static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 				struct ocrdma_modify_qp *cmd,
 				struct ib_qp_attr *attrs)
 {
+	int status;
 	struct ib_ah_attr *ah_attr = &attrs->ah_attr;
 	union ib_gid sgid;
 	u32 vlan_id;
 	u8 mac_addr[6];
 	if ((ah_attr->ah_flags & IB_AH_GRH) == 0)
-		return;
+		return -EINVAL;
 	cmd->params.tclass_sq_psn |=
 	    (ah_attr->grh.traffic_class << OCRDMA_QP_PARAMS_TCLASS_SHIFT);
 	cmd->params.rnt_rc_sl_fl |=
@@ -2138,8 +2133,10 @@ static void ocrdma_set_av_params(struct ocrdma_qp *qp,
 	cmd->flags |= OCRDMA_QP_PARA_FLOW_LBL_VALID;
 	memcpy(&cmd->params.dgid[0], &ah_attr->grh.dgid.raw[0],
 	       sizeof(cmd->params.dgid));
-	ocrdma_query_gid(&qp->dev->ibdev, 1,
+	status = ocrdma_query_gid(&qp->dev->ibdev, 1,
 			 ah_attr->grh.sgid_index, &sgid);
+	if (status)
+		return status;
 	qp->sgid_idx = ah_attr->grh.sgid_index;
 	memcpy(&cmd->params.sgid[0], &sgid.raw[0], sizeof(cmd->params.sgid));
 	ocrdma_resolve_dgid(qp->dev, &ah_attr->grh.dgid, &mac_addr[0]);
@@ -2155,6 +2152,7 @@ static void ocrdma_set_av_params(struct ocrdma_qp *qp,
 		    vlan_id << OCRDMA_QP_PARAMS_VLAN_SHIFT;
 		cmd->flags |= OCRDMA_QP_PARA_VLAN_EN_VALID;
 	}
+	return 0;
 }
 
 static int ocrdma_set_qp_params(struct ocrdma_qp *qp,
@@ -2176,9 +2174,11 @@ static int ocrdma_set_qp_params(struct ocrdma_qp *qp,
 		cmd->params.qkey = attrs->qkey;
 		cmd->flags |= OCRDMA_QP_PARA_QKEY_VALID;
 	}
-	if (attr_mask & IB_QP_AV)
-		ocrdma_set_av_params(qp, cmd, attrs);
-	else if (qp->qp_type == IB_QPT_GSI || qp->qp_type == IB_QPT_UD) {
+	if (attr_mask & IB_QP_AV) {
+		status = ocrdma_set_av_params(qp, cmd, attrs);
+		if (status)
+			return status;
+	} else if (qp->qp_type == IB_QPT_GSI || qp->qp_type == IB_QPT_UD) {
 		/* set the default mac address for UD, GSI QPs */
 		cmd->params.dmac_b0_to_b3 = qp->dev->nic_info.mac_addr[0] |
 			(qp->dev->nic_info.mac_addr[1] << 8) |
@@ -2283,10 +2283,12 @@ int ocrdma_mbx_modify_qp(struct ocrdma_dev *dev, struct ocrdma_qp *qp,
 		     OCRDMA_QP_PARAMS_STATE_SHIFT) &
 		    OCRDMA_QP_PARAMS_STATE_MASK;
 		cmd->flags |= OCRDMA_QP_PARA_QPS_VALID;
-	} else
+	} else {
 		cmd->params.max_sge_recv_flags |=
 		    (qp->state << OCRDMA_QP_PARAMS_STATE_SHIFT) &
 		    OCRDMA_QP_PARAMS_STATE_MASK;
+	}
+
 	status = ocrdma_set_qp_params(qp, cmd, attrs, attr_mask, old_qps);
 	if (status)
 		goto mbx_err;
@@ -2497,9 +2499,9 @@ static int ocrdma_create_mq_eq(struct ocrdma_dev *dev)
 	unsigned long flags = 0;
 	int num_eq = 0;
 
-	if (dev->nic_info.intr_mode == BE_INTERRUPT_MODE_INTX)
+	if (dev->nic_info.intr_mode == BE_INTERRUPT_MODE_INTX) {
 		flags = IRQF_SHARED;
-	else {
+	} else {
 		num_eq = dev->nic_info.msix.num_vectors -
 				dev->nic_info.msix.start_vector;
 		/* minimum two vectors/eq are required for rdma to work.
@@ -2532,8 +2534,10 @@ static int ocrdma_create_qp_eqs(struct ocrdma_dev *dev)
 	if (dev->nic_info.intr_mode == BE_INTERRUPT_MODE_INTX) {
 		num_eq = 1;
 		flags = IRQF_SHARED;
-	} else
+	} else {
 		num_eq = min_t(u32, num_eq, num_online_cpus());
+	}
+
 	dev->qp_eq_tbl = kzalloc(sizeof(struct ocrdma_eq) * num_eq, GFP_KERNEL);
 	if (!dev->qp_eq_tbl)
 		return -ENOMEM;
@@ -2561,8 +2565,7 @@ static int ocrdma_create_qp_eqs(struct ocrdma_dev *dev)
 	/* one eq is sufficient for data path to work */
 	if (dev->eq_cnt >= 1)
 		return 0;
-	if (status)
-		ocrdma_destroy_qp_eqs(dev);
+	ocrdma_destroy_qp_eqs(dev);
 	return status;
 }
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index dcfbab1..d3d2d54 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -337,19 +337,20 @@ static int ocrdma_copy_pd_uresp(struct ocrdma_pd *pd,
 	u32 db_page_size;
 	struct ocrdma_alloc_pd_uresp rsp;
 	struct ocrdma_ucontext *uctx = get_ocrdma_ucontext(ib_ctx);
+	struct ocrdma_dev *dev = get_ocrdma_dev(pd->ibpd.device);
 
 	rsp.id = pd->id;
 	rsp.dpp_enabled = pd->dpp_enabled;
-	db_page_addr = pd->dev->nic_info.unmapped_db +
-			(pd->id * pd->dev->nic_info.db_page_size);
-	db_page_size = pd->dev->nic_info.db_page_size;
+	db_page_addr = dev->nic_info.unmapped_db +
+			(pd->id * dev->nic_info.db_page_size);
+	db_page_size = dev->nic_info.db_page_size;
 
 	status = ocrdma_add_mmap(uctx, db_page_addr, db_page_size);
 	if (status)
 		return status;
 
 	if (pd->dpp_enabled) {
-		dpp_page_addr = pd->dev->nic_info.dpp_unmapped_addr +
+		dpp_page_addr = dev->nic_info.dpp_unmapped_addr +
 				(pd->id * OCRDMA_DPP_PAGE_SIZE);
 		status = ocrdma_add_mmap(uctx, dpp_page_addr,
 				 OCRDMA_DPP_PAGE_SIZE);
@@ -385,10 +386,9 @@ struct ib_pd *ocrdma_alloc_pd(struct ib_device *ibdev,
 	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
 	if (!pd)
 		return ERR_PTR(-ENOMEM);
-	pd->dev = dev;
 	if (udata && context) {
-		pd->dpp_enabled = (dev->nic_info.dev_family ==
-					OCRDMA_GEN2_FAMILY) ? true : false;
+		pd->dpp_enabled =
+			(dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY);
 		pd->num_dpp_qp =
 			pd->dpp_enabled ? OCRDMA_PD_MAX_DPP_ENABLED_QP : 0;
 	}
@@ -413,7 +413,7 @@ err:
 int ocrdma_dealloc_pd(struct ib_pd *ibpd)
 {
 	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
-	struct ocrdma_dev *dev = pd->dev;
+	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
 	int status;
 	u64 usr_db;
 
@@ -431,25 +431,12 @@ int ocrdma_dealloc_pd(struct ib_pd *ibpd)
 	return status;
 }
 
-static struct ocrdma_mr *ocrdma_alloc_lkey(struct ib_pd *ibpd,
-					   int acc, u32 num_pbls,
-					   u32 addr_check)
+static int ocrdma_alloc_lkey(struct ocrdma_mr *mr, u32 pdid, int acc,
+			    u32 num_pbls, u32 addr_check)
 {
 	int status;
-	struct ocrdma_mr *mr;
-	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
-	struct ocrdma_dev *dev = pd->dev;
-
-	if (acc & IB_ACCESS_REMOTE_WRITE && !(acc & IB_ACCESS_LOCAL_WRITE)) {
-		pr_err("%s(%d) leaving err, invalid access rights\n",
-		       __func__, dev->id);
-		return ERR_PTR(-EINVAL);
-	}
+	struct ocrdma_dev *dev = mr->hwmr.dev;
 
-	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
-	if (!mr)
-		return ERR_PTR(-ENOMEM);
-	mr->hwmr.dev = dev;
 	mr->hwmr.fr_mr = 0;
 	mr->hwmr.local_rd = 1;
 	mr->hwmr.remote_rd = (acc & IB_ACCESS_REMOTE_READ) ? 1 : 0;
@@ -459,25 +446,39 @@ static struct ocrdma_mr *ocrdma_alloc_lkey(struct ib_pd *ibpd,
 	mr->hwmr.remote_atomic = (acc & IB_ACCESS_REMOTE_ATOMIC) ? 1 : 0;
 	mr->hwmr.num_pbls = num_pbls;
 
-	status = ocrdma_mbx_alloc_lkey(dev, &mr->hwmr, pd->id, addr_check);
-	if (status) {
-		kfree(mr);
-		return ERR_PTR(-ENOMEM);
-	}
-	mr->pd = pd;
+	status = ocrdma_mbx_alloc_lkey(dev, &mr->hwmr, pdid, addr_check);
+	if (status)
+		return status;
+
 	mr->ibmr.lkey = mr->hwmr.lkey;
 	if (mr->hwmr.remote_wr || mr->hwmr.remote_rd)
 		mr->ibmr.rkey = mr->hwmr.lkey;
-	return mr;
+	return 0;
 }
 
 struct ib_mr *ocrdma_get_dma_mr(struct ib_pd *ibpd, int acc)
 {
+	int status;
 	struct ocrdma_mr *mr;
+	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
+	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
+
+	if (acc & IB_ACCESS_REMOTE_WRITE && !(acc & IB_ACCESS_LOCAL_WRITE)) {
+		pr_err("%s err, invalid access rights\n", __func__);
+		return ERR_PTR(-EINVAL);
+	}
 
-	mr = ocrdma_alloc_lkey(ibpd, acc, 0, OCRDMA_ADDR_CHECK_DISABLE);
-	if (IS_ERR(mr))
-		return ERR_CAST(mr);
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	mr->hwmr.dev = dev;
+	status = ocrdma_alloc_lkey(mr, pd->id, acc, 0,
+				   OCRDMA_ADDR_CHECK_DISABLE);
+	if (status) {
+		kfree(mr);
+		return ERR_PTR(status);
+	}
 
 	return &mr->ibmr;
 }
@@ -612,13 +613,12 @@ struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 				 u64 usr_addr, int acc, struct ib_udata *udata)
 {
 	int status = -ENOMEM;
-	struct ocrdma_dev *dev;
+	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
 	struct ocrdma_mr *mr;
 	struct ocrdma_pd *pd;
 	u32 num_pbes;
 
 	pd = get_ocrdma_pd(ibpd);
-	dev = pd->dev;
 
 	if (acc & IB_ACCESS_REMOTE_WRITE && !(acc & IB_ACCESS_LOCAL_WRITE))
 		return ERR_PTR(-EINVAL);
@@ -653,7 +653,6 @@ struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 	status = ocrdma_reg_mr(dev, &mr->hwmr, pd->id, acc);
 	if (status)
 		goto mbx_err;
-	mr->pd = pd;
 	mr->ibmr.lkey = mr->hwmr.lkey;
 	if (mr->hwmr.remote_wr || mr->hwmr.remote_rd)
 		mr->ibmr.rkey = mr->hwmr.lkey;
@@ -1024,7 +1023,7 @@ struct ib_qp *ocrdma_create_qp(struct ib_pd *ibpd,
 	int status;
 	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
 	struct ocrdma_qp *qp;
-	struct ocrdma_dev *dev = pd->dev;
+	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
 	struct ocrdma_create_qp_ureq ureq;
 	u16 dpp_credit_lmt, dpp_offset;
 
@@ -1358,17 +1357,18 @@ static void ocrdma_discard_cqes(struct ocrdma_qp *qp, struct ocrdma_cq *cq)
 		 */
 		discard_cnt += 1;
 		cqe->cmn.qpn = 0;
-		if (is_cqe_for_sq(cqe))
+		if (is_cqe_for_sq(cqe)) {
 			ocrdma_hwq_inc_tail(&qp->sq);
-		else {
+		} else {
 			if (qp->srq) {
 				spin_lock_irqsave(&qp->srq->q_lock, flags);
 				ocrdma_hwq_inc_tail(&qp->srq->rq);
 				ocrdma_srq_toggle_bit(qp->srq, cur_getp);
 				spin_unlock_irqrestore(&qp->srq->q_lock, flags);
 
-			} else
+			} else {
 				ocrdma_hwq_inc_tail(&qp->rq);
+			}
 		}
 skip_cqe:
 		cur_getp = (cur_getp + 1) % cq->max_hw_cqe;
@@ -1492,7 +1492,7 @@ struct ib_srq *ocrdma_create_srq(struct ib_pd *ibpd,
 {
 	int status = -ENOMEM;
 	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
-	struct ocrdma_dev *dev = pd->dev;
+	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
 	struct ocrdma_srq *srq;
 
 	if (init_attr->attr.max_sge > dev->attr.max_recv_sge)
@@ -1672,8 +1672,9 @@ static int ocrdma_build_send(struct ocrdma_qp *qp, struct ocrdma_hdr_wqe *hdr,
 		ocrdma_build_ud_hdr(qp, hdr, wr);
 		sge = (struct ocrdma_sge *)(hdr + 2);
 		wqe_size += sizeof(struct ocrdma_ewqe_ud_hdr);
-	} else
+	} else {
 		sge = (struct ocrdma_sge *)(hdr + 1);
+	}
 
 	status = ocrdma_build_inline_sges(qp, hdr, sge, wr, wqe_size);
 	return status;
@@ -1955,7 +1956,7 @@ int ocrdma_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 
 static enum ib_wc_status ocrdma_to_ibwc_err(u16 status)
 {
-	enum ib_wc_status ibwc_status = IB_WC_GENERAL_ERR;
+	enum ib_wc_status ibwc_status;
 
 	switch (status) {
 	case OCRDMA_CQE_GENERAL_ERR:
@@ -2296,9 +2297,9 @@ static void ocrdma_poll_success_rcqe(struct ocrdma_qp *qp,
 		ibwc->ex.invalidate_rkey = le32_to_cpu(cqe->rq.lkey_immdt);
 		ibwc->wc_flags |= IB_WC_WITH_INVALIDATE;
 	}
-	if (qp->ibqp.srq)
+	if (qp->ibqp.srq) {
 		ocrdma_update_free_srq_cqe(ibwc, cqe, qp);
-	else {
+	} else {
 		ibwc->wr_id = qp->rqe_wr_id_tbl[qp->rq.tail];
 		ocrdma_hwq_inc_tail(&qp->rq);
 	}
@@ -2311,13 +2312,14 @@ static bool ocrdma_poll_rcqe(struct ocrdma_qp *qp, struct ocrdma_cqe *cqe,
 	bool expand = false;
 
 	ibwc->wc_flags = 0;
-	if (qp->qp_type == IB_QPT_UD || qp->qp_type == IB_QPT_GSI)
+	if (qp->qp_type == IB_QPT_UD || qp->qp_type == IB_QPT_GSI) {
 		status = (le32_to_cpu(cqe->flags_status_srcqpn) &
 					OCRDMA_CQE_UD_STATUS_MASK) >>
 					OCRDMA_CQE_UD_STATUS_SHIFT;
-	else
+	} else {
 		status = (le32_to_cpu(cqe->flags_status_srcqpn) &
 			     OCRDMA_CQE_STATUS_MASK) >> OCRDMA_CQE_STATUS_SHIFT;
+	}
 
 	if (status == OCRDMA_CQE_SUCCESS) {
 		*polled = true;
@@ -2335,9 +2337,10 @@ static void ocrdma_change_cq_phase(struct ocrdma_cq *cq, struct ocrdma_cqe *cqe,
 	if (cq->phase_change) {
 		if (cur_getp == 0)
 			cq->phase = (~cq->phase & OCRDMA_CQE_VALID);
-	} else
+	} else {
 		/* clear valid bit */
 		cqe->flags_status_srcqpn = 0;
+	}
 }
 
 static int ocrdma_poll_hwcq(struct ocrdma_cq *cq, int num_entries,
@@ -2414,8 +2417,9 @@ static int ocrdma_add_err_cqe(struct ocrdma_cq *cq, int num_entries,
 		} else if (!is_hw_rq_empty(qp) && qp->rq_cq == cq) {
 			ibwc->wr_id = qp->rqe_wr_id_tbl[qp->rq.tail];
 			ocrdma_hwq_inc_tail(&qp->rq);
-		} else
+		} else {
 			return err_cqes;
+		}
 		ibwc->byte_len = 0;
 		ibwc->status = IB_WC_WR_FLUSH_ERR;
 		ibwc = ibwc + 1;
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
