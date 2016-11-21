From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 12/16] IB/pvrdma: Add Queue Pair support
Date: Mon, 21 Nov 2016 17:51:42 +0200
Message-ID: <20161121155141.GA11371@yuval-lap>
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
> +
> +/**
> + * pvrdma_post_send - post send work request entries on a QP
> + * @ibqp: the QP
> + * @wr: work request list to post
> + * @bad_wr: the first bad WR returned
> + *
> + * @return: 0 on success, otherwise errno returned.
> + */
> +int pvrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
> +		     struct ib_send_wr **bad_wr)
> +{
> +	struct pvrdma_qp *qp = to_vqp(ibqp);
> +	struct pvrdma_dev *dev = to_vdev(ibqp->device);
> +	unsigned long flags;
> +	struct pvrdma_sq_wqe_hdr *wqe_hdr;
> +	struct pvrdma_sge *sge;
> +	int i, index;
> +	int nreq;
> +	int ret;
> +
> +	/*
> +	 * In states lower than RTS, we can fail immediately. In other states,
> +	 * just post and let the device figure it out.
> +	 */
> +	if (qp->state < IB_QPS_RTS) {
> +		*bad_wr = wr;
> +		return -EINVAL;
> +	}
> +
> +	spin_lock_irqsave(&qp->sq.lock, flags);
> +
> +	index = pvrdma_idx(&qp->sq.ring->prod_tail, qp->sq.wqe_cnt);
> +	for (nreq = 0; wr; nreq++, wr = wr->next) {

nreq is not in used so better remove it.

> +		unsigned int tail;
> +
> +		if (unlikely(!pvrdma_idx_ring_has_space(
> +				qp->sq.ring, qp->sq.wqe_cnt, &tail))) {
> +			dev_warn_ratelimited(&dev->pdev->dev,
> +					     "send queue is full\n");
> +			*bad_wr = wr;
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +
> +		if (unlikely(wr->num_sge > qp->sq.max_sg || wr->num_sge < 0)) {
> +			dev_warn_ratelimited(&dev->pdev->dev,
> +					     "send SGE overflow\n");
> +			*bad_wr = wr;
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		if (unlikely(wr->opcode < 0)) {
> +			dev_warn_ratelimited(&dev->pdev->dev,
> +					     "invalid send opcode\n");
> +			*bad_wr = wr;
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		/*
> +		 * Only support UD, RC.
> +		 * Need to check opcode table for thorough checking.
> +		 * opcode		_UD	_UC	_RC
> +		 * _SEND		x	x	x
> +		 * _SEND_WITH_IMM	x	x	x
> +		 * _RDMA_WRITE			x	x
> +		 * _RDMA_WRITE_WITH_IMM		x	x
> +		 * _LOCAL_INV			x	x
> +		 * _SEND_WITH_INV		x	x
> +		 * _RDMA_READ				x
> +		 * _ATOMIC_CMP_AND_SWP			x
> +		 * _ATOMIC_FETCH_AND_ADD		x
> +		 * _MASK_ATOMIC_CMP_AND_SWP		x
> +		 * _MASK_ATOMIC_FETCH_AND_ADD		x
> +		 * _REG_MR				x
> +		 *
> +		 */
> +		if (qp->ibqp.qp_type != IB_QPT_UD &&
> +		    qp->ibqp.qp_type != IB_QPT_RC &&
> +			wr->opcode != IB_WR_SEND) {
> +			dev_warn_ratelimited(&dev->pdev->dev,
> +					     "unsupported queuepair type\n");
> +			*bad_wr = wr;
> +			ret = -EINVAL;
> +			goto out;
> +		} else if (qp->ibqp.qp_type == IB_QPT_UD ||
> +			   qp->ibqp.qp_type == IB_QPT_GSI) {
> +			if (wr->opcode != IB_WR_SEND &&
> +			    wr->opcode != IB_WR_SEND_WITH_IMM) {
> +				dev_warn_ratelimited(&dev->pdev->dev,
> +						     "invalid send opcode\n");
> +				*bad_wr = wr;
> +				ret = -EINVAL;
> +				goto out;
> +			}
> +		}
> +
> +		wqe_hdr = (struct pvrdma_sq_wqe_hdr *)get_sq_wqe(qp, index);
> +		memset(wqe_hdr, 0, sizeof(*wqe_hdr));
> +		wqe_hdr->wr_id = wr->wr_id;
> +		wqe_hdr->num_sge = wr->num_sge;
> +		wqe_hdr->opcode = ib_wr_opcode_to_pvrdma(wr->opcode);
> +		wqe_hdr->send_flags = ib_send_flags_to_pvrdma(wr->send_flags);
> +		if (wr->opcode == IB_WR_SEND_WITH_IMM ||
> +		    wr->opcode == IB_WR_RDMA_WRITE_WITH_IMM)
> +			wqe_hdr->ex.imm_data = wr->ex.imm_data;
> +
> +		switch (qp->ibqp.qp_type) {
> +		case IB_QPT_GSI:
> +		case IB_QPT_UD:
> +			if (unlikely(!ud_wr(wr)->ah)) {
> +				dev_warn_ratelimited(&dev->pdev->dev,
> +						     "invalid address handle\n");
> +				*bad_wr = wr;
> +				ret = -EINVAL;
> +				goto out;
> +			}
> +
> +			/*
> +			 * Use qkey from qp context if high order bit set,
> +			 * otherwise from work request.
> +			 */
> +			wqe_hdr->wr.ud.remote_qpn = ud_wr(wr)->remote_qpn;
> +			wqe_hdr->wr.ud.remote_qkey =
> +				ud_wr(wr)->remote_qkey & 0x80000000 ?
> +				qp->qkey : ud_wr(wr)->remote_qkey;
> +			wqe_hdr->wr.ud.av = to_vah(ud_wr(wr)->ah)->av;
> +
> +			break;
> +		case IB_QPT_RC:
> +			switch (wr->opcode) {
> +			case IB_WR_RDMA_READ:
> +			case IB_WR_RDMA_WRITE:
> +			case IB_WR_RDMA_WRITE_WITH_IMM:
> +				wqe_hdr->wr.rdma.remote_addr =
> +					rdma_wr(wr)->remote_addr;
> +				wqe_hdr->wr.rdma.rkey = rdma_wr(wr)->rkey;
> +				break;
> +			case IB_WR_LOCAL_INV:
> +			case IB_WR_SEND_WITH_INV:
> +				wqe_hdr->ex.invalidate_rkey =
> +					wr->ex.invalidate_rkey;
> +				break;
> +			case IB_WR_ATOMIC_CMP_AND_SWP:
> +			case IB_WR_ATOMIC_FETCH_AND_ADD:
> +				wqe_hdr->wr.atomic.remote_addr =
> +					atomic_wr(wr)->remote_addr;
> +				wqe_hdr->wr.atomic.rkey = atomic_wr(wr)->rkey;
> +				wqe_hdr->wr.atomic.compare_add =
> +					atomic_wr(wr)->compare_add;
> +				if (wr->opcode == IB_WR_ATOMIC_CMP_AND_SWP)
> +					wqe_hdr->wr.atomic.swap =
> +						atomic_wr(wr)->swap;
> +				break;
> +			case IB_WR_REG_MR:
> +				ret = set_reg_seg(wqe_hdr, reg_wr(wr));
> +				if (ret < 0) {
> +					dev_warn_ratelimited(&dev->pdev->dev,
> +							     "Failed to set fast register work request\n");
> +					*bad_wr = wr;
> +					goto out;
> +				}
> +				break;
> +			default:
> +				break;
> +			}
> +
> +			break;
> +		default:
> +			dev_warn_ratelimited(&dev->pdev->dev,
> +					     "invalid queuepair type\n");
> +			ret = -EINVAL;
> +			*bad_wr = wr;
> +			goto out;
> +		}
> +
> +		sge = (struct pvrdma_sge *)(wqe_hdr + 1);
> +		for (i = 0; i < wr->num_sge; i++) {
> +			/* Need to check wqe_size 0 or max size */
> +			sge->addr = wr->sg_list[i].addr;
> +			sge->length = wr->sg_list[i].length;
> +			sge->lkey = wr->sg_list[i].lkey;
> +			sge++;
> +		}
> +
> +		/* Make sure wqe is written before index update */
> +		smp_wmb();
> +
> +		index++;
> +		if (unlikely(index >= qp->sq.wqe_cnt))
> +			index = 0;
> +		/* Update shared sq ring */
> +		pvrdma_idx_ring_inc(&qp->sq.ring->prod_tail,
> +				    qp->sq.wqe_cnt);
> +	}
> +
> +	ret = 0;
> +
> +out:
> +	spin_unlock_irqrestore(&qp->sq.lock, flags);
> +
> +	if (!ret)
> +		pvrdma_write_uar_qp(dev, PVRDMA_UAR_QP_SEND | qp->qp_handle);
> +
> +	return ret;
> +}
> +
> +/**
> + * pvrdma_post_receive - post receive work request entries on a QP
> + * @ibqp: the QP
> + * @wr: the work request list to post
> + * @bad_wr: the first bad WR returned
> + *
> + * @return: 0 on success, otherwise errno returned.
> + */
> +int pvrdma_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
> +		     struct ib_recv_wr **bad_wr)
> +{
> +	struct pvrdma_dev *dev = to_vdev(ibqp->device);
> +	unsigned long flags;
> +	struct pvrdma_qp *qp = to_vqp(ibqp);
> +	struct pvrdma_rq_wqe_hdr *wqe_hdr;
> +	struct pvrdma_sge *sge;
> +	int index, nreq;
> +	int ret = 0;
> +	int i;
> +
> +	/*
> +	 * In the RESET state, we can fail immediately. For other states,
> +	 * just post and let the device figure it out.
> +	 */
> +	if (qp->state == IB_QPS_RESET) {
> +		*bad_wr = wr;
> +		return -EINVAL;
> +	}
> +
> +	spin_lock_irqsave(&qp->rq.lock, flags);
> +
> +	index = pvrdma_idx(&qp->rq.ring->prod_tail, qp->rq.wqe_cnt);
> +	for (nreq = 0; wr; nreq++, wr = wr->next) {

ditto

> +		unsigned int tail;
> +
> +		if (unlikely(wr->num_sge > qp->rq.max_sg ||
> +			     wr->num_sge < 0)) {
> +			ret = -EINVAL;
> +			*bad_wr = wr;
> +			dev_warn_ratelimited(&dev->pdev->dev,
> +					     "recv SGE overflow\n");
> +			goto out;
> +		}
> +
> +		if (unlikely(!pvrdma_idx_ring_has_space(
> +				qp->rq.ring, qp->rq.wqe_cnt, &tail))) {
> +			ret = -ENOMEM;
> +			*bad_wr = wr;
> +			dev_warn_ratelimited(&dev->pdev->dev,
> +					     "recv queue full\n");
> +			goto out;
> +		}
> +
> +		wqe_hdr = (struct pvrdma_rq_wqe_hdr *)get_rq_wqe(qp, index);
> +		wqe_hdr->wr_id = wr->wr_id;
> +		wqe_hdr->num_sge = wr->num_sge;
> +		wqe_hdr->total_len = 0;
> +
> +		sge = (struct pvrdma_sge *)(wqe_hdr + 1);
> +		for (i = 0; i < wr->num_sge; i++) {
> +			sge->addr = wr->sg_list[i].addr;
> +			sge->length = wr->sg_list[i].length;
> +			sge->lkey = wr->sg_list[i].lkey;
> +			sge++;
> +		}
> +
> +		/* Make sure wqe is written before index update */
> +		smp_wmb();
> +
> +		index++;
> +		if (unlikely(index >= qp->rq.wqe_cnt))
> +			index = 0;
> +		/* Update shared rq ring */
> +		pvrdma_idx_ring_inc(&qp->rq.ring->prod_tail,
> +				    qp->rq.wqe_cnt);
> +	}
> +
> +	spin_unlock_irqrestore(&qp->rq.lock, flags);
> +
> +	pvrdma_write_uar_qp(dev, PVRDMA_UAR_QP_RECV | qp->qp_handle);
> +
> +	return ret;
> +
> +out:
> +	spin_unlock_irqrestore(&qp->rq.lock, flags);
> +
> +	return ret;
> +}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
