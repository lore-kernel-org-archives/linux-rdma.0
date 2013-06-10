From: <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/5] RDMA/ocrdma: replaced ocrdma_err with pr_err.
Date: Mon, 10 Jun 2013 10:12:39 +0530
Message-ID: <2828bdc4-8784-42c2-ac38-7e4e079eab15@CMEXHTCAS2.ad.emulex.com>
References: <1370839362-3871-1-git-send-email-bgottumukkala@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370839362-3871-1-git-send-email-bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Removed using self defined macro ocrdma_err and replaced with standard pr_err.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |  2 -
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 44 +++++++-------
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 92 ++++++++++++++---------------
 4 files changed, 70 insertions(+), 74 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 21d99f6..9d82d09 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -42,8 +42,6 @@
 #define OCRDMA_ROCE_DEV_VERSION "1.0.0"
 #define OCRDMA_NODE_DESC "Emulex OneConnect RoCE HCA"
 
-#define ocrdma_err(format, arg...) printk(KERN_ERR format, ##arg)
-
 #define OCRDMA_MAX_AH 512
 
 #define OCRDMA_UVERBS(CMD_NAME) (1ull << IB_USER_VERBS_CMD_##CMD_NAME)
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index f671d5d..76c9e19 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -731,7 +731,7 @@ static void ocrdma_dispatch_ibevent(struct ocrdma_dev *dev,
 		qp_event = 0;
 		srq_event = 0;
 		dev_event = 0;
-		ocrdma_err("%s() unknown type=0x%x\n", __func__, type);
+		pr_err("%s() unknown type=0x%x\n", __func__, type);
 		break;
 	}
 
@@ -761,8 +761,8 @@ static void ocrdma_process_acqe(struct ocrdma_dev *dev, void *ae_cqe)
 	if (evt_code == OCRDMA_ASYNC_EVE_CODE)
 		ocrdma_dispatch_ibevent(dev, cqe);
 	else
-		ocrdma_err("%s(%d) invalid evt code=0x%x\n",
-			   __func__, dev->id, evt_code);
+		pr_err("%s(%d) invalid evt code=0x%x\n", __func__,
+		       dev->id, evt_code);
 }
 
 static void ocrdma_process_mcqe(struct ocrdma_dev *dev, struct ocrdma_mcqe *cqe)
@@ -776,8 +776,8 @@ static void ocrdma_process_mcqe(struct ocrdma_dev *dev, struct ocrdma_mcqe *cqe)
 		dev->mqe_ctx.cmd_done = true;
 		wake_up(&dev->mqe_ctx.cmd_wait);
 	} else
-		ocrdma_err("%s() cqe for invalid tag0x%x.expected=0x%x\n",
-			   __func__, cqe->tag_lo, dev->mqe_ctx.tag);
+		pr_err("%s() cqe for invalid tag0x%x.expected=0x%x\n",
+		       __func__, cqe->tag_lo, dev->mqe_ctx.tag);
 }
 
 static int ocrdma_mq_cq_handler(struct ocrdma_dev *dev, u16 cq_id)
@@ -796,7 +796,7 @@ static int ocrdma_mq_cq_handler(struct ocrdma_dev *dev, u16 cq_id)
 		else if (cqe->valid_ae_cmpl_cons & OCRDMA_MCQE_CMPL_MASK)
 			ocrdma_process_mcqe(dev, cqe);
 		else
-			ocrdma_err("%s() cqe->compl is not set.\n", __func__);
+			pr_err("%s() cqe->compl is not set.\n", __func__);
 		memset(cqe, 0, sizeof(struct ocrdma_mcqe));
 		ocrdma_mcq_inc_tail(dev);
 	}
@@ -855,7 +855,7 @@ static void ocrdma_qp_cq_handler(struct ocrdma_dev *dev, u16 cq_idx)
 
 	cq = dev->cq_tbl[cq_idx];
 	if (cq == NULL) {
-		ocrdma_err("%s%d invalid id=0x%x\n", __func__, dev->id, cq_idx);
+		pr_err("%s%d invalid id=0x%x\n", __func__, dev->id, cq_idx);
 		return;
 	}
 	spin_lock_irqsave(&cq->cq_lock, flags);
