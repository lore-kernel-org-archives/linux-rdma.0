From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V2 3/5] RDMA/core: transport-independent access flags
Date: Tue, 30 Jun 2015 09:30:42 -0500
Message-ID: <002001d0b341$585388a0$08fa99e0$@opengridcomputing.com>
References: <20150629213332.4188.87551.stgit@build.ogc.int> <20150629213618.4188.50574.stgit@build.ogc.int> <55925FAE.4090004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55925FAE.4090004-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Sagi Grimberg [mailto:sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Tuesday, June 30, 2015 4:22 AM
> To: Steve Wise; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org; infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org;
> eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> Subject: Re: [PATCH V2 3/5] RDMA/core: transport-independent access flags
> 
> On 6/30/2015 12:36 AM, Steve Wise wrote:
> > The semantics for MR access flags are not consistent across RDMA
> > protocols.  So rather than have applications try and glean what they
> > need, have them pass in the intended roles and attributes for the MR to
> > be allocated and let the RDMA core select the appropriate access flags
> > given the roles, attributes, and device capabilities.
> >
> > We introduce rdma_mr_roles and rdma_mr_attributes that enumerate the
> > possible roles and attributes for a MR.  These are documented in the
> > enums themselves.
> >
> > New services exported:
> >
> > rdma_device_access_flags() - given the intended MR roles and attributes
> > passed in, return the ib_access_flags bits for the device.
> >
> > rdma_get_dma_mr() - allocate a dma mr using the applications intended
> > MR roles and MR attributes.  This uses rdma_device_access_flags().
> >
> > rdma_fast_reg_access_flags() - return the ib_access_flags bits needed
> > for a fast register WR given the applications intended MR roles and
> > MR attributes.  This uses rdma_device_access_flags().
> >
> > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > ---
> >   drivers/infiniband/core/verbs.c |   30 ++++++++++++
> >   include/rdma/ib_verbs.h         |  101 +++++++++++++++++++++++++++++++++++++++
> >   2 files changed, 131 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> > index bac3fb4..2aa7c92 100644
> > --- a/drivers/infiniband/core/verbs.c
> > +++ b/drivers/infiniband/core/verbs.c
> > @@ -1144,6 +1144,36 @@ struct ib_mr *ib_get_dma_mr(struct ib_pd *pd, int mr_access_flags)
> >   }
> >   EXPORT_SYMBOL(ib_get_dma_mr);
> >
> > +int rdma_device_access_flags(struct ib_pd *pd, int roles, int attrs)
> > +{
> > +	int access_flags = attrs;
> > +
> > +	if (roles & RDMA_MRR_RECV)
> > +		access_flags |= IB_ACCESS_LOCAL_WRITE;
> > +
> > +	if (roles & RDMA_MRR_WRITE_DEST)
> > +		access_flags |= IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE;
> > +
> > +	if (roles & RDMA_MRR_READ_DEST) {
> > +		access_flags |= IB_ACCESS_LOCAL_WRITE;
> > +		if (rdma_protocol_iwarp(pd->device,
> > +					rdma_start_port(pd->device)))
> > +			access_flags |= IB_ACCESS_REMOTE_WRITE;
> > +	}
> > +
> > +	if (roles & RDMA_MRR_READ_SOURCE)
> > +		access_flags |= IB_ACCESS_REMOTE_READ;
> > +
> > +	if (roles & RDMA_MRR_ATOMIC)
> > +		access_flags |= IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_ATOMIC;
> > +
> > +	if (roles & RDMA_MRR_MW_BIND)
> > +		access_flags |= IB_ACCESS_MW_BIND;
> > +
> > +	return access_flags;
> > +}
> > +EXPORT_SYMBOL(rdma_device_access_flags);
> > +
> >   struct ib_mr *ib_reg_phys_mr(struct ib_pd *pd,
> >   			     struct ib_phys_buf *phys_buf_array,
> >   			     int num_phys_buf,
> > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > index 986fddb..135592d 100644
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -2494,6 +2494,107 @@ static inline int ib_req_ncomp_notif(struct ib_cq *cq, int wc_cnt)
> >   struct ib_mr *ib_get_dma_mr(struct ib_pd *pd, int mr_access_flags);
> >
> >   /**
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
> > +
> > +	/* MR used for a IB_WR_MW_BIND in ib_send_wr wr.bind_mw.bind_info.mr */
> > +	RDMA_MRR_MW_BIND		= (1<<7),
> > +};
> > +
> > +/**
> > + * rdma_mr_attributes - attributes for rdma memory regions
> > + */
> > +enum {
> > +	RDMA_MRA_ZERO_BASED		= IB_ZERO_BASED,
> > +	RDMA_MRA_ACCESS_ON_DEMAND	= IB_ACCESS_ON_DEMAND,
> > +};
> > +
> > +/**
> > + * rdma_device_access_flags - Returns the device-specific MR access flags.
> > + * @pd: The protection domain associated with the memory region.
> > + * @roles: The intended roles of the MR
> > + * @attrs: The desired attributes of the MR
> > + *
> > + * Use the intended roles from @roles along with @attrs and the device
> > + * capabilities to generate the needed access rights.
> > + *
> > + * Return: the ib_access_flags value needed to allocate the MR.
> > + */
> > +int rdma_device_access_flags(struct ib_pd *pd, int roles, int attrs);
> > +
> > +/**
> > + * rdma_get_dma_mr - Returns a memory region for system memory that is
> > + * usable for DMA.
> > + * @pd: The protection domain associated with the memory region.
> > + * @roles: The intended roles of the MR
> > + * @attrs: The desired attributes of the MR
> > + *
> > + * Use the intended roles from @roles along with @attrs and the device
> > + * capabilities to define the needed access rights, and call
> > + * ib_get_dma_mr() to allocate the MR.
> > + *
> > + * Note that the ib_dma_*() functions defined below must be used
> > + * to create/destroy addresses used with the Lkey or Rkey returned
> > + * by ib_get_dma_mr().
> > + *
> > + * Return: struct ib_mr pointer upon success, or a pointer encoded errno upon
> > + * failure.
> > + */
> > +static inline struct ib_mr *rdma_get_dma_mr(struct ib_pd *pd, int roles,
> > +					    int attrs)
> > +{
> > +	return ib_get_dma_mr(pd, rdma_device_access_flags(pd, roles, attrs));
> > +}
> 
> Do we really need the rdma_get_dma_mr() wrapper?
> 
> I suggest to start consolidating to ib_create_mr() that receives an
> extensible ib_mr_init_attr and additional attributes can be mr_roles
> and mr_attrs.
> 
> I have no problem with renaming it to rdma_create_mr() if people really
> want to.
> 
> See my comment in: http://marc.info/?l=linux-rdma&m=143539761710553&w=2
> 
> Thoughts?

I'm not opposed to your suggestion to consolidate.  I'd like to hear what others think?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
