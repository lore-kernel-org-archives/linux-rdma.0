From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v2 03/15] IB/pvrdma: Add support for Completion Queues
Date: Thu, 28 Jul 2016 20:32:37 +0000
Message-ID: <BLUPR0501MB836460809600A1976272FAAC5000@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1468352205-9137-1-git-send-email-aditr@vmware.com>
 <1468352205-9137-4-git-send-email-aditr@vmware.com>
 <20160718141221.GA20068@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160718141221.GA20068-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Mon, 18 Jul 2016 17:12:22 +0300 Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> 
> On Tue, Jul 12, 2016 at 12:36:33PM -0700, Adit Ranadive wrote:
> > This patch adds the support for creating and destroying completion queues
> > on the paravirtual RDMA device.
> >
> > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/pvrdma/pvrdma_cq.c | 436 +++++++++++++++++++++++++++++++
> >  1 file changed, 436 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_cq.c
> >

...

> > +void pvrdma_flush_cqe(struct pvrdma_qp *qp, struct pvrdma_cq *cq)
> > +{
> > +	int head;
> > +	int has_data;
> > +
> > +	if (!cq->is_kernel)
> > +		return;
> > +
> > +	/* Lock held */
> > +	has_data = pvrdma_idx_ring_has_data(&cq->ring_state->rx,
> > +					    cq->ibcq.cqe, &head);
> 
> For easy review (and probably maintenance) it looks to me that we need to
> preserve some sort of order where function/structures/union/enum etc will
> be define in preceding patch in a patch-set.
> This function implemented in patch #11 while we are in patch #3.

Ok will ensure that in v3.

> > +	if (unlikely(has_data > 0)) {
> > +		int items;
> > +		int curr;
> > +		int tail = pvrdma_idx(&cq->ring_state->rx.prod_tail,
> > +				      cq->ibcq.cqe);
> > +		struct pvrdma_cqe *cqe;
> > +		struct pvrdma_cqe *curr_cqe;
> > +
> > +		items = (tail > head) ? (tail - head) :
> > +			(cq->ibcq.cqe - head + tail);
> > +		curr = --tail;
> > +		while (items-- > 0) {
> > +			if (curr < 0)
> > +				curr = cq->ibcq.cqe - 1;
> > +			if (tail < 0)
> > +				tail = cq->ibcq.cqe - 1;
> > +			curr_cqe = get_cqe(cq, curr);
> > +			if ((curr_cqe->qp & 0xFFFF) != qp->qp_handle) {
> > +				if (curr != tail) {
> > +					cqe = get_cqe(cq, tail);
> > +					*cqe = *curr_cqe;
> > +				}
> > +				tail--;
> > +			} else {
> > +				pvrdma_idx_ring_inc(
> > +					&cq->ring_state->rx.cons_head,
> > +					cq->ibcq.cqe);
> > +			}
> > +			curr--;
> > +		}
> > +	}
> > +}
> > +
> > +static int pvrdma_poll_one(struct pvrdma_cq *cq, struct pvrdma_qp **cur_qp,
> > +			   struct ib_wc *wc)
> > +{
> > +	struct pvrdma_dev *dev = to_vdev(cq->ibcq.device);
> > +	int has_data;
> > +	unsigned int head;
> > +	bool tried = false;
> > +	struct pvrdma_cqe *cqe;
> > +
> > +retry:
> > +	has_data = pvrdma_idx_ring_has_data(&cq->ring_state->rx,
> > +					    cq->ibcq.cqe, &head);
> > +	if (has_data == 0) {
> > +		u32 val;
> > +
> > +		if (tried)
> > +			return -EAGAIN;
> > +
> > +		/* Pass down POLL to give physical HCA a chance to poll. */
> > +		val = cq->cq_handle | PVRDMA_UAR_CQ_POLL;
> > +		writel(cpu_to_le32(val),
> > +		       dev->driver_uar.map + PVRDMA_UAR_CQ_OFFSET);
> > +
> > +		tried = true;
> > +		goto retry;
> > +	} else if (has_data == -1) {
> 
> Is -1 represent fatal unrecoverable error or that next call to
> pvrdma_idx_ring_has_data might succeeds?

-1 does point to an invalid index on the ring. Its possible that the 
ring state is corrupted so treat it as unrecoverable for now.

> 
> > +		return -EINVAL;
> > +	}
> > +
> > +	cqe = get_cqe(cq, head);
> > +
> > +	/* Ensure cqe is valid. */
> > +	rmb();
> > +	if (dev->qp_tbl[cqe->qp & 0xffff])
> > +		*cur_qp = (struct pvrdma_qp *)dev->qp_tbl[cqe->qp & 0xffff];
> > +	else
> > +		return -EINVAL;
> 
> Is this can happen when QP was deleted while WR was processing?
> Or that in first place it was pushed with invalid QP?

If for some reason the QPN stored in the CQE was invalid we wanted to 
protect against that.

> Can you explain why you choose EINVAL and not EAGAIN? i.e we polled the
> "corrupted" CQE, next CEQ should be fine.
> Reading pvrdma_poll_cq looks like that if it was requested to poll 10 CQE
> for example and the 9th fails - the function will fail them all.

That makes sense. Ill replace this with EAGAIN. Its possible that the CQ is shared
with other QPs so other CQEs could still be valid.

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
