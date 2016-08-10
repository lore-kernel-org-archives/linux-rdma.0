From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Fetch monitor values on-demand for CableInfo query
Date: Wed, 10 Aug 2016 01:35:50 -0400
Message-ID: <20160810053549.GA32695@phlsvsds.ph.intel.com>
References: <1470755838-14117-1-git-send-email-ira.weiny@intel.com> <20160809175801.GD23921@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160809175801.GD23921-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 09, 2016 at 08:58:01PM +0300, Leon Romanovsky wrote:
> On Tue, Aug 09, 2016 at 11:17:18AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > The monitor values from bytes 22 through 81 of the QSFP memory space
> > (SFF 8636) are dynamic and serving them out of the QSFP memory cache
> > maintained by the driver provides stale data to the CableInfo SMA query.
> > This patch refreshes the dynamic values from the QSFP memory on request
> > and overwrites the stale data from the cache for the overlap between the
> > requested range and the monitor range.
> > 
> > 
> 
> Ira,
> On all your patches, you have double line between commit message and
> tags.

Does this cause a problem?

Ira

> 
> > Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
