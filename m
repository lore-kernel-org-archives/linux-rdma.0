From: Gal Pressman <galpress@amazon.com>
Subject: Re: [RFC v1 12/19] RDMA/irdma: Implement device supported verb APIs
Date: Sun, 24 Feb 2019 16:35:02 +0200
Message-ID: <01b0d571-81d8-ed6c-77b7-e83ee0ab9caa@amazon.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-13-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190215171107.6464-13-shiraz.saleem@intel.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>, dledford@redhat.com, jgg@ziepe.ca, davem@davemloft.net
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com, Yossi Leybovich <sleybo@amazon.com>
List-Id: linux-rdma@vger.kernel.org

On 15-Feb-19 19:10, Shiraz Saleem wrote:
> /**
>  * irdma_dealloc_ucontext - deallocate the user context data structure
>  * @context: user context created during alloc
>  */
> static int irdma_dealloc_ucontext(struct ib_ucontext *context)
> {
> 	struct irdma_ucontext *ucontext = to_ucontext(context);
> 	unsigned long flags;
> 
> 	spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
> 	if (!list_empty(&ucontext->cq_reg_mem_list)) {
> 		spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
> 		return -EBUSY;
> 	}
> 	spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
> 
> 	spin_lock_irqsave(&ucontext->qp_reg_mem_list_lock, flags);
> 	if (!list_empty(&ucontext->qp_reg_mem_list)) {
> 		spin_unlock_irqrestore(&ucontext->qp_reg_mem_list_lock, flags);
> 		return -EBUSY;

Drivers are not permitted to fail dealloc_ucontext.

> 	}
> 	spin_unlock_irqrestore(&ucontext->qp_reg_mem_list_lock, flags);
> 	kfree(ucontext);
> 
> 	return 0;
> }

> +/**> + * irdma_disassociate_ucontext - Disassociate user context> + * @context: ib user context> + */> +static void irdma_disassociate_ucontext(struct ib_ucontext *context)
> +{
> +}

What's the motivation for a nop callback (over not implementing the
function)?

