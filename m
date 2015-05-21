From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 08/14] IB/core: Add rdma_max_mad_size helper
Date: Wed, 20 May 2015 20:19:41 -0400
Message-ID: <20150521001940.GG22981@phlsvsds.ph.intel.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com> <1432109615-19564-9-git-send-email-ira.weiny@intel.com> <1828884A29C6694DAF28B7E6B8A82373A8FDDACE@ORSMSX109.amr.corp.intel.com> <20150520180226.GC14309@phlsvsds.ph.intel.com> <20150520181928.GE28496@obsidianresearch.com> <20150520190352.GA22981@phlsvsds.ph.intel.com> <20150520194314.GA3344@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150520194314.GA3344-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> I'm not really sure it makes sense to have the drivers set this, since
> the value is fixed based on the existing caps. The core could fill it
> in, then we don't have to check the driver's work.
 
This comment is making more sense to me now...  We already discussed this at
length and it was agreed that the MAD length was not to be hard coded to any
particular MAD support "bit".

Therefore I'm going to continue with this additional flexibility because I have
added it.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
