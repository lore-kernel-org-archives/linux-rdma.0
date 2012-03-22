From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 4/9] ocrdma: Driver for Emulex OneConnect RDMA adapter
Date: Thu, 22 Mar 2012 00:19:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237345197AC0@ORSMSX101.amr.corp.intel.com>
References: <1332283154-16369-1-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-2-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-3-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-4-git-send-email-parav.pandit@emulex.com>
 <a5e59a7c-d6ff-4c78-89a7-fad7492260b0@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a5e59a7c-d6ff-4c78-89a7-fad7492260b0-nbYkmrCdWxmgMrCBcu8zE0EOCMrvLtNR@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org" <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +static inline void *ocrdma_get_eqe(struct ocrdma_eq *eq)
> +{
> +	return (u8 *)eq->q.va + (eq->q.tail * sizeof(struct ocrdma_eqe));
> +}

casts from (void *) to (u8 *) are not needed.  This occurs in multiple places.

> +enum ib_qp_state get_ibqp_state(enum ocrdma_qp_state qps)
> +{
> +	switch (qps) {
> +	case OCRDMA_QPS_RST:
> +		return IB_QPS_RESET;
> +	case OCRDMA_QPS_INIT:
> +		return IB_QPS_INIT;
> +	case OCRDMA_QPS_RTR:
> +		return IB_QPS_RTR;
> +	case OCRDMA_QPS_RTS:
> +		return IB_QPS_RTS;
> +	case OCRDMA_QPS_SQD:
> +	case OCRDMA_QPS_SQ_DRAINING:
> +		return IB_QPS_SQD;
> +	case OCRDMA_QPS_SQE:
> +		return IB_QPS_SQE;
> +	case OCRDMA_QPS_ERR:
> +		return IB_QPS_ERR;
> +	};
> +	return IB_QPS_ERR;
> +}
> +
> +enum ocrdma_qp_state get_ocrdma_qp_state(enum ib_qp_state qps)
> +{
> +	switch (qps) {
> +	case IB_QPS_RESET:
> +		return OCRDMA_QPS_RST;
> +	case IB_QPS_INIT:
> +		return OCRDMA_QPS_INIT;
> +	case IB_QPS_RTR:
> +		return OCRDMA_QPS_RTR;
> +	case IB_QPS_RTS:
> +		return OCRDMA_QPS_RTS;
> +	case IB_QPS_SQD:
> +		return OCRDMA_QPS_SQD;
> +	case IB_QPS_SQE:
> +		return OCRDMA_QPS_SQE;
> +	case IB_QPS_ERR:
> +		return OCRDMA_QPS_ERR;
> +	};
> +	return OCRDMA_QPS_ERR;
> +}
> +
> +static int ocrdma_get_mbx_errno(u32 status)
> +{
> +	int err_num = -EFAULT;

no need to initialize, since it's set in all cases

> +	u8 mbox_status = (status & OCRDMA_MBX_RSP_STATUS_MASK) >>
> +					OCRDMA_MBX_RSP_STATUS_SHIFT;
> +	u8 add_status = (status & OCRDMA_MBX_RSP_ASTATUS_MASK) >>
> +					OCRDMA_MBX_RSP_ASTATUS_SHIFT;
> +
> +	switch (mbox_status) {
> +	case OCRDMA_MBX_STATUS_OOR:
> +	case OCRDMA_MBX_STATUS_MAX_QP_EXCEEDS:
> +		err_num = -EAGAIN;
> +		break;
> +
> +	case OCRDMA_MBX_STATUS_INVALID_PD:
> +	case OCRDMA_MBX_STATUS_INVALID_CQ:
> +	case OCRDMA_MBX_STATUS_INVALID_SRQ_ID:
> +	case OCRDMA_MBX_STATUS_INVALID_QP:
> +	case OCRDMA_MBX_STATUS_INVALID_CHANGE:
> +	case OCRDMA_MBX_STATUS_MTU_EXCEEDS:
> +	case OCRDMA_MBX_STATUS_INVALID_RNR_NAK_TIMER:
> +	case OCRDMA_MBX_STATUS_PKEY_INDEX_INVALID:
> +	case OCRDMA_MBX_STATUS_PKEY_INDEX_EXCEEDS:
> +	case OCRDMA_MBX_STATUS_ILLEGAL_FIELD:
> +	case OCRDMA_MBX_STATUS_INVALID_PBL_ENTRY:
> +	case OCRDMA_MBX_STATUS_INVALID_LKEY:
> +	case OCRDMA_MBX_STATUS_INVALID_VA:
> +	case OCRDMA_MBX_STATUS_INVALID_LENGTH:
> +	case OCRDMA_MBX_STATUS_INVALID_FBO:
> +	case OCRDMA_MBX_STATUS_INVALID_ACC_RIGHTS:
> +	case OCRDMA_MBX_STATUS_INVALID_PBE_SIZE:
> +	case OCRDMA_MBX_STATUS_ATOMIC_OPS_UNSUP:
> +	case OCRDMA_MBX_STATUS_SRQ_ERROR:
> +	case OCRDMA_MBX_STATUS_SRQ_SIZE_UNDERUNS:
> +		err_num = -EINVAL;
> +		break;
> +
> +	case OCRDMA_MBX_STATUS_PD_INUSE:
> +	case OCRDMA_MBX_STATUS_QP_BOUND:
> +	case OCRDMA_MBX_STATUS_MW_STILL_BOUND:
> +	case OCRDMA_MBX_STATUS_MW_BOUND:
> +		err_num = -EBUSY;
> +		break;
> +
> +	case OCRDMA_MBX_STATUS_RECVQ_RQE_EXCEEDS:
> +	case OCRDMA_MBX_STATUS_SGE_RECV_EXCEEDS:
> +	case OCRDMA_MBX_STATUS_RQE_EXCEEDS:
> +	case OCRDMA_MBX_STATUS_SRQ_LIMIT_EXCEEDS:
> +	case OCRDMA_MBX_STATUS_ORD_EXCEEDS:
> +	case OCRDMA_MBX_STATUS_IRD_EXCEEDS:
> +	case OCRDMA_MBX_STATUS_SENDQ_WQE_EXCEEDS:
> +	case OCRDMA_MBX_STATUS_SGE_SEND_EXCEEDS:
> +	case OCRDMA_MBX_STATUS_SGE_WRITE_EXCEEDS:
> +		err_num = -ENOBUFS;
> +		break;
> +
> +	case OCRDMA_MBX_STATUS_FAILED:
> +		switch (add_status) {
> +		case OCRDMA_MBX_ADDI_STATUS_INSUFFICIENT_RESOURCES:
> +			err_num = -EAGAIN;
> +			break;
> +		}
> +	default:
> +		err_num = -EFAULT;
> +	}
> +	return err_num;
> +}
> +
> +static int ocrdma_get_mbx_cqe_errno(u16 cqe_status)
> +{
> +	int err_num = -EINVAL;

no need to initialize

> +	switch (cqe_status) {
> +	case OCRDMA_MBX_CQE_STATUS_INSUFFICIENT_PRIVILEDGES:
> +		err_num = -EPERM;
> +		break;
> +	case OCRDMA_MBX_CQE_STATUS_INVALID_PARAMETER:
> +		err_num = -EINVAL;
> +		break;
> +	case OCRDMA_MBX_CQE_STATUS_INSUFFICIENT_RESOURCES:
> +	case OCRDMA_MBX_CQE_STATUS_QUEUE_FLUSHING:
> +		err_num = -EAGAIN;
> +		break;
> +	case OCRDMA_MBX_CQE_STATUS_DMA_FAILED:
> +		err_num = -EIO;
> +		break;
> +	}
> +	return err_num;
> +}

