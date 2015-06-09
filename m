From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH for-4.1 2/2] iw_cxgb4: support for bar2 qid densities exceeding the page size
Date: Tue, 9 Jun 2015 09:07:22 -0500
Message-ID: <002301d0a2bd$9aef5840$d0ce08c0$@opengridcomputing.com>
References: <1433854392-6531-1-git-send-email-hariprasad@chelsio.com>	 <1433854392-6531-3-git-send-email-hariprasad@chelsio.com> <1433858594.90034.14.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433858594.90034.14.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Tuesday, June 09, 2015 9:03 AM
> To: Hariprasad Shenai
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org; leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
> Subject: Re: [PATCH for-4.1 2/2] iw_cxgb4: support for bar2 qid densities exceeding the page size
> 
> On Tue, 2015-06-09 at 18:23 +0530, Hariprasad Shenai wrote:
> > Handle this configuration:
> >
> >         Queues Per Page * SGE BAR2 Queue Register Area Size > Page Size
> >
> > Use cxgb4_bar2_sge_qregs() to obtain the proper location within the
> > bar2 region for a given qid.
> >
> > Rework the DB and GTS write functions to make use of this bar2 info.
> >
> > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/cxgb4/cq.c       | 22 ++++++------
> >  drivers/infiniband/hw/cxgb4/device.c   | 16 +++------
> >  drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  5 +--
> >  drivers/infiniband/hw/cxgb4/qp.c       | 64 ++++++++++++++++++++++------------
> >  drivers/infiniband/hw/cxgb4/t4.h       | 60 ++++++++++++++++++++-----------
> >  5 files changed, 98 insertions(+), 69 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
> > index 68ddb37..8e5bbcb 100644
> > --- a/drivers/infiniband/hw/cxgb4/cq.c
> > +++ b/drivers/infiniband/hw/cxgb4/cq.c
> > @@ -156,19 +156,17 @@ static int create_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
> >  		goto err4;
> >
> >  	cq->gen = 1;
> > +	cq->gts = rdev->lldi.gts_reg;
> >  	cq->rdev = rdev;
> > -	if (user) {
> > -		u32 off = (cq->cqid << rdev->cqshift) & PAGE_MASK;
> >
> > -		cq->ugts = (u64)rdev->bar2_pa + off;
> > -	} else if (is_t4(rdev->lldi.adapter_type)) {
> > -		cq->gts = rdev->lldi.gts_reg;
> > -		cq->qid_mask = -1U;
> > -	} else {
> > -		u32 off = ((cq->cqid << rdev->cqshift) & PAGE_MASK) + 12;
> > -
> > -		cq->gts = rdev->bar2_kva + off;
> > -		cq->qid_mask = rdev->qpmask;
> > +	cq->bar2_va = c4iw_bar2_addrs(rdev, cq->cqid, T4_BAR2_QTYPE_INGRESS,
> > +				      &cq->bar2_qid,
> > +				      user ? &cq->bar2_pa : NULL);
> > +	if (user && !cq->bar2_va) {
> > +		pr_warn(MOD "%s: cqid %u not in BAR2 range.\n",
> > +			pci_name(rdev->lldi.pdev), cq->cqid);
> > +		ret = -EINVAL;
> > +		goto err4;
> >  	}
> >  	return 0;
> >  err4:
> > @@ -971,7 +969,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
> >  		insert_mmap(ucontext, mm);
> >
> >  		mm2->key = uresp.gts_key;
> > -		mm2->addr = chp->cq.ugts;
> > +		mm2->addr = (u64)(uintptr_t)chp->cq.bar2_pa;
> 
> Why are you using a cast here at all?  bar2_pa is already u64...
> 

So it should just have the (uintptr_t) cast?

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
