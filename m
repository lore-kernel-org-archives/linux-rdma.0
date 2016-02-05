From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 1/3] IB: new common API for draining a queue pair
Date: Fri, 5 Feb 2016 15:53:21 -0600
Message-ID: <00e501d1605f$a16c1630$e4444290$@opengridcomputing.com>
References: <cover.1454709317.git.swise@chelsio.com> <2da1db58d642789e8df154e34d622a37295d1ba3.1454709317.git.swise@chelsio.com> <3AB519EB-3BFE-4A02-A825-F74EECD2CE19@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3AB519EB-3BFE-4A02-A825-F74EECD2CE19-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+p6NamaJ0bNTAL8bYrjMMd8@public.gmane.org>
> >
> > Add provider-specific drain_qp function for providers needing special
> > drain logic.
> >
> > Add static function __ib_drain_qp() which posts noop WRs to the RQ and
> > SQ and blocks until their completions are processed.  This ensures the
> > applications completions have all been processed.
> >
> > Add API function ib_drain_qp() which calls the provider-specific drain
> > if it exists or __ib_drain_qp().
> >
> > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > ---
> > drivers/infiniband/core/verbs.c | 72 +++++++++++++++++++++++++++++++++++++++++
> > include/rdma/ib_verbs.h         |  2 ++
> > 2 files changed, 74 insertions(+)
> >
> > diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> > index 5af6d02..31b82cd 100644
> > --- a/drivers/infiniband/core/verbs.c
> > +++ b/drivers/infiniband/core/verbs.c
> > @@ -1657,3 +1657,75 @@ next_page:
> > 	return i;
> > }
> > EXPORT_SYMBOL(ib_sg_to_pages);
> > +
> > +struct ib_drain_cqe {
> > +	struct ib_cqe cqe;
> > +	struct completion done;
> > +};
> > +
> > +static void ib_drain_qp_done(struct ib_cq *cq, struct ib_wc *wc)
> > +{
> > +	struct ib_drain_cqe *cqe = container_of(wc->wr_cqe, struct ib_drain_cqe,
> > +						cqe);
> > +
> > +	complete(&cqe->done);
> > +}
> > +
> > +/*
> > + * Post a WR and block until its completion is reaped for both the RQ and SQ.
> > + */
> > +static void __ib_drain_qp(struct ib_qp *qp)
> > +{
> > +	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
> > +	struct ib_drain_cqe rdrain, sdrain;
> > +	struct ib_recv_wr rwr = {}, *bad_rwr;
> > +	struct ib_send_wr swr = {}, *bad_swr;
> > +	int ret;
> > +
> > +	rwr.wr_cqe = &rdrain.cqe;
> > +	rdrain.cqe.done = ib_drain_qp_done;
> > +	init_completion(&rdrain.done);
> > +
> > +	swr.wr_cqe = &sdrain.cqe;
> > +	sdrain.cqe.done = ib_drain_qp_done;
> 
> OK. ib_cqe is what hooks the completion events for these
> blank WRs, so those completions are never exposed to the
> RDMA consumer.
> 

Right, which means only consumers that use the new style CQ processing can make use of this.

> But does a consumer have to bump its SQE and RQE count
> when allocating its CQs, or is that done automatically
> by ib_alloc_cq() ?
>

The consumer has to make sure there is room in the SQ, RQ and CQ.  Going forward, we could enhance QP and CQ allocation to allow the
consumer to specify it wants drain capability so the consumer doesn't have to do this. It could be done under the covers.  In fact,
if we did that, then ib_destroy_qp() could do the drain if need be.
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