> +static int ocrdma_mbx_create_eq(struct ocrdma_dev *dev, struct ocrdma_eq *eq)
> +{
> +	int status;
> +	struct ocrdma_create_eq_req *cmd = dev->mbx_cmd;
> +	struct ocrdma_create_eq_rsp *rsp = dev->mbx_cmd;
> +
> +	memset(cmd, 0, sizeof(*cmd));
> +	ocrdma_init_mch(&cmd->req, OCRDMA_CMD_CREATE_EQ, OCRDMA_SUBSYS_COMMON,
> +			sizeof(*cmd));
> +	if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY)
> +		cmd->req.rsvd_version = 0;
> +	else
> +		cmd->req.rsvd_version = 2;
> +
> +	cmd->num_pages = 4;
> +	cmd->valid = OCRDMA_CREATE_EQ_VALID;
> +	cmd->cnt = 4 << OCRDMA_CREATE_EQ_CNT_SHIFT;
> +
> +	ocrdma_build_q_pages(&cmd->pa[0], cmd->num_pages, eq->q.dma,
> +			     PAGE_SIZE_4K);
> +	status = be_roce_mcc_cmd(dev->nic_info.netdev, cmd, sizeof(*cmd), NULL,
> +				 NULL);
> +	if (!status) {
> +		eq->q.id = rsp->vector_eqid & 0xffff;
> +		if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY)
> +			ocrdma_assign_eq_vect_gen2(dev, eq);

