From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 08/14] IB/core: Add rdma_max_mad_size helper
Date: Wed, 20 May 2015 15:34:04 -0600
Message-ID: <20150520213404.GA6293@obsidianresearch.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
 <1432109615-19564-9-git-send-email-ira.weiny@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FDDACE@ORSMSX109.amr.corp.intel.com>
 <20150520180226.GC14309@phlsvsds.ph.intel.com>
 <20150520181928.GE28496@obsidianresearch.com>
 <20150520190352.GA22981@phlsvsds.ph.intel.com>
 <20150520194314.GA3344@obsidianresearch.com>
 <20150520213128.GD22981@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150520213128.GD22981-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 20, 2015 at 05:31:28PM -0400, ira.weiny wrote:
> > I'm not really sure it makes sense to have the drivers set this, since
> > the value is fixed based on the existing caps. The core could fill it
> > in, then we don't have to check the driver's work.
> > 
> > If the driver fills it then the core should do
> > 
> >  BUG_ON(!mad_cap && max_mad_size != 0)
> 
> The driver does fill this in, and the core check this as part of this patch.
> 
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c 
> index 8055195b5d60..ea25e9467cb5 100644 
> +++ b/drivers/infiniband/core/mad.c 
> @@ -2937,6 +2937,10 @@ static int ib_mad_port_open(struct ib_device *device, 
>         unsigned long flags; 
>         char name[sizeof "ib_mad123"]; 
>         int has_smi; 
> +       size_t max_mad_size = rdma_max_mad_size(device, port_num); 
> +
> +       if (WARN_ON(max_mad_size < IB_MGMT_MAD_SIZE))
> +               return -EFAULT;

Should be BUG_ON
In the wrong place
Not the test I asked for.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
