From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V2 3/5] RDMA/core: transport-independent access flags
Date: Tue, 30 Jun 2015 09:26:57 -0500
Message-ID: <001601d0b340$d1d7e410$7587ac30$@opengridcomputing.com>
References: <20150629213332.4188.87551.stgit@build.ogc.int> <20150629213618.4188.50574.stgit@build.ogc.int> <55924447.1030707@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55924447.1030707-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Haggai Eran' <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Haggai Eran [mailto:haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> Sent: Tuesday, June 30, 2015 2:25 AM
> To: Steve Wise; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org; infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org;
> eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> Subject: Re: [PATCH V2 3/5] RDMA/core: transport-independent access flags
> 
> On 30/06/2015 00:36, Steve Wise wrote:
> >  /**
> > + * rdma_mr_roles - possible roles an RDMA MR will be used for
> > + *
> > + * This allows a transport independent RDMA application to
> > + * create MRs that are usable for all the desired roles w/o
> > + * having to understand which access rights are needed.
> > + */
> > +enum {
> > +
> > +	/* lkey used in a ib_recv_wr sge */
> > +	RDMA_MRR_RECV			= 1,
> > +
> > +	/* lkey used for a IB_WR_SEND in the ib_send_wr sge */
> > +	RDMA_MRR_SEND			= (1<<1),
> Perhaps you should mention that this covers all the IB_WR_SEND* opcodes
> (SEND_WITH_IMM and SEND_WITH_INV). READ, WRITE and ATOMICs also have
> several variants.
> 

Agreed.

> > +
> > +	/* rkey used for a IB_WR_RDMA_READ in ib_send_wr wr.rdma.rkey */
> > +	RDMA_MRR_READ_SOURCE		= (1<<2),
> > +
> > +	/* lkey used for a IB_WR_RDMA_READ in the ib_send_wr sge */
> > +	RDMA_MRR_READ_DEST		= (1<<3),
> > +
> > +	/* lkey used for a IB_WR_RDMA_WRITE in the ib_send_wr sge */
> > +	RDMA_MRR_WRITE_SOURCE		= (1<<4),
> > +
> > +	/* rkey used for a IB_WR_RDMA_WRITE in ib_send_wr wr.rdma.rkey */
> > +	RDMA_MRR_WRITE_DEST		= (1<<5),
> > +
> > +	/*
> > +	 * rkey used for a IB_WR_ATOMIC/MASKED_ATOMIC in ib_send_wr
> > +	 * wr.atomic.rkey
> > +	 */
> > +	RDMA_MRR_ATOMIC			= (1<<6),
> What about using as an lkey in an IB_WR_ATOMIC/MASKED_ATOMIC in the
> ib_send_wr sge? Do you want that to be covered by RDMA_MRR_SEND?
>

Ah yes.  Perhaps we need ATOMIC_SOURCE and ATOMIC_DEST.  I wouldn't include it in the SEND.
 
> > +
> > +	/* MR used for a IB_WR_MW_BIND in ib_send_wr wr.bind_mw.bind_info.mr */
> > +	RDMA_MRR_MW_BIND		= (1<<7),
> > +};



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