nit: Please use braces { } in both the if and else statements if one of the two sides needs it.  This occurs in multiple places.  (See CodingStyle documentation.)

> +		else {
> +			eq->vector = (rsp->vector_eqid >> 16) & 0xffff;
> +			dev->nic_info.msix.start_vector += 1;
> +		}
> +		eq->q.created = true;
> +	}
> +	return status;
> +}

> +static irqreturn_t ocrdma_irq_handler(int irq, void *handle)
> +{
> +	struct ocrdma_eq *eq = handle;
> +	struct ocrdma_dev *dev = eq->dev;
> +	struct ocrdma_eqe eqe;
> +	struct ocrdma_eqe *ptr;
> +	u16 eqe_popped = 0;
> +	u16 cq_id;
> +	while (1) {
> +		ptr = ocrdma_get_eqe(eq);
> +		eqe = *ptr;
> +		ocrdma_le32_to_cpu(&eqe, sizeof(eqe));
> +		if ((eqe.id_valid & OCRDMA_EQE_VALID_MASK) == 0)
> +			break;
> +		eqe_popped += 1;
> +		ptr->id_valid = 0;
> +		/* check whether its CQE or not. */
> +		if ((eqe.id_valid & OCRDMA_EQE_FOR_CQE_MASK) == 0) {
> +			cq_id = eqe.id_valid >> OCRDMA_EQE_RESOURCE_ID_SHIFT;
> +			ocrdma_cq_handler(dev, cq_id);
> +		}
> +		ocrdma_eq_inc_tail(eq);
> +	}
> +	ocrdma_ring_eq_db(dev, eq->q.id, true, true, eqe_popped);
> +	/* Ring EQ doorbell with num_popped to 0 to enable interrupts again. */
> +	if (dev->nic_info.intr_mode == BE_INTERRUPT_MODE_INTX)
> +		ocrdma_ring_eq_db(dev, eq->q.id, true, true, 0);
> +	return IRQ_HANDLED;
> +}
> +

> +int ocrdma_mbx_create_cq(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
> +			 int entries, int dpp_cq)
> +{
> +	int status = -ENOMEM; int max_hw_cqe;
> +	struct pci_dev *pdev = dev->nic_info.pdev;
> +	struct ocrdma_create_cq *cmd;
> +	struct ocrdma_create_cq_rsp *rsp;
> +	u32 hw_pages, cqe_size, page_size, cqe_count;
> +
> +	if (dpp_cq)
> +		return -EINVAL;
> +	if (entries > dev->attr.max_cqe) {
> +		ocrdma_err("%s(%d) max_cqe=0x%x, requester_cqe=0x%x\n",
> +			   __func__, dev->id, dev->attr.max_cqe, entries);
> +		return -EINVAL;
> +	}
> +	if (dpp_cq && (dev->nic_info.dev_family != OCRDMA_GEN2_FAMILY))
> +		return -EINVAL;
> +
> +	if (dpp_cq) {
> +		cq->max_hw_cqe = 1;
> +		max_hw_cqe = 1;
> +		cqe_size = OCRDMA_DPP_CQE_SIZE;
> +		hw_pages = 1;
> +	} else {
> +		cq->max_hw_cqe = dev->attr.max_cqe;
> +		max_hw_cqe = dev->attr.max_cqe;
> +		cqe_size = sizeof(struct ocrdma_cqe);
> +		hw_pages = OCRDMA_CREATE_CQ_MAX_PAGES;
> +	}
> +
> +	cq->len = roundup(max_hw_cqe * cqe_size, OCRDMA_MIN_Q_PAGE_SIZE);
> +
> +	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_CREATE_CQ, sizeof(*cmd));
> +	if (!cmd)
> +		return -ENOMEM;
> +	ocrdma_init_mch(&cmd->cmd.req, OCRDMA_CMD_CREATE_CQ,
> +			OCRDMA_SUBSYS_COMMON, sizeof(*cmd));
> +	cq->va = dma_alloc_coherent(&pdev->dev, cq->len, &cq->pa, GFP_KERNEL);
> +	if (!cq->va) {
> +		status = -ENOMEM;
> +		goto mem_err;
> +	}
> +	memset(cq->va, 0, cq->len);
> +	page_size = cq->len / hw_pages;
> +	cmd->cmd.pgsz_pgcnt = (page_size / OCRDMA_MIN_Q_PAGE_SIZE) <<
> +					OCRDMA_CREATE_CQ_PAGE_SIZE_SHIFT;
> +	cmd->cmd.pgsz_pgcnt |= hw_pages;
> +	cmd->cmd.ev_cnt_flags = OCRDMA_CREATE_CQ_DEF_FLAGS;
> +
> +	if (dev->eq_cnt < 0)
> +		goto eq_err;

