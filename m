From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next v1 2/2] RDMA/vmw_pvrdma: Update device query
 parameters and port caps
Date: Thu, 24 Aug 2017 14:47:39 -0700
Message-ID: <58ef6e75-a879-e7c5-2c91-8d1f64f1d98f@vmware.com>
References: <cover.1503468979.git.aditr@vmware.com>
 <a31ee424df9ad51371ff38e4f8239a390df13947.1503468979.git.aditr@vmware.com>
 <20170824143338.GB5128@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170824143338.GB5128@yuvallap>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thur, Aug 24, 2017 at 07:33:50AM 0700, Yuval Shaia wrote:
> On Tue, Aug 22, 2017 at 11:19:01PM -0700, Adit Ranadive wrote:
> > Added support for two device caps - max_sge_rd, max_fast_reg_page_list_len
> > and the IP_BASED_GIDS port cap flag.
> 
> And IB_PORT_CM_SUP
> 
> >
> > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >   drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h | 9 ++++++++-
> >   drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c   | 9 +++++++++
> >   2 files changed, 17 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
> > index 3a308ff..df0a6b5 100644
> > --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
> > +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
> > @@ -149,6 +149,13 @@
> >   	((_dev->dsr->caps.mode == PVRDMA_DEVICE_MODE_ROCE) &&		\
> >   	 (PVRDMA_IS_VERSION17(_dev) || PVRDMA_IS_VERSION18(_dev)))
> >   
> > +/*
> > + * Get capability values based on device version.
> > + */
> > +
> > +#define PVRDMA_GET_CAP(_dev, _old_val, _val) \
> > +	((PVRDMA_IS_VERSION18(_dev)) ? _val : _old_val)
> > +
> >   enum pvrdma_pci_resource {
> >   	PVRDMA_PCI_RESOURCE_MSIX,	/* BAR0: MSI-X, MMIO. */
> >   	PVRDMA_PCI_RESOURCE_REG,	/* BAR1: Registers, MMIO. */
> > @@ -251,7 +258,7 @@ struct pvrdma_device_caps {
> >   	u8  atomic_ops;				/* PVRDMA_ATOMIC_OP_* bits */
> >   	u8  bmme_flags;				/* FRWR Mem Mgmt Extensions */
> >   	u8  gid_types;				/* PVRDMA_GID_TYPE_FLAG_ */
> > -	u8  reserved[4];
> > +	u32 max_fast_reg_page_list_len;
> >   };
> >   
> >   struct pvrdma_ring_page_info {
> > diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
> > index 2851704..48776f5 100644
> > --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
> > +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
> > @@ -83,6 +83,8 @@ int pvrdma_query_device(struct ib_device *ibdev,
> >   	props->max_qp_wr = dev->dsr->caps.max_qp_wr;
> >   	props->device_cap_flags = dev->dsr->caps.device_cap_flags;
> >   	props->max_sge = dev->dsr->caps.max_sge;
> > +	props->max_sge_rd = PVRDMA_GET_CAP(dev, dev->dsr->caps.max_sge,
> > +					   dev->dsr->caps.max_sge_rd);
> 
> I tend to agree with Leon on the other thread, i think that the following
> code is much more readable:
> 
> 	props->max_sge_rd = dev->dsr->caps.max_sge;
> 	if (PVRDMA_IS_VERSION18(dev))
> 		props->max_sge_rd = dev->dsr->caps.max_sge_rd;
> 
> And then in the future add something like this:
> 	if (PVRDMA_IS_VERSION19(dev))
> 		props->max_sge_rd = dev->dsr->caps.max_sge_19;
> 
> But it is totally up to you.

Thanks for taking a look and your suggestion.

> 
> >   	props->max_cq = dev->dsr->caps.max_cq;
> >   	props->max_cqe = dev->dsr->caps.max_cqe;
> >   	props->max_mr = dev->dsr->caps.max_mr;
> > @@ -101,8 +103,14 @@ int pvrdma_query_device(struct ib_device *ibdev,
> >   	    (dev->dsr->caps.bmme_flags & PVRDMA_BMME_FLAG_REMOTE_INV) &&
> >   	    (dev->dsr->caps.bmme_flags & PVRDMA_BMME_FLAG_FAST_REG_WR)) {
> >   		props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
> > +		props->max_fast_reg_page_list_len = PVRDMA_GET_CAP(dev,
> > +				PVRDMA_MAX_FAST_REG_PAGES,
> > +				dev->dsr->caps.max_fast_reg_page_list_len);
> >   	}
> >   
> > +	props->device_cap_flags |= IB_DEVICE_PORT_ACTIVE_EVENT |
> > +				   IB_DEVICE_RC_RNR_NAK_GEN;
> > +
> 
> Is it left over from version 17 or a new HW support?

No, we have always implicitly supported those. This just makes it more 
explicit to users.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