@@ -957,7 +957,7 @@ static int ocrdma_mbx_cmd(struct ocrdma_dev *dev, struct ocrdma_mqe *mqe)
 	rsp = ocrdma_get_mqe_rsp(dev);
 	ocrdma_copy_le32_to_cpu(mqe, rsp, (sizeof(*mqe)));
 	if (cqe_status || ext_status) {
-		ocrdma_err
+		pr_err
 		    ("%s() opcode=0x%x, cqe_status=0x%x, ext_status=0x%x\n",
 		     __func__,
 		     (rsp->u.rsp.subsys_op & OCRDMA_MBX_RSP_OPCODE_MASK) >>
@@ -1339,8 +1339,8 @@ int ocrdma_mbx_create_cq(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
 	if (dpp_cq)
 		return -EINVAL;
 	if (entries > dev->attr.max_cqe) {
-		ocrdma_err("%s(%d) max_cqe=0x%x, requester_cqe=0x%x\n",
-			   __func__, dev->id, dev->attr.max_cqe, entries);
+		pr_err("%s(%d) max_cqe=0x%x, requester_cqe=0x%x\n",
+		       __func__, dev->id, dev->attr.max_cqe, entries);
 		return -EINVAL;
 	}
 	if (dpp_cq && (dev->nic_info.dev_family != OCRDMA_GEN2_FAMILY))
@@ -1607,7 +1607,7 @@ int ocrdma_reg_mr(struct ocrdma_dev *dev,
 	status = ocrdma_mbx_reg_mr(dev, hwmr, pdid,
 				   cur_pbl_cnt, hwmr->pbe_size, last);
 	if (status) {
-		ocrdma_err("%s() status=%d\n", __func__, status);
+		pr_err("%s() status=%d\n", __func__, status);
 		return status;
 	}
 	/* if there is no more pbls to register then exit. */
@@ -1630,7 +1630,7 @@ int ocrdma_reg_mr(struct ocrdma_dev *dev,
 			break;
 	}
 	if (status)
-		ocrdma_err("%s() err. status=%d\n", __func__, status);
+		pr_err("%s() err. status=%d\n", __func__, status);
 
 	return status;
 }
@@ -1827,8 +1827,8 @@ static int ocrdma_set_create_qp_sq_cmd(struct ocrdma_create_qp_req *cmd,
 	status = ocrdma_build_q_conf(&max_wqe_allocated,
 		dev->attr.wqe_size, &hw_pages, &hw_page_size);
 	if (status) {
-		ocrdma_err("%s() req. max_send_wr=0x%x\n", __func__,
-			   max_wqe_allocated);
+		pr_err("%s() req. max_send_wr=0x%x\n", __func__,
+		       max_wqe_allocated);
 		return -EINVAL;
 	}
 	qp->sq.max_cnt = max_wqe_allocated;
@@ -1877,8 +1877,8 @@ static int ocrdma_set_create_qp_rq_cmd(struct ocrdma_create_qp_req *cmd,
 	status = ocrdma_build_q_conf(&max_rqe_allocated, dev->attr.rqe_size,
 				     &hw_pages, &hw_page_size);
 	if (status) {
-		ocrdma_err("%s() req. max_recv_wr=0x%x\n", __func__,
-			   attrs->cap.max_recv_wr + 1);
+		pr_err("%s() req. max_recv_wr=0x%x\n", __func__,
+		       attrs->cap.max_recv_wr + 1);
 		return status;
 	}
 	qp->rq.max_cnt = max_rqe_allocated;
@@ -2073,10 +2073,10 @@ mbx_err:
 	if (qp->rq.va)
 		dma_free_coherent(&pdev->dev, qp->rq.len, qp->rq.va, qp->rq.pa);
 rq_err:
-	ocrdma_err("%s(%d) rq_err\n", __func__, dev->id);
+	pr_err("%s(%d) rq_err\n", __func__, dev->id);
 	dma_free_coherent(&pdev->dev, qp->sq.len, qp->sq.va, qp->sq.pa);
 sq_err:
-	ocrdma_err("%s(%d) sq_err\n", __func__, dev->id);
+	pr_err("%s(%d) sq_err\n", __func__, dev->id);
 	kfree(cmd);
 	return status;
 }
@@ -2113,7 +2113,7 @@ int ocrdma_resolve_dgid(struct ocrdma_dev *dev, union ib_gid *dgid,
 	else if (rdma_link_local_addr(&in6))
 		rdma_get_ll_mac(&in6, mac_addr);
 	else {
-		ocrdma_err("%s() fail to resolve mac_addr.\n", __func__);
+		pr_err("%s() fail to resolve mac_addr.\n", __func__);
 		return -EINVAL;
 	}
 	return 0;
@@ -2348,8 +2348,8 @@ int ocrdma_mbx_create_srq(struct ocrdma_srq *srq,
 				dev->attr.rqe_size,
 				&hw_pages, &hw_page_size);
 	if (status) {
-		ocrdma_err("%s() req. max_wr=0x%x\n", __func__,
-			   srq_attr->attr.max_wr);
+		pr_err("%s() req. max_wr=0x%x\n", __func__,
+		       srq_attr->attr.max_wr);
 		status = -EINVAL;
 		goto ret;
 	}
@@ -2600,7 +2600,7 @@ mq_err:
 	ocrdma_destroy_qp_eqs(dev);
 qpeq_err:
 	ocrdma_destroy_eq(dev, &dev->meq);
-	ocrdma_err("%s() status=%d\n", __func__, status);
+	pr_err("%s() status=%d\n", __func__, status);
 	return status;
 }
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 48928c8..ded416f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -378,7 +378,7 @@ static int ocrdma_alloc_resources(struct ocrdma_dev *dev)
 	spin_lock_init(&dev->flush_q_lock);
 	return 0;
 alloc_err:
-	ocrdma_err("%s(%d) error.\n", __func__, dev->id);
+	pr_err("%s(%d) error.\n", __func__, dev->id);
 	return -ENOMEM;
 }
 
@@ -396,7 +396,7 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 
 	dev = (struct ocrdma_dev *)ib_alloc_device(sizeof(struct ocrdma_dev));
 	if (!dev) {
-		ocrdma_err("Unable to allocate ib device\n");
+		pr_err("Unable to allocate ib device\n");
 		return NULL;
 	}
 	dev->mbx_cmd = kzalloc(sizeof(struct ocrdma_mqe_emb_cmd), GFP_KERNEL);
@@ -437,7 +437,7 @@ init_err:
 idr_err:
 	kfree(dev->mbx_cmd);
 	ib_dealloc_device(&dev->ibdev);
-	ocrdma_err("%s() leaving. ret=%d\n", __func__, status);
+	pr_err("%s() leaving. ret=%d\n", __func__, status);
 	return NULL;
 }
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 38c145b..882a819 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -114,8 +114,8 @@ int ocrdma_query_port(struct ib_device *ibdev,
 
 	dev = get_ocrdma_dev(ibdev);
 	if (port > 1) {
-		ocrdma_err("%s(%d) invalid_port=0x%x\n", __func__,
-			   dev->id, port);
+		pr_err("%s(%d) invalid_port=0x%x\n", __func__,
+		       dev->id, port);
 		return -EINVAL;
 	}
 	netdev = dev->nic_info.netdev;
@@ -155,8 +155,7 @@ int ocrdma_modify_port(struct ib_device *ibdev, u8 port, int mask,
 
 	dev = get_ocrdma_dev(ibdev);
 	if (port > 1) {
-		ocrdma_err("%s(%d) invalid_port=0x%x\n", __func__,
-			   dev->id, port);
+		pr_err("%s(%d) invalid_port=0x%x\n", __func__, dev->id, port);
 		return -EINVAL;
 	}
 	return 0;
@@ -442,8 +441,8 @@ static struct ocrdma_mr *ocrdma_alloc_lkey(struct ib_pd *ibpd,
 	struct ocrdma_dev *dev = pd->dev;
 
 	if (acc & IB_ACCESS_REMOTE_WRITE && !(acc & IB_ACCESS_LOCAL_WRITE)) {
-		ocrdma_err("%s(%d) leaving err, invalid access rights\n",
-			   __func__, dev->id);
+		pr_err("%s(%d) leaving err, invalid access rights\n",
+		       __func__, dev->id);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -703,8 +702,8 @@ static int ocrdma_copy_cq_uresp(struct ocrdma_cq *cq, struct ib_udata *udata,
 	uresp.phase_change = cq->phase_change ? 1 : 0;
 	status = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
 	if (status) {
-		ocrdma_err("%s(%d) copy error cqid=0x%x.\n",
-			   __func__, cq->dev->id, cq->id);
+		pr_err("%s(%d) copy error cqid=0x%x.\n",
+		       __func__, cq->dev->id, cq->id);
 		goto err;
 	}
 	uctx = get_ocrdma_ucontext(ib_ctx);
@@ -822,57 +821,56 @@ static int ocrdma_check_qp_params(struct ib_pd *ibpd, struct ocrdma_dev *dev,
 	if (attrs->qp_type != IB_QPT_GSI &&
 	    attrs->qp_type != IB_QPT_RC &&
 	    attrs->qp_type != IB_QPT_UD) {
-		ocrdma_err("%s(%d) unsupported qp type=0x%x requested\n",
-			   __func__, dev->id, attrs->qp_type);
+		pr_err("%s(%d) unsupported qp type=0x%x requested\n",
+		       __func__, dev->id, attrs->qp_type);
 		return -EINVAL;
 	}
 	if (attrs->cap.max_send_wr > dev->attr.max_wqe) {
-		ocrdma_err("%s(%d) unsupported send_wr=0x%x requested\n",
-			   __func__, dev->id, attrs->cap.max_send_wr);
-		ocrdma_err("%s(%d) supported send_wr=0x%x\n",
-			   __func__, dev->id, dev->attr.max_wqe);
+		pr_err("%s(%d) unsupported send_wr=0x%x requested\n",
+		       __func__, dev->id, attrs->cap.max_send_wr);
+		pr_err("%s(%d) supported send_wr=0x%x\n",
+		       __func__, dev->id, dev->attr.max_wqe);
 		return -EINVAL;
 	}
 	if (!attrs->srq && (attrs->cap.max_recv_wr > dev->attr.max_rqe)) {
-		ocrdma_err("%s(%d) unsupported recv_wr=0x%x requested\n",
-			   __func__, dev->id, attrs->cap.max_recv_wr);
-		ocrdma_err("%s(%d) supported recv_wr=0x%x\n",
-			   __func__, dev->id, dev->attr.max_rqe);
+		pr_err("%s(%d) unsupported recv_wr=0x%x requested\n",
+		       __func__, dev->id, attrs->cap.max_recv_wr);
+		pr_err("%s(%d) supported recv_wr=0x%x\n",
+		       __func__, dev->id, dev->attr.max_rqe);
 		return -EINVAL;
 	}
 	if (attrs->cap.max_inline_data > dev->attr.max_inline_data) {
-		ocrdma_err("%s(%d) unsupported inline data size=0x%x"
-			   " requested\n", __func__, dev->id,
-			   attrs->cap.max_inline_data);
-		ocrdma_err("%s(%d) supported inline data size=0x%x\n",
-			   __func__, dev->id, dev->attr.max_inline_data);
+		pr_err("%s(%d) unsupported inline data size=0x%x requested\n",
+		       __func__, dev->id, attrs->cap.max_inline_data);
+		pr_err("%s(%d) supported inline data size=0x%x\n",
+		       __func__, dev->id, dev->attr.max_inline_data);
 		return -EINVAL;
 	}
 	if (attrs->cap.max_send_sge > dev->attr.max_send_sge) {
-		ocrdma_err("%s(%d) unsupported send_sge=0x%x requested\n",
-			   __func__, dev->id, attrs->cap.max_send_sge);
-		ocrdma_err("%s(%d) supported send_sge=0x%x\n",
-			   __func__, dev->id, dev->attr.max_send_sge);
+		pr_err("%s(%d) unsupported send_sge=0x%x requested\n",
+		       __func__, dev->id, attrs->cap.max_send_sge);
+		pr_err("%s(%d) supported send_sge=0x%x\n",
+		       __func__, dev->id, dev->attr.max_send_sge);
 		return -EINVAL;
 	}
 	if (attrs->cap.max_recv_sge > dev->attr.max_recv_sge) {
-		ocrdma_err("%s(%d) unsupported recv_sge=0x%x requested\n",
-			   __func__, dev->id, attrs->cap.max_recv_sge);
-		ocrdma_err("%s(%d) supported recv_sge=0x%x\n",
-			   __func__, dev->id, dev->attr.max_recv_sge);
+		pr_err("%s(%d) unsupported recv_sge=0x%x requested\n",
+		       __func__, dev->id, attrs->cap.max_recv_sge);
+		pr_err("%s(%d) supported recv_sge=0x%x\n",
+		       __func__, dev->id, dev->attr.max_recv_sge);
 		return -EINVAL;
 	}
 	/* unprivileged user space cannot create special QP */
 	if (ibpd->uobject && attrs->qp_type == IB_QPT_GSI) {
-		ocrdma_err
+		pr_err
 		    ("%s(%d) Userspace can't create special QPs of type=0x%x\n",
 		     __func__, dev->id, attrs->qp_type);
 		return -EINVAL;
 	}
 	/* allow creating only one GSI type of QP */
 	if (attrs->qp_type == IB_QPT_GSI && dev->gsi_qp_created) {
-		ocrdma_err("%s(%d) GSI special QPs already created.\n",
-			   __func__, dev->id);
+		pr_err("%s(%d) GSI special QPs already created.\n",
+		       __func__, dev->id);
 		return -EINVAL;
 	}
 	/* verify consumer QPs are not trying to use GSI QP's CQ */
@@ -881,8 +879,8 @@ static int ocrdma_check_qp_params(struct ib_pd *ibpd, struct ocrdma_dev *dev,
 		    (dev->gsi_sqcq == get_ocrdma_cq(attrs->recv_cq)) ||
 		    (dev->gsi_rqcq == get_ocrdma_cq(attrs->send_cq)) ||
 		    (dev->gsi_rqcq == get_ocrdma_cq(attrs->recv_cq))) {
-			ocrdma_err("%s(%d) Consumer QP cannot use GSI CQs.\n",
-				   __func__, dev->id);
+			pr_err("%s(%d) Consumer QP cannot use GSI CQs.\n",
+			       __func__, dev->id);
 			return -EINVAL;
 		}
 	}
@@ -934,7 +932,7 @@ static int ocrdma_copy_qp_uresp(struct ocrdma_qp *qp,
 	}
 	status = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
 	if (status) {
-		ocrdma_err("%s(%d) user copy error.\n", __func__, dev->id);
+		pr_err("%s(%d) user copy error.\n", __func__, dev->id);
 		goto err;
 	}
 	status = ocrdma_add_mmap(pd->uctx, uresp.sq_page_addr[0],
@@ -1088,7 +1086,7 @@ mbx_err:
 	kfree(qp->wqe_wr_id_tbl);
 	kfree(qp->rqe_wr_id_tbl);
 	kfree(qp);
-	ocrdma_err("%s(%d) error=%d\n", __func__, dev->id, status);
+	pr_err("%s(%d) error=%d\n", __func__, dev->id, status);
 gen_err:
 	return ERR_PTR(status);
 }
@@ -1138,10 +1136,10 @@ int ocrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	spin_unlock_irqrestore(&qp->q_lock, flags);
 
 	if (!ib_modify_qp_is_ok(old_qps, new_qps, ibqp->qp_type, attr_mask)) {
-		ocrdma_err("%s(%d) invalid attribute mask=0x%x specified for "
-			   "qpn=0x%x of type=0x%x old_qps=0x%x, new_qps=0x%x\n",
-			   __func__, dev->id, attr_mask, qp->id, ibqp->qp_type,
-			   old_qps, new_qps);
+		pr_err("%s(%d) invalid attribute mask=0x%x specified for\n"
+		       "qpn=0x%x of type=0x%x old_qps=0x%x, new_qps=0x%x\n",
+		       __func__, dev->id, attr_mask, qp->id, ibqp->qp_type,
+		       old_qps, new_qps);
 		goto param_err;
 	}
 
@@ -1640,9 +1638,9 @@ static int ocrdma_build_inline_sges(struct ocrdma_qp *qp,
 {
 	if (wr->send_flags & IB_SEND_INLINE) {
 		if (wr->sg_list[0].length > qp->max_inline_data) {
-			ocrdma_err("%s() supported_len=0x%x,"
-				" unspported len req=0x%x\n", __func__,
-				qp->max_inline_data, wr->sg_list[0].length);
+			pr_err("%s() supported_len=0x%x,\n"
+			       " unspported len req=0x%x\n", __func__,
+			       qp->max_inline_data, wr->sg_list[0].length);
 			return -EINVAL;
 		}
 		memcpy(sge,
@@ -2057,8 +2055,8 @@ static void ocrdma_update_wc(struct ocrdma_qp *qp, struct ib_wc *ibwc,
 		break;
 	default:
 		ibwc->status = IB_WC_GENERAL_ERR;
-		ocrdma_err("%s() invalid opcode received = 0x%x\n",
-			   __func__, hdr->cw & OCRDMA_WQE_OPCODE_MASK);
+		pr_err("%s() invalid opcode received = 0x%x\n",
+		       __func__, hdr->cw & OCRDMA_WQE_OPCODE_MASK);
 		break;
 	};
 }
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
