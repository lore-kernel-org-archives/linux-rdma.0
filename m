From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v2 2/5] IB/core, RDMA RW API: Do not exceed QP SGE send limit
Date: Wed, 13 Jul 2016 09:22:22 -0500
Message-ID: <001d01d1dd11$f8adfe70$ea09fb50$@opengridcomputing.com>
References: <c9a58bf1-b230-5990-a2b3-4e6aa729cd8f@sandisk.com> <7b9f8bca-38fa-b289-a92f-19cf93955e32@sandisk.com> <57860AA4.6070303@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57860AA4.6070303-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, "'Nicholas A. Bellinger'" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, 'Parav Pandit' <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Laurence Oberman' <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> 
> > -static inline u32 rdma_rw_max_sge(struct ib_device *dev,
> > -		enum dma_data_direction dir)
> > -{
> > -	return dir == DMA_TO_DEVICE ?
> > -		dev->attrs.max_sge : dev->attrs.max_sge_rd;
> > -}
> > -
> 
> Wait, this looks wrong...
> 
> iWARP devices have max_sge_rd = 1, Steve, did you get to test this?
>

No I haven't. 
 
> >   static inline u32 rdma_rw_fr_page_list_len(struct ib_device *dev)
> >   {
> >   	/* arbitrary limit to avoid allocating gigantic resources */
> > @@ -186,7 +179,7 @@ static int rdma_rw_init_map_wrs(struct rdma_rw_ctx
> *ctx, struct ib_qp *qp,
> >   		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
> >   {
> >   	struct ib_device *dev = qp->pd->device;
> > -	u32 max_sge = rdma_rw_max_sge(dev, dir);
> > +	u32 max_sge = qp->max_send_sge;
> 
> Here, rdma_read will use qp.max_send_sge = max_sge which is set by the
> ULP.
> 
> If the ULP used max(max_sge, max_sge_rd) which is the right thing, then
> we get a bug, if the ULP set min(max_sge, max_sge_rd) then it has
> effectively a single sge even for writes (which is not good).
> 
> The QP user needs to set the maximum sge allowed for reads or writes,
> but for reads use max_sge_rd and for writes use max_sge. Otherwise this
> will break.

I haven't paid enough attention to these changes, but definitely max_sge_rd is for reads and max_sge is for writes...


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