Can this check be moved to the top of the function?

> +	cq->eqn = ocrdma_bind_eq(dev);
> +	cmd->cmd.req.rsvd_version = OCRDMA_CREATE_CQ_VER2;
> +	cqe_count = cq->len / cqe_size;
> +	if (cqe_count > 1024)
> +		/* Set cnt to 3 to indicate more than 1024 cq entries */
> +		cmd->cmd.ev_cnt_flags |= (0x3 << OCRDMA_CREATE_CQ_CNT_SHIFT);
> +	else {
> +		u8 count = 0;
> +		switch (cqe_count) {
> +		case 256:
> +			count = 0;
> +			break;
> +		case 512:
> +			count = 1;
> +			break;
> +		case 1024:
> +			count = 2;
> +			break;
> +		default:
> +			goto mbx_err;
> +		}
> +		cmd->cmd.ev_cnt_flags |= (count << OCRDMA_CREATE_CQ_CNT_SHIFT);
> +	}
> +	/* shared eq between all the consumer cqs. */
> +	cmd->cmd.eqn = cq->eqn;
> +	if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
> +		if (dpp_cq)
> +			cmd->cmd.pgsz_pgcnt |= OCRDMA_CREATE_CQ_DPP <<
> +				OCRDMA_CREATE_CQ_TYPE_SHIFT;
> +		cq->phase_change = false;
> +		cmd->cmd.cqe_count = (cq->len / cqe_size);
> +	} else {
> +		cmd->cmd.cqe_count = (cq->len / cqe_size) - 1;
> +		cmd->cmd.ev_cnt_flags |= OCRDMA_CREATE_CQ_FLAGS_AUTO_VALID;
> +		cq->phase_change = true;
> +	}
> +
> +	ocrdma_build_q_pages(&cmd->cmd.pa[0], hw_pages, cq->pa, page_size);
> +	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
> +	if (status)
> +		goto mbx_err;
> +
> +	rsp = (struct ocrdma_create_cq_rsp *)cmd;
> +	cq->id = (u16) (rsp->rsp.cq_id & OCRDMA_CREATE_CQ_RSP_CQ_ID_MASK);
> +	kfree(cmd);
> +	return 0;
> +mbx_err:
> +	ocrdma_unbind_eq(dev, cq->eqn);
> +eq_err:
> +	dma_free_coherent(&pdev->dev, cq->len, cq->va, cq->pa);
> +mem_err:
> +	kfree(cmd);
> +	return status;
> +}

> +bool ocrdma_is_qp_in_sq_flushlist(struct ocrdma_cq *cq, struct ocrdma_qp *qp)
> +{
> +	struct ocrdma_qp *tmp;
> +	bool found = false;
> +	list_for_each_entry(tmp, &cq->sq_head, sq_entry) {
> +		if (qp == tmp) {
> +			found = true;
> +			break;
> +		}
> +	}
> +	return found;
> +}
> +
> +bool ocrdma_is_qp_in_rq_flushlist(struct ocrdma_cq *cq, struct ocrdma_qp *qp)
> +{
> +	struct ocrdma_qp *tmp;
> +	bool found = false;
> +	list_for_each_entry(tmp, &cq->rq_head, rq_entry) {
> +		if (qp == tmp) {
> +			found = true;
> +			break;
> +		}
> +	}
> +	return found;
> +}

maybe merge the above two calls into one and pass in the list instead of the cq?

