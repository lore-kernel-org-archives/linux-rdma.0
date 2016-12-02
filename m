From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 12/16] IB/pvrdma: Add Queue Pair support
Date: Fri, 2 Dec 2016 12:35:43 +0200
Message-ID: <20161202103542.GA3663@yuval-lap>
References: <cover.1475458407.git.aditr@vmware.com>
 <6a643e92376856394d45638d80a90619d3abac37.1475458407.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6a643e92376856394d45638d80a90619d3abac37.1475458407.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 02, 2016 at 07:10:32PM -0700, Adit Ranadive wrote:
+
> +/**
> + * pvrdma_create_qp - create queue pair
> + * @pd: protection domain
> + * @init_attr: queue pair attributes
> + * @udata: user data
> + *
> + * @return: the ib_qp pointer on success, otherwise returns an errno.
> + */
> +struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
> +			       struct ib_qp_init_attr *init_attr,
> +			       struct ib_udata *udata)
> +{
> +	struct pvrdma_qp *qp = NULL;
> +	struct pvrdma_dev *dev = to_vdev(pd->device);
> +	union pvrdma_cmd_req req;
> +	union pvrdma_cmd_resp rsp;
> +	struct pvrdma_cmd_create_qp *cmd = &req.create_qp;
> +	struct pvrdma_cmd_create_qp_resp *resp = &rsp.create_qp_resp;
> +	struct pvrdma_create_qp ucmd;
> +	unsigned long flags;
> +	int ret;
> +
> +	if (init_attr->create_flags) {
> +		dev_warn(&dev->pdev->dev,
> +			 "invalid create queuepair flags %#x\n",
> +			 init_attr->create_flags);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	if (init_attr->qp_type != IB_QPT_RC &&
> +	    init_attr->qp_type != IB_QPT_UD &&
> +	    init_attr->qp_type != IB_QPT_GSI) {
> +		dev_warn(&dev->pdev->dev, "queuepair type %d not supported\n",
> +			 init_attr->qp_type);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	if (!atomic_add_unless(&dev->num_qps, 1, dev->dsr->caps.max_qp))
> +		return ERR_PTR(-ENOMEM);
> +
> +	switch (init_attr->qp_type) {
> +	case IB_QPT_GSI:
> +		if (init_attr->port_num == 0 ||
> +		    init_attr->port_num > pd->device->phys_port_cnt ||
> +		    udata) {
> +			dev_warn(&dev->pdev->dev, "invalid queuepair attrs\n");
> +			ret = -EINVAL;
> +			goto err_qp;
> +		}
> +		/* fall through */
> +	case IB_QPT_RC:
> +	case IB_QPT_UD:
> +		qp = kzalloc(sizeof(*qp), GFP_KERNEL);
> +		if (!qp) {
> +			ret = -ENOMEM;
> +			goto err_qp;
> +		}
> +
> +		spin_lock_init(&qp->sq.lock);
> +		spin_lock_init(&qp->rq.lock);
> +		mutex_init(&qp->mutex);
> +		atomic_set(&qp->refcnt, 1);
> +		init_waitqueue_head(&qp->wait);
> +
> +		qp->state = IB_QPS_RESET;
> +
> +		if (pd->uobject && udata) {
> +			dev_dbg(&dev->pdev->dev,
> +				"create queuepair from user space\n");
> +
> +			if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
> +				ret = -EFAULT;
> +				goto err_qp;
> +			}
> +
> +			/* set qp->sq.wqe_cnt, shift, buf_size.. */
> +			qp->rumem = ib_umem_get(pd->uobject->context,
> +						ucmd.rbuf_addr,
> +						ucmd.rbuf_size, 0, 0);
> +			if (IS_ERR(qp->rumem)) {
> +				ret = PTR_ERR(qp->rumem);
> +				goto err_qp;
> +			}
> +
> +			qp->sumem = ib_umem_get(pd->uobject->context,
> +						ucmd.sbuf_addr,
> +						ucmd.sbuf_size, 0, 0);
> +			if (IS_ERR(qp->sumem)) {
> +				ib_umem_release(qp->rumem);
> +				ret = PTR_ERR(qp->sumem);
> +				goto err_qp;
> +			}
> +
> +			qp->npages_send = ib_umem_page_count(qp->sumem);
> +			qp->npages_recv = ib_umem_page_count(qp->rumem);
> +			qp->npages = qp->npages_send + qp->npages_recv;
> +		} else {
> +			qp->is_kernel = true;
> +
> +			ret = pvrdma_set_sq_size(to_vdev(pd->device),
> +						 &init_attr->cap,
> +						 init_attr->qp_type, qp);
> +			if (ret)
> +				goto err_qp;
> +
> +			ret = pvrdma_set_rq_size(to_vdev(pd->device),
> +						 &init_attr->cap, qp);
> +			if (ret)
> +				goto err_qp;
> +
> +			qp->npages = qp->npages_send + qp->npages_recv;
> +
> +			/* Skip header page. */
> +			qp->sq.offset = PAGE_SIZE;
> +
> +			/* Recv queue pages are after send pages. */
> +			qp->rq.offset = qp->npages_send * PAGE_SIZE;
> +		}
> +
> +		if (qp->npages < 0 || qp->npages > PVRDMA_PAGE_DIR_MAX_PAGES) {
> +			dev_warn(&dev->pdev->dev,
> +				 "overflow pages in queuepair\n");
> +			ret = -EINVAL;
> +			goto err_umem;
> +		}
> +
> +		ret = pvrdma_page_dir_init(dev, &qp->pdir, qp->npages,
> +					   qp->is_kernel);
> +		if (ret) {
> +			dev_warn(&dev->pdev->dev,
> +				 "could not allocate page directory\n");
> +			goto err_umem;
> +		}
> +
> +		if (!qp->is_kernel) {
> +			pvrdma_page_dir_insert_umem(&qp->pdir, qp->sumem, 0);
> +			pvrdma_page_dir_insert_umem(&qp->pdir, qp->rumem,
> +						    qp->npages_send);
> +		} else {
> +			/* Ring state is always the first page. */
> +			qp->sq.ring = qp->pdir.pages[0];
> +			qp->rq.ring = &qp->sq.ring[1];
> +		}
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		goto err_qp;
> +	}
> +
> +	/* Not supported */
> +	init_attr->cap.max_inline_data = 0;
> +
> +	memset(cmd, 0, sizeof(*cmd));
> +	cmd->hdr.cmd = PVRDMA_CMD_CREATE_QP;
> +	cmd->pd_handle = to_vpd(pd)->pd_handle;
> +	cmd->send_cq_handle = to_vcq(init_attr->send_cq)->cq_handle;
> +	cmd->recv_cq_handle = to_vcq(init_attr->recv_cq)->cq_handle;
> +	cmd->max_send_wr = init_attr->cap.max_send_wr;
> +	cmd->max_recv_wr = init_attr->cap.max_recv_wr;
> +	cmd->max_send_sge = init_attr->cap.max_send_sge;
> +	cmd->max_recv_sge = init_attr->cap.max_recv_sge;
> +	cmd->max_inline_data = init_attr->cap.max_inline_data;
> +	cmd->sq_sig_all = (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR) ? 1 : 0;
> +	cmd->qp_type = ib_qp_type_to_pvrdma(init_attr->qp_type);
> +	cmd->access_flags = IB_ACCESS_LOCAL_WRITE;
> +	cmd->total_chunks = qp->npages;
> +	cmd->send_chunks = qp->npages_send - 1;
> +	cmd->pdir_dma = qp->pdir.dir_dma;
> +
> +	dev_dbg(&dev->pdev->dev, "create queuepair with %d, %d, %d, %d\n",
> +		cmd->max_send_wr, cmd->max_recv_wr, cmd->max_send_sge,
> +		cmd->max_recv_sge);
> +
> +	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_CREATE_QP_RESP);

Warning: rsp is not in use so either use NULL or actually check response.

> +	if (ret < 0) {
> +		dev_warn(&dev->pdev->dev,
> +			 "could not create queuepair, error: %d\n", ret);
> +		goto err_pdir;
> +	}
> +
> +	/* max_send_wr/_recv_wr/_send_sge/_recv_sge/_inline_data */
> +	qp->qp_handle = resp->qpn;
> +	qp->port = init_attr->port_num;
> +	qp->ibqp.qp_num = resp->qpn;
> +	spin_lock_irqsave(&dev->qp_tbl_lock, flags);
> +	dev->qp_tbl[qp->qp_handle % dev->dsr->caps.max_qp] = qp;
> +	spin_unlock_irqrestore(&dev->qp_tbl_lock, flags);
> +
> +	return &qp->ibqp;
> +
> +err_pdir:
> +	pvrdma_page_dir_cleanup(dev, &qp->pdir);
> +err_umem:
> +	if (pd->uobject && udata) {
> +		if (qp->rumem)
> +			ib_umem_release(qp->rumem);
> +		if (qp->sumem)
> +			ib_umem_release(qp->sumem);
> +	}
> +err_qp:
> +	kfree(qp);
> +	atomic_dec(&dev->num_qps);
> +
> +	return ERR_PTR(ret);
> +}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
