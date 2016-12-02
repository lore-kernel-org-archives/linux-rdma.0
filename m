From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 12/16] IB/pvrdma: Add Queue Pair support
Date: Fri, 2 Dec 2016 21:07:09 +0530
Message-ID: <19db181d-da71-efb3-dfc9-ebe2a7b77916@vmware.com>
References: <cover.1475458407.git.aditr@vmware.com>
 <6a643e92376856394d45638d80a90619d3abac37.1475458407.git.aditr@vmware.com>
 <20161114113403.GA11338@yuval-lap.Home>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161114113403.GA11338-Hxa29pjIrERMGUUWBy6pNA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 14, 2016 at 1:34:05PM +0200, Yuval Shaia wrote:
> > +/**
> > + * pvrdma_post_send - post send work request entries on a QP
> > + * @ibqp: the QP
> > + * @wr: work request list to post
> > + * @bad_wr: the first bad WR returned
> > + *
> > + * @return: 0 on success, otherwise errno returned.
> > + */
> > +int pvrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
> > +		     struct ib_send_wr **bad_wr)
> > +{
> > +	struct pvrdma_qp *qp = to_vqp(ibqp);
> > +	struct pvrdma_dev *dev = to_vdev(ibqp->device);
> > +	unsigned long flags;
> > +	struct pvrdma_sq_wqe_hdr *wqe_hdr;
> > +	struct pvrdma_sge *sge;
> > +	int i, index;
> > +	int nreq;
> > +	int ret;
> > +
> > +	/*
> > +	 * In states lower than RTS, we can fail immediately. In other states,
> > +	 * just post and let the device figure it out.
> > +	 */
> > +	if (qp->state < IB_QPS_RTS) {
> > +		*bad_wr = wr;
> > +		return -EINVAL;
> > +	}
> > +
> > +	spin_lock_irqsave(&qp->sq.lock, flags);
> > +
> > +	index = pvrdma_idx(&qp->sq.ring->prod_tail, qp->sq.wqe_cnt);
> 
> Not sure if it was discussed so posting "just in case".
> I believe it is unlikely that index will go out of range but since
> pvrdma_idx might return PVRDMA_INVALID_IDX i suggest to add a check here.
> Something like:
> 	if (unlikely(index == PVRDMA_INVALID_IDX)) {
> 		*bad_wr = wr;
> 		return -EFAULT;
> 	}
> 
> Same goes with pvrdma_post_recv

Thanks for the suggestion! We can add that in the next patch.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