> +int ocrdma_mbx_create_qp(struct ocrdma_qp *qp, struct ib_qp_init_attr *attrs,
> +			 u8 enable_dpp_cq, u16 dpp_cq_id, u16 *dpp_offset,
> +			 u16 *dpp_credit_lmt)
> +{
> +	int status = -ENOMEM;
> +	u32 flags = 0;
> +	struct ocrdma_dev *dev = qp->dev;
> +	struct ocrdma_pd *pd = qp->pd;
> +	struct pci_dev *pdev = dev->nic_info.pdev;
> +	struct ocrdma_cq *cq;
> +	struct ocrdma_create_qp_req *cmd;
> +	struct ocrdma_create_qp_rsp *rsp;
> +	int qptype;
> +
> +	switch (attrs->qp_type) {
> +	case IB_QPT_GSI:
> +		qptype = OCRDMA_QPT_GSI;
> +		break;
> +	case IB_QPT_RC:
> +		qptype = OCRDMA_QPT_RC;
> +		break;
> +	case IB_QPT_UD:
> +		qptype = OCRDMA_QPT_UD;
> +		break;
> +	default:
> +		return -EINVAL;
> +	};

Does OneConnect not support UC?  (I thought UC was required for compliance.)

> +
> +	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_CREATE_QP, sizeof(*cmd));
> +	if (!cmd)
> +		return status;
> +	cmd->type_pgsz_pdn |= (qptype << OCRDMA_CREATE_QP_REQ_QPT_SHIFT) &
> +						OCRDMA_CREATE_QP_REQ_QPT_MASK;
> +	status = ocrdma_set_create_qp_sq_cmd(cmd, attrs, qp);
> +	if (status)
> +		goto sq_err;
> +
> +	if (attrs->srq) {
> +		struct ocrdma_srq *srq = get_ocrdma_srq(attrs->srq);
> +		cmd->max_sge_recv_flags |= OCRDMA_CREATE_QP_REQ_USE_SRQ_MASK;
> +		cmd->rq_addr[0].lo = srq->id;
> +		qp->srq = srq;
> +	} else {
> +		status = ocrdma_set_create_qp_rq_cmd(cmd, attrs, qp);
> +		if (status)
> +			goto rq_err;
> +	}
> +
> +	status = ocrdma_set_create_qp_ird_cmd(cmd, qp);
> +	if (status)
> +		goto mbx_err;
> +
> +	cmd->type_pgsz_pdn |= (pd->id << OCRDMA_CREATE_QP_REQ_PD_ID_SHIFT) &
> +				OCRDMA_CREATE_QP_REQ_PD_ID_MASK;
> +
> +	flags = ocrdma_set_create_qp_mbx_access_flags(qp);
> +
> +	cmd->max_sge_recv_flags |= flags;
> +	cmd->max_ord_ird |= (dev->attr.max_ord_per_qp <<
> +			     OCRDMA_CREATE_QP_REQ_MAX_ORD_SHIFT) &
> +				OCRDMA_CREATE_QP_REQ_MAX_ORD_MASK;
> +	cmd->max_ord_ird |= (dev->attr.max_ird_per_qp <<
> +			     OCRDMA_CREATE_QP_REQ_MAX_IRD_SHIFT) &
> +				OCRDMA_CREATE_QP_REQ_MAX_IRD_MASK;
> +	cq = get_ocrdma_cq(attrs->send_cq);
> +	cmd->wq_rq_cqid |= (cq->id << OCRDMA_CREATE_QP_REQ_WQ_CQID_SHIFT) &
> +				OCRDMA_CREATE_QP_REQ_WQ_CQID_MASK;
> +	qp->sq_cq = cq;
> +	cq = get_ocrdma_cq(attrs->recv_cq);
> +	cmd->wq_rq_cqid |= (cq->id << OCRDMA_CREATE_QP_REQ_RQ_CQID_SHIFT) &
> +				OCRDMA_CREATE_QP_REQ_RQ_CQID_MASK;
> +	qp->rq_cq = cq;
> +
> +	if (pd->dpp_enabled && attrs->cap.max_inline_data && pd->num_dpp_qp &&
> +	    (attrs->cap.max_inline_data <= dev->attr.max_inline_data))
> +		ocrdma_set_create_qp_dpp_cmd(cmd, pd, qp, enable_dpp_cq,
> +					     dpp_cq_id);
> +
> +	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
> +	if (status)
> +		goto mbx_err;
> +	rsp = (struct ocrdma_create_qp_rsp *)cmd;
> +	ocrdma_get_create_qp_rsp(rsp, qp, attrs, dpp_offset, dpp_credit_lmt);
> +	qp->state = OCRDMA_QPS_RST;
> +	kfree(cmd);
> +	return 0;
> +mbx_err:
> +	if (qp->rq.va)
> +		dma_free_coherent(&pdev->dev, qp->rq.len, qp->rq.va, qp->rq.pa);
> +rq_err:
> +	ocrdma_err("%s(%d) rq_err\n", __func__, dev->id);
> +	dma_free_coherent(&pdev->dev, qp->sq.len, qp->sq.va, qp->sq.pa);
> +sq_err:
> +	ocrdma_err("%s(%d) sq_err\n", __func__, dev->id);
> +	kfree(cmd);
> +	return status;
> +}