> +/**
> + * irdma_alloc_pd - allocate protection domain
> + * @pd: PD pointer
> + * @context: user context created during alloc
> + * @udata: user data
> + */
> +static int irdma_alloc_pd(struct ib_pd *pd,
> +			  struct ib_ucontext *context,
> +			  struct ib_udata *udata)
> +{
> +	struct irdma_pd *iwpd = to_iwpd(pd);
> +	struct irdma_device *iwdev = to_iwdev(pd->device);
> +	struct irdma_sc_dev *dev = &iwdev->rf->sc_dev;
> +	struct irdma_pci_f *rf = iwdev->rf;
> +	struct irdma_alloc_pd_resp uresp = {};
> +	struct irdma_sc_pd *sc_pd;
> +	struct irdma_ucontext *ucontext;
> +	u32 pd_id = 0;
> +	int err;
> +
> +	if (iwdev->closing)
> +		return -ENODEV;
> +
> +	err = irdma_alloc_rsrc(rf, rf->allocated_pds, rf->max_pd, &pd_id,
> +			       &rf->next_pd);
> +	if (err)
> +		return err;
> +
> +	sc_pd = &iwpd->sc_pd;
> +	if (context) {

I think this should be 'if (udata)', this applies to many other places in this driver.

> +		ucontext = to_ucontext(context);
> +		dev->iw_pd_ops->pd_init(dev, sc_pd, pd_id, ucontext->abi_ver);
> +		uresp.pd_id = pd_id;
> +		if (ib_copy_to_udata(udata, &uresp, sizeof(uresp))) {
> +			err = -EFAULT;
> +			goto error;
> +		}
> +	} else {
> +		dev->iw_pd_ops->pd_init(dev, sc_pd, pd_id, -1);
> +	}
> +
> +	irdma_add_pdusecount(iwpd);
> +
> +	return 0;
> +error:
> +	irdma_free_rsrc(rf, rf->allocated_pds, pd_id);
> +
> +	return err;
> +}
> +/**
> + * irdma_create_qp - create qp
> + * @ibpd: ptr of pd
> + * @init_attr: attributes for qp
> + * @udata: user data for create qp
> + */
> +static struct ib_qp *irdma_create_qp(struct ib_pd *ibpd,
> +				     struct ib_qp_init_attr *init_attr,
> +				     struct ib_udata *udata)
> +{
> +	struct irdma_pd *iwpd = to_iwpd(ibpd);
> +	struct irdma_device *iwdev = to_iwdev(ibpd->device);
> +	struct irdma_pci_f *rf = iwdev->rf;
> +	struct irdma_cqp *iwcqp = &rf->cqp;
> +	struct irdma_qp *iwqp;
> +	struct irdma_ucontext *ucontext;
> +	struct irdma_create_qp_req req;
> +	struct irdma_create_qp_resp uresp = {};
> +	struct i40iw_create_qp_resp uresp_gen1 = {};
> +	u32 qp_num = 0;
> +	void *mem;
> +	enum irdma_status_code ret;
> +	int err_code = 0;
> +	int sq_size;
> +	int rq_size;
> +	struct irdma_sc_qp *qp;
> +	struct irdma_sc_dev *dev = &rf->sc_dev;
> +	struct irdma_qp_init_info init_info = {};
> +	struct irdma_create_qp_info *qp_info;
> +	struct irdma_cqp_request *cqp_request;
> +	struct cqp_cmds_info *cqp_info;
> +	struct irdma_qp_host_ctx_info *ctx_info;
> +	struct irdma_iwarp_offload_info *iwarp_info;
> +	struct irdma_roce_offload_info *roce_info;
> +	struct irdma_udp_offload_info *udp_info;
> +	unsigned long flags;
> +
> +	if (iwdev->closing)
> +		return ERR_PTR(-ENODEV);
> +
> +	if (init_attr->create_flags)
> +		return ERR_PTR(-EINVAL);
> +
> +	if (init_attr->cap.max_inline_data > dev->hw_attrs.max_hw_inline)
> +		init_attr->cap.max_inline_data = dev->hw_attrs.max_hw_inline;
> +
> +	if (init_attr->cap.max_send_sge > dev->hw_attrs.max_hw_wq_frags)
> +		init_attr->cap.max_send_sge = dev->hw_attrs.max_hw_wq_frags;
> +
> +	if (init_attr->cap.max_recv_sge > dev->hw_attrs.max_hw_wq_frags)
> +		init_attr->cap.max_recv_sge = dev->hw_attrs.max_hw_wq_frags;

AFAIK, you can change the requested values to be greater than or equal to
the values requested. I don't think you can change them to something smaller.

> +
> +	sq_size = init_attr->cap.max_send_wr;
> +	rq_size = init_attr->cap.max_recv_wr;
> +
> +	init_info.vsi = &iwdev->vsi;
> +	init_info.qp_uk_init_info.hw_attrs = &dev->hw_attrs;
> +	init_info.qp_uk_init_info.sq_size = sq_size;
> +	init_info.qp_uk_init_info.rq_size = rq_size;
> +	init_info.qp_uk_init_info.max_sq_frag_cnt = init_attr->cap.max_send_sge;
> +	init_info.qp_uk_init_info.max_rq_frag_cnt = init_attr->cap.max_recv_sge;
> +	init_info.qp_uk_init_info.max_inline_data = init_attr->cap.max_inline_data;
> +
> +	mem = kzalloc(sizeof(*iwqp), GFP_KERNEL);
> +	if (!mem)
> +		return ERR_PTR(-ENOMEM);
> +
> +	iwqp = (struct irdma_qp *)mem;
> +	iwqp->allocated_buf = mem;

'allocated_buf' feels redundant. Why is iwqp not sufficient?

> +	qp = &iwqp->sc_qp;
> +	qp->back_qp = (void *)iwqp;
> +	qp->push_idx = IRDMA_INVALID_PUSH_PAGE_INDEX;
> +
> +	if (irdma_allocate_dma_mem(dev->hw,
> +				   &iwqp->q2_ctx_mem,
> +				   IRDMA_Q2_BUF_SIZE + IRDMA_QP_CTX_SIZE,
> +				   256)) {
> +		err_code = -ENOMEM;
> +		goto error;
> +	}
> +
> +	init_info.q2 = iwqp->q2_ctx_mem.va;
> +	init_info.q2_pa = iwqp->q2_ctx_mem.pa;
> +	init_info.host_ctx = (void *)init_info.q2 + IRDMA_Q2_BUF_SIZE;
> +	init_info.host_ctx_pa = init_info.q2_pa + IRDMA_Q2_BUF_SIZE;
> +
> +	if (init_attr->qp_type == IB_QPT_GSI && rf->sc_dev.is_pf)
> +		qp_num = 1;
> +	else
> +		err_code = irdma_alloc_rsrc(rf, rf->allocated_qps, rf->max_qp,
> +					    &qp_num, &rf->next_qp);
> +	if (err_code)
> +		goto error;
> +
> +	iwqp->iwdev = iwdev;
> +	iwqp->iwpd = iwpd;
> +	if (init_attr->qp_type == IB_QPT_GSI && !rf->sc_dev.is_pf)
> +		iwqp->ibqp.qp_num = 1;
> +	else
> +		iwqp->ibqp.qp_num = qp_num;
> +
> +	qp = &iwqp->sc_qp;
> +	iwqp->iwscq = to_iwcq(init_attr->send_cq);
> +	iwqp->iwrcq = to_iwcq(init_attr->recv_cq);
> +	iwqp->host_ctx.va = init_info.host_ctx;
> +	iwqp->host_ctx.pa = init_info.host_ctx_pa;
> +	iwqp->host_ctx.size = IRDMA_QP_CTX_SIZE;
> +
> +	init_info.pd = &iwpd->sc_pd;
> +	init_info.qp_uk_init_info.qp_id = iwqp->ibqp.qp_num;
> +	if (!rdma_protocol_roce(&iwdev->iwibdev->ibdev, 1))
> +		init_info.qp_uk_init_info.first_sq_wq = 1;
> +	iwqp->ctx_info.qp_compl_ctx = (uintptr_t)qp;
> +	init_waitqueue_head(&iwqp->waitq);
> +	init_waitqueue_head(&iwqp->mod_qp_waitq);
> +
> +	if (rdma_protocol_roce(&iwdev->iwibdev->ibdev, 1)) {
> +		if (init_attr->qp_type != IB_QPT_RC &&
> +		    init_attr->qp_type != IB_QPT_UD &&
> +		    init_attr->qp_type != IB_QPT_GSI) {
> +			err_code = -EINVAL;
> +			goto error;
> +		}
> +	} else {
> +		if (init_attr->qp_type != IB_QPT_RC) {
> +			err_code = -EINVAL;
> +			goto error;
> +		}
> +	}
> +
> +	if (iwdev->push_mode)
> +		irdma_alloc_push_page(rf, qp);
> +
> +	if (udata) {
> +		err_code = ib_copy_from_udata(&req, udata, sizeof(req));

Perhaps ib_copy_from_udata(&req, udata, min(sizeof(req), udata->inlen)?
Applies to other call sites of ib_copy_from/to_udata as well.

> +		if (err_code) {
> +			irdma_debug(dev, IRDMA_DEBUG_ERR,
> +				    "ib_copy_from_data fail\n");
> +			goto error;
> +		}
> +
> +		iwqp->ctx_info.qp_compl_ctx = req.user_compl_ctx;
> +		iwqp->user_mode = 1;
> +		ucontext = to_ucontext(ibpd->uobject->context);
> +		if (req.user_wqe_bufs) {
> +			spin_lock_irqsave(&ucontext->qp_reg_mem_list_lock, flags);
> +			iwqp->iwpbl = irdma_get_pbl((unsigned long)req.user_wqe_bufs,
> +						    &ucontext->qp_reg_mem_list);
> +			spin_unlock_irqrestore(&ucontext->qp_reg_mem_list_lock, flags);
> +
> +			if (!iwqp->iwpbl) {
> +				err_code = -ENODATA;
> +				irdma_debug(dev, IRDMA_DEBUG_ERR,
> +					    "no pbl info\n");
> +				goto error;
> +			}
> +		}
> +		err_code = irdma_setup_virt_qp(iwdev, iwqp, &init_info);
> +	} else {
> +		err_code = irdma_setup_kmode_qp(iwdev, iwqp, &init_info);
> +	}
> +
> +	if (err_code) {
> +		irdma_debug(dev, IRDMA_DEBUG_ERR, "setup qp failed\n");
> +		goto error;
> +	}
> +
> +	if (rdma_protocol_roce(&iwdev->iwibdev->ibdev, 1)) {
> +		if (init_attr->qp_type == IB_QPT_RC) {
> +			init_info.type = IRDMA_QP_TYPE_ROCE_RC;
> +			init_info.qp_uk_init_info.qp_caps =
> +				IRDMA_SEND_WITH_IMM | IRDMA_WRITE_WITH_IMM | IRDMA_ROCE;
> +		} else {
> +			init_info.type = IRDMA_QP_TYPE_ROCE_UD;
> +			init_info.qp_uk_init_info.qp_caps = IRDMA_SEND_WITH_IMM | IRDMA_ROCE;
> +		}
> +	} else {
> +		init_info.type = IRDMA_QP_TYPE_IWARP;
> +		init_info.qp_uk_init_info.qp_caps = IRDMA_WRITE_WITH_IMM;
> +	}
> +
> +	ret = dev->iw_priv_qp_ops->qp_init(qp, &init_info);
> +	if (ret) {
> +		err_code = -EPROTO;
> +		irdma_debug(dev, IRDMA_DEBUG_ERR, "qp_init fail\n");
> +		goto error;
> +	}
> +
> +	ctx_info = &iwqp->ctx_info;
> +	if (rdma_protocol_roce(&iwdev->iwibdev->ibdev, 1)) {
> +		iwqp->ctx_info.roce_info = &iwqp->roce_info;
> +		iwqp->ctx_info.udp_info = &iwqp->udp_info;
> +		udp_info = &iwqp->udp_info;
> +		udp_info->snd_mss = irdma_roce_mtu(iwdev->vsi.mtu);
> +		udp_info->cwnd = 0x400;
> +		udp_info->src_port = 0xc000;
> +		udp_info->dst_port = ROCE_V2_UDP_DPORT;
> +		roce_info = &iwqp->roce_info;
> +		ether_addr_copy(roce_info->mac_addr, iwdev->netdev->dev_addr);
> +
> +		if (init_attr->qp_type == IB_QPT_GSI && !rf->sc_dev.is_pf)
> +			roce_info->is_qp1 = true;
> +		roce_info->rd_en = true;
> +		roce_info->wr_rdresp_en = true;
> +		roce_info->dctcp_en = iwdev->dctcp_en;
> +		roce_info->ecn_en = iwdev->ecn_en;
> +		roce_info->dcqcn_en = iwdev->roce_dcqcn_en;
> +		roce_info->timely_en = iwdev->roce_timely_en;
> +
> +		roce_info->ack_credits = 0x1E;
> +		roce_info->ird_size = IRDMA_MAX_ENCODED_IRD_SIZE;
> +		roce_info->ord_size = dev->hw_attrs.max_hw_ord;
> +
> +		if (!iwqp->user_mode) {
> +			roce_info->priv_mode_en = true;
> +			roce_info->fast_reg_en = true;
> +			roce_info->udprivcq_en = true;
> +		}
> +		roce_info->roce_tver = 0;
> +	} else {
> +		iwqp->ctx_info.iwarp_info = &iwqp->iwarp_info;
> +		iwarp_info = &iwqp->iwarp_info;
> +		ether_addr_copy(iwarp_info->mac_addr, iwdev->netdev->dev_addr);
> +		iwarp_info->rd_en = true;
> +		iwarp_info->wr_rdresp_en = true;
> +		iwarp_info->ib_rd_en = true;
> +		if (!iwqp->user_mode) {
> +			iwarp_info->priv_mode_en = true;
> +			iwarp_info->fast_reg_en = true;
> +		}
> +		iwarp_info->ddp_ver = 1;
> +		iwarp_info->rdmap_ver = 1;
> +		ctx_info->iwarp_info_valid = true;
> +	}
> +
> +	ctx_info->send_cq_num = iwqp->iwscq->sc_cq.cq_uk.cq_id;
> +	ctx_info->rcv_cq_num = iwqp->iwrcq->sc_cq.cq_uk.cq_id;
> +	if (qp->push_idx == IRDMA_INVALID_PUSH_PAGE_INDEX) {
> +		ctx_info->push_mode_en = false;
> +	} else {
> +		ctx_info->push_mode_en = true;
> +		ctx_info->push_idx = qp->push_idx;
> +	}
> +
> +	if (rdma_protocol_roce(&iwdev->iwibdev->ibdev, 1)) {
> +		ret =
> +		    dev->iw_priv_qp_ops->qp_setctx_roce(&iwqp->sc_qp,
> +							iwqp->host_ctx.va,
> +							ctx_info);
> +	} else {
> +		ret = dev->iw_priv_qp_ops->qp_setctx(&iwqp->sc_qp,
> +						     iwqp->host_ctx.va,
> +						     ctx_info);
> +		ctx_info->iwarp_info_valid = false;
> +	}
> +
> +	cqp_request = irdma_get_cqp_request(iwcqp, true);
> +	if (!cqp_request) {
> +		err_code = -ENOMEM;
> +		goto error;
> +	}
> +
> +	cqp_info = &cqp_request->info;
> +	qp_info = &cqp_request->info.in.u.qp_create.info;
> +	memset(qp_info, 0, sizeof(*qp_info));
> +	qp_info->mac_valid = true;
> +	qp_info->cq_num_valid = true;
> +	qp_info->next_iwarp_state = IRDMA_QP_STATE_IDLE;
> +
> +	cqp_info->cqp_cmd = IRDMA_OP_QP_CREATE;
> +	cqp_info->post_sq = 1;
> +	cqp_info->in.u.qp_create.qp = qp;
> +	cqp_info->in.u.qp_create.scratch = (uintptr_t)cqp_request;
> +	ret = irdma_handle_cqp_op(rf, cqp_request);
> +	if (ret) {
> +		irdma_debug(dev, IRDMA_DEBUG_ERR, "CQP-OP QP create fail");
> +		err_code = -ENOMEM;
> +		goto error;
> +	}
> +
> +	irdma_add_ref(&iwqp->ibqp);
> +	spin_lock_init(&iwqp->lock);
> +	spin_lock_init(&iwqp->sc_qp.pfpdu.lock);
> +	iwqp->sig_all = (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR) ? 1 : 0;
> +	rf->qp_table[qp_num] = iwqp;
> +	irdma_add_pdusecount(iwqp->iwpd);
> +	irdma_add_devusecount(iwdev);
> +	if (udata) {
> +		if (iwdev->rf->sc_dev.hw_attrs.hw_rev == IRDMA_GEN_1) {
> +			uresp_gen1.lsmm = 1;
> +			uresp_gen1.actual_sq_size = sq_size;
> +			uresp_gen1.actual_rq_size = rq_size;
> +			uresp_gen1.qp_id = qp_num;
> +			uresp_gen1.push_idx = qp->push_idx;
> +			uresp_gen1.lsmm = 1;
> +			err_code = ib_copy_to_udata(udata, &uresp_gen1, sizeof(uresp_gen1));
> +		} else {
> +			if (rdma_protocol_iwarp(&iwdev->iwibdev->ibdev, 1))
> +				uresp.lsmm = 1;
> +			uresp.actual_sq_size = sq_size;
> +			uresp.actual_rq_size = rq_size;
> +			uresp.qp_id = qp_num;
> +			uresp.push_idx = qp->push_idx;
> +			uresp.qp_caps = qp->qp_uk.qp_caps;
> +
> +			err_code = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
> +		}
> +		if (err_code) {
> +			irdma_debug(dev, IRDMA_DEBUG_ERR, "copy_to_udata failed\n");
> +			irdma_destroy_qp(&iwqp->ibqp);
> +			return ERR_PTR(err_code);
> +		}
> +	}
> +	init_completion(&iwqp->sq_drained);
> +	init_completion(&iwqp->rq_drained);
> +	return &iwqp->ibqp;
> +
> +error:
> +	irdma_free_qp_rsrc(iwdev, iwqp, qp_num);
> +
> +	return ERR_PTR(err_code);
> +}
> +
> +/**
> + * irdma_query - query qp attributes
> + * @ibqp: qp pointer
> + * @attr: attributes pointer
> + * @attr_mask: Not used
> + * @init_attr: qp attributes to return
> + */
> +static int irdma_query_qp(struct ib_qp *ibqp,
> +			  struct ib_qp_attr *attr,
> +			  int attr_mask,
> +			  struct ib_qp_init_attr *init_attr)
> +{
> +	struct irdma_qp *iwqp = to_iwqp(ibqp);
> +	struct irdma_sc_qp *qp = &iwqp->sc_qp;
> +
> +	attr->qp_state = iwqp->ibqp_state;
> +	attr->cur_qp_state = iwqp->ibqp_state;
> +	attr->qp_access_flags = 0;
> +	attr->cap.max_send_wr = qp->qp_uk.sq_size - 1;
> +	attr->cap.max_recv_wr = qp->qp_uk.rq_size - 1;

Why -1?

> +	attr->cap.max_inline_data = qp->qp_uk.max_inline_data;
> +	attr->cap.max_send_sge = qp->qp_uk.max_sq_frag_cnt;
> +	attr->cap.max_recv_sge = qp->qp_uk.max_rq_frag_cnt;
> +	attr->qkey = iwqp->roce_info.qkey;
> +
> +	init_attr->event_handler = iwqp->ibqp.event_handler;
> +	init_attr->qp_context = iwqp->ibqp.qp_context;
> +	init_attr->send_cq = iwqp->ibqp.send_cq;
> +	init_attr->recv_cq = iwqp->ibqp.recv_cq;
> +	init_attr->srq = iwqp->ibqp.srq;
> +	init_attr->cap = attr->cap;
> +
> +	return 0;
> +}
> +
> +/**
> + * irdma_destroy_cq - destroy cq
> + * @ib_cq: cq pointer
> + */
> +static int irdma_destroy_cq(struct ib_cq *ib_cq)
> +{
> +	struct irdma_cq *iwcq;
> +	struct irdma_device *iwdev;
> +	struct irdma_sc_cq *cq;
> +
> +	if (!ib_cq) {
> +		irdma_pr_err("ib_cq == NULL\n");
> +		return 0;
> +	}

Is this really needed? Which caller can pass NULL pointer?

> +
> +	iwcq = to_iwcq(ib_cq);
> +	iwdev = to_iwdev(ib_cq->device);
> +	cq = &iwcq->sc_cq;
> +	irdma_cq_wq_destroy(iwdev->rf, cq);
> +	cq_free_rsrc(iwdev->rf, iwcq);
> +	kfree(iwcq);
> +	irdma_rem_devusecount(iwdev);
> +
> +	return 0;
> +}
> +> +/**
> + * irdma_create_stag - create random stag
> + * @iwdev: iwarp device
> + */
> +static u32 irdma_create_stag(struct irdma_device *iwdev)
> +{
> +	u32 stag = 0;
> +	u32 stag_index = 0;
> +	u32 next_stag_index;
> +	u32 driver_key;
> +	u32 random;
> +	u8 consumer_key;
> +	int ret;
> +
> +	get_random_bytes(&random, sizeof(random));
> +	consumer_key = (u8)random;
> +
> +	driver_key = random & ~iwdev->rf->mr_stagmask;
> +	next_stag_index = (random & iwdev->rf->mr_stagmask) >> 8;
> +	next_stag_index %= iwdev->rf->max_mr;
> +
> +	ret = irdma_alloc_rsrc(iwdev->rf,
> +			       iwdev->rf->allocated_mrs, iwdev->rf->max_mr,
> +			       &stag_index, &next_stag_index);
> +	if (!ret) {
> +		stag = stag_index << IRDMA_CQPSQ_STAG_IDX_S;
> +		stag |= driver_key;
> +		stag += (u32)consumer_key;
> +		irdma_add_devusecount(iwdev);
> +	}

This is confusing IMHO, better to test for 'if (ret)' and keep the main flow
unindented.

> +	return stag;
> +}
> +
> +/**
> + * board_id_show
> + */
> +static ssize_t board_id_show(struct device *dev,
> +			     struct device_attribute *attr,
> +			     char *buf)
> +{
> +	return sprintf(buf, "%.*s\n", 32, "IRDMA Board ID");

That doesn't add much information.

> +}
> +
> +static DEVICE_ATTR_RO(hw_rev);
> +static DEVICE_ATTR_RO(hca_type);
> +static DEVICE_ATTR_RO(board_id);
> +
> +static struct attribute *irdma_dev_attributes[] = {
> +	&dev_attr_hw_rev.attr,
> +	&dev_attr_hca_type.attr,
> +	&dev_attr_board_id.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group irdma_attr_group = {
> +	.attrs = irdma_dev_attributes,
> +};
> +
> +/**
> + * irdma_modify_port  Modify port properties
> + * @ibdev: device pointer from stack
> + * @port: port number
> + * @port_modify_mask: mask for port modifications
> + * @props: port properties
> + */
> +static int irdma_modify_port(struct ib_device *ibdev,
> +			     u8 port,
> +			     int port_modify_mask,
> +			     struct ib_port_modify *props)
> +{
> +	return 0;
> +}

Same question as disacossiate_ucontext.

> +
> +/**
> + * irdma_query_gid_roce - Query port GID for Roce
> + * @ibdev: device pointer from stack
> + * @port: port number
> + * @index: Entry index
> + * @gid: Global ID
> + */
> +static int irdma_query_gid_roce(struct ib_device *ibdev,
> +				u8 port,
> +				int index,
> +				union ib_gid *gid)
> +{
> +	int ret;
> +
> +	ret = rdma_query_gid(ibdev, port, index, gid);
> +	if (ret == -EAGAIN) {

I can't see a path where rdma_query_gid returns -EAGAIN.

> +		memcpy(gid, &zgid, sizeof(*gid));
> +		return 0;
> +	}
> +
> +	return ret;
> +}
> +

> +/**
> + * irdma_create_ah - create address handle
> + * @ibpd: ptr to protection domain
> + * @ah_attr: address handle attributes

'ah_attr' -> 'attr', missing flags and udata.

> + *
> + * returns a pointer to an address handle
> + */
> +static struct ib_ah *irdma_create_ah(struct ib_pd *ibpd,
> +				     struct rdma_ah_attr *attr,
> +				     u32 flags,
> +				     struct ib_udata *udata)
> +{
> +	struct irdma_pd *pd = to_iwpd(ibpd);
> +	struct irdma_ah *ah;
> +	const struct ib_gid_attr *sgid_attr;
> +	struct irdma_device *iwdev = to_iwdev(ibpd->device);
> +	struct irdma_pci_f *rf = iwdev->rf;
> +	struct irdma_sc_ah *sc_ah;
> +	u32 ah_id = 0;
> +	struct irdma_ah_info *ah_info;
> +	struct irdma_create_ah_resp uresp;
> +	union {
> +		struct sockaddr	saddr;
> +		struct sockaddr_in saddr_in;
> +		struct sockaddr_in6 saddr_in6;
> +	} sgid_addr, dgid_addr;
> +	int err;
> +	u8 dmac[ETH_ALEN];
> +
> +	err = irdma_alloc_rsrc(rf, rf->allocated_ahs,
> +			       rf->max_ah, &ah_id, &rf->next_ah);
> +	if (err)
> +		return ERR_PTR(err);
> +
> +	ah = kzalloc(sizeof(*ah), GFP_ATOMIC);
> +	if (!ah) {
> +		irdma_free_rsrc(rf, rf->allocated_ahs, ah_id);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	ah->pd = pd;
> +	sc_ah = &ah->sc_ah;
> +	sc_ah->ah_info.ah_idx = ah_id;
> +	sc_ah->ah_info.vsi = &iwdev->vsi;
> +	iwdev->rf->sc_dev.iw_uda_ops->init_ah(&rf->sc_dev, sc_ah);
> +	ah->sgid_index = attr->grh.sgid_index;
> +	sgid_attr = attr->grh.sgid_attr;
> +	memcpy(&ah->dgid, &attr->grh.dgid, sizeof(ah->dgid));
> +	rdma_gid2ip(&sgid_addr.saddr, &sgid_attr->gid);
> +	rdma_gid2ip(&dgid_addr.saddr, &attr->grh.dgid);
> +	ah->av.attrs = *attr;
> +	ah->av.net_type = rdma_gid_attr_network_type(sgid_attr);
> +	ah->av.sgid_addr.saddr = sgid_addr.saddr;
> +	ah->av.dgid_addr.saddr = dgid_addr.saddr;
> +	ah_info = &sc_ah->ah_info;
> +	ah_info->ah = sc_ah;
> +	ah_info->ah_idx = ah_id;
> +	ah_info->pd_idx = pd->sc_pd.pd_id;
> +	ether_addr_copy(ah_info->mac_addr, iwdev->netdev->dev_addr);
> +	if (attr->ah_flags & IB_AH_GRH) {
> +		ah_info->flow_label = attr->grh.flow_label;
> +		ah_info->hop_ttl = attr->grh.hop_limit;
> +		ah_info->tc_tos = attr->grh.traffic_class;
> +	}
> +
> +	ether_addr_copy(dmac, attr->roce.dmac);
> +	if (rdma_gid_attr_network_type(sgid_attr) == RDMA_NETWORK_IPV4) {
> +		ah_info->ipv4_valid = true;
> +		ah_info->dest_ip_addr[0] =
> +				ntohl(dgid_addr.saddr_in.sin_addr.s_addr);
> +		ah_info->src_ip_addr[0] =
> +				ntohl(sgid_addr.saddr_in.sin_addr.s_addr);
> +		ah_info->do_lpbk = irdma_ipv4_is_lpb(ah_info->src_ip_addr[0],
> +						     ah_info->dest_ip_addr[0]);
> +		if (ipv4_is_multicast(dgid_addr.saddr_in.sin_addr.s_addr))
> +			irdma_mcast_mac(ah_info->dest_ip_addr, dmac, true);
> +	} else {
> +		irdma_copy_ip_ntohl(ah_info->dest_ip_addr,
> +				    dgid_addr.saddr_in6.sin6_addr.in6_u.u6_addr32);
> +		irdma_copy_ip_ntohl(ah_info->src_ip_addr,
> +				    sgid_addr.saddr_in6.sin6_addr.in6_u.u6_addr32);
> +		ah_info->do_lpbk = irdma_ipv6_is_lpb(ah_info->src_ip_addr,
> +						     ah_info->dest_ip_addr);
> +		if (rdma_is_multicast_addr(&dgid_addr.saddr_in6.sin6_addr))
> +			irdma_mcast_mac(ah_info->dest_ip_addr, dmac, false);
> +	}
> +	if (sgid_attr->ndev && is_vlan_dev(sgid_attr->ndev))
> +		ah_info->vlan_tag = vlan_dev_vlan_id(sgid_attr->ndev);
> +	else
> +		ah_info->vlan_tag = IRDMA_NO_VLAN;
> +
> +	ah_info->dst_arpindex = irdma_add_arp(iwdev->rf, ah_info->dest_ip_addr,
> +					      ah_info->ipv4_valid, dmac);
> +
> +	if (ah_info->dst_arpindex == -1) {
> +		err = -EINVAL;
> +		goto error;
> +	}
> +
> +	if (ah_info->vlan_tag != 0xFFFF)
> +		ah_info->insert_vlan_tag = true;
> +
> +	err = irdma_ah_cqp_op(iwdev->rf, sc_ah, IRDMA_OP_AH_CREATE,
> +			      flags & RDMA_CREATE_AH_SLEEPABLE,
> +			      irdma_gsi_ud_qp_ah_cb, sc_ah);
> +	if (err) {
> +		irdma_debug(&rf->sc_dev, IRDMA_DEBUG_ERR,
> +			    "CQP-OP Create AH fail");
> +		goto error;
> +	}
> +
> +	if (!(flags & RDMA_CREATE_AH_SLEEPABLE)) {
> +		int cnt = CQP_COMPL_WAIT_TIME_MS * CQP_TIMEOUT_THRESHOLD;
> +
> +		do {
> +			irdma_cqp_ce_handler(rf, &rf->ccq.sc_cq);
> +			mdelay(1);
> +		} while (!sc_ah->ah_info.ah_valid && --cnt);
> +
> +		if (!cnt) {
> +			irdma_debug(&rf->sc_dev, IRDMA_DEBUG_ERR,
> +				    "CQP create AH timed out");
> +			err = -ETIMEDOUT;
> +			goto error;
> +		}
> +	}
> +
> +	irdma_add_pdusecount(pd);
> +	if (udata) {
> +		uresp.ah_id = ah->sc_ah.ah_info.ah_idx;
> +		err = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
> +	}
> +	return &ah->ibah;
> +
> +error:
> +	kfree(ah);
> +	irdma_free_rsrc(iwdev->rf, iwdev->rf->allocated_ahs, ah_id);
> +
> +	return ERR_PTR(err);
> +}
> +
> +/**
> + * irdma_destroy_ah - Destroy address handle
> + * @ah: pointer to address handle

Missing flags.

> + */
> +static int irdma_destroy_ah(struct ib_ah *ibah, u32 flags)
> +{
> +	struct irdma_device *iwdev = to_iwdev(ibah->device);
> +	struct irdma_ah *ah = to_iwah(ibah);
> +	int err;
> +
> +	if (!ah->sc_ah.ah_info.ah_valid)
> +		return -EINVAL;
> +
> +	err = irdma_ah_cqp_op(iwdev->rf, &ah->sc_ah, IRDMA_OP_AH_DESTROY,
> +			      flags & RDMA_DESTROY_AH_SLEEPABLE,
> +			      irdma_destroy_ah_cb, ah);
> +	if (!err)
> +		return 0;

Why are the rest of the cleanups only in case of error?

> +
> +	irdma_free_rsrc(iwdev->rf, iwdev->rf->allocated_ahs,
> +			ah->sc_ah.ah_info.ah_idx);
> +	irdma_rem_pdusecount(ah->pd, iwdev);
> +	kfree(ah);
> +
> +	return 0;
> +}
> +

> +static __be64 irdma_mac_to_guid(struct net_device *ndev)
> +{
> +	unsigned char *mac = ndev->dev_addr;
> +	__be64 guid;
> +	unsigned char *dst = (unsigned char *)&guid;
> +
> +	dst[0] = mac[0] ^ 2;
> +	dst[1] = mac[1];
> +	dst[2] = mac[2];
> +	dst[3] = 0xff;
> +	dst[4] = 0xfe;
> +	dst[5] = mac[3];
> +	dst[6] = mac[4];
> +	dst[7] = mac[5];
> +
> +	return guid;
> +}

There's a variant of this function in irdma, bnxt_re, ocrdma and qedr.
Maybe it's time to provide it in common code?
