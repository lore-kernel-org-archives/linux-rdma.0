From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] RDMA/vmw_pvrdma: Report network header
 type in WC
Date: Tue, 29 Aug 2017 09:54:43 -0400
Message-ID: <1504014883.52034.33.camel@redhat.com>
References: <cover.1503965717.git.aditr@vmware.com>
         <521f5e2169789e31a7e91dab691cd155f0100090.1503965717.git.aditr@vmware.com>
         <20170829054533.GH23726@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170829054533.GH23726-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-08-29 at 08:45 +0300, Leon Romanovsky wrote:
> On Mon, Aug 28, 2017 at 05:19:35PM -0700, Adit Ranadive wrote:
> > From: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > 
> > We should report the network header type in the work completion so
> > that
> > the kernel can infer the right RoCE type headers.
> > 
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/vmw_pvrdma/pvrdma.h    |  6 ++++++
> >  drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c |  2 ++
> >  include/uapi/rdma/vmw_pvrdma-abi.h           | 13 +++++++++++--
> >  3 files changed, 19 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> > b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> > index 663a0c3..99b2c97 100644
> > --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> > +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> > @@ -426,6 +426,12 @@ static inline int pvrdma_wc_flags_to_ib(int
> > flags)
> >  	return flags;
> >  }
> > 
> > +static inline enum rdma_network_type pvrdma_wc_network_hdr_to_ib(
> > +					enum pvrdma_network_type
> > type)
> > +{
> > +	return (enum rdma_network_type)type;
> > +}
> > +
> >  static inline int ib_send_flags_to_pvrdma(int flags)
> >  {
> >  	return flags & PVRDMA_MASK(PVRDMA_SEND_FLAGS_MAX);
> > diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> > b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> > index 90aa326..34727f6 100644
> > --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> > +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> > @@ -389,6 +389,8 @@ static int pvrdma_poll_one(struct pvrdma_cq
> > *cq, struct pvrdma_qp **cur_qp,
> >  	wc->dlid_path_bits = cqe->dlid_path_bits;
> >  	wc->port_num = cqe->port_num;
> >  	wc->vendor_err = cqe->vendor_err;
> > +	wc->network_hdr_type =
> > +			pvrdma_wc_network_hdr_to_ib(cqe-
> > >network_hdr_type);
> > 
> >  	/* Update shared ring state */
> >  	pvrdma_idx_ring_inc(&cq->ring_state->rx.cons_head, cq-
> > >ibcq.cqe);
> > diff --git a/include/uapi/rdma/vmw_pvrdma-abi.h
> > b/include/uapi/rdma/vmw_pvrdma-abi.h
> > index c8c1d2d..6a87806 100644
> > --- a/include/uapi/rdma/vmw_pvrdma-abi.h
> > +++ b/include/uapi/rdma/vmw_pvrdma-abi.h
> > @@ -58,6 +58,13 @@
> >  #define PVRDMA_UAR_CQ_ARM		BIT(30)		/*
> > Arm bit. */
> >  #define PVRDMA_UAR_CQ_POLL		BIT(31)		/
> > * Poll bit. */
> > 
> > +enum pvrdma_network_type {
> > +	PVRDMA_NETWORK_IB,
> > +	PVRDMA_NETWORK_ROCE_V1 = PVRDMA_NETWORK_IB,
> > +	PVRDMA_NETWORK_IPV4,
> > +	PVRDMA_NETWORK_IPV6
> > +};
> 
> Doug,
> 
> I see that you are already merged this patch, but it is problematic
> patch.

It's only gone to github, so it's not set in stone.

> They defined in uapi file, the new enum which is equal to already
> existed
>  128 enum rdma_network_type {
>  129         RDMA_NETWORK_IB,
>  130         RDMA_NETWORK_ROCE_V1 = RDMA_NETWORK_IB,
>  131         RDMA_NETWORK_IPV4,
>  132         RDMA_NETWORK_IPV6
>  133 };
> 
> And the more important they are doing direct casting from
> rdma_network_type to
> pvrdma_network_type as is in the same patch.
> 
> The proper way to do it is to return rdma_network_type directly
> without obfuscation
> and without creating new supported forever UAPI enum.

Generally, I would agree with you.  I guess that's what I get for
trying to get everything done and working late last night :-/.

Adit, is there a reason for the duplicate enum and silly casting in
this patch?  If there isn't a specific reason for it, then it would be
best to re-write it without this silliness.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