> +int ocrdma_mbx_modify_qp(struct ocrdma_dev *dev, struct ocrdma_qp *qp,
> +			 struct ib_qp_attr *attrs, int attr_mask,
> +			 enum ib_qp_state old_qps)
> +{
> +	int status = -ENOMEM;
> +	struct ocrdma_modify_qp *cmd;
> +	struct ocrdma_modify_qp_rsp *rsp;
> +
> +	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_MODIFY_QP, sizeof(*cmd));
> +	if (!cmd)
> +		return status;
> +
> +	cmd->params.id = qp->id;
> +	cmd->flags = 0;
> +	if (attr_mask & IB_QP_STATE) {
> +		cmd->params.max_sge_recv_flags |=
> +		    (get_ocrdma_qp_state(attrs->qp_state) <<
> +		     OCRDMA_QP_PARAMS_STATE_SHIFT) &
> +		    OCRDMA_QP_PARAMS_STATE_MASK;
> +		cmd->flags |= OCRDMA_QP_PARA_QPS_VALID;
> +	} else
> +		cmd->params.max_sge_recv_flags |=
> +		    (qp->state << OCRDMA_QP_PARAMS_STATE_SHIFT) &
> +		    OCRDMA_QP_PARAMS_STATE_MASK;
> +	status = ocrdma_set_qp_params(qp, cmd, attrs, attr_mask, old_qps);
> +	if (status)
> +		goto mbx_err;
> +	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
> +	if (status)
> +		goto mbx_err;
> +	rsp = (struct ocrdma_modify_qp_rsp *)cmd;
> +mbx_err:
> +	kfree(cmd);
> +	return status;
> +}

Am I missing something with the rsp assignment?  This occurs multiple times.

> +static int ocrdma_create_qp_eqs(struct ocrdma_dev *dev)
> +{
> +	int num_eq, i, status;
> +	int irq;
> +	unsigned long flags = 0;
> +
> +	num_eq = dev->nic_info.msix.num_vectors -
> +			dev->nic_info.msix.start_vector;
> +	if (dev->nic_info.intr_mode == BE_INTERRUPT_MODE_INTX) {
> +		num_eq = 1;
> +		flags = IRQF_SHARED;
> +	} else
> +		num_eq = min_t(u32, num_eq, num_online_cpus());
> +	dev->qp_eq_tbl = kzalloc(sizeof(struct ocrdma_eq) * num_eq, GFP_KERNEL);
> +	if (!dev->qp_eq_tbl)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < num_eq; i++) {
> +		status = ocrdma_create_eq(dev, &dev->qp_eq_tbl[i],
> +					  OCRDMA_EQ_LEN);
> +		if (status) {
> +			status = -EINVAL;
> +			break;
> +		}
> +		sprintf(dev->qp_eq_tbl[i].irq_name, "ocrdma_qp%d-%d",
> +			dev->id, i);
> +		irq = ocrdma_get_irq(dev, &dev->qp_eq_tbl[i]);
> +		status = request_irq(irq, ocrdma_irq_handler, flags,
> +				     dev->qp_eq_tbl[i].irq_name,
> +				     &dev->qp_eq_tbl[i]);
> +		if (status) {
> +			_ocrdma_destroy_eq(dev, &dev->qp_eq_tbl[i]);
> +			status = -EINVAL;
> +			break;
> +		}
> +		dev->eq_cnt += 1;
> +	}
> +	/* one eq is sufficient for data path to work */
> +	if (dev->eq_cnt >= 1)
> +		return 0;
> +	if (status)

I don't think we can reach here with status == 0.

> +		ocrdma_destroy_qp_eqs(dev);
> +	return status;
> +}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
