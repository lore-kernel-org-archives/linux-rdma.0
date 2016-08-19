From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 4/6] RDMA/core: Move HFI1 IOCTL declarations to
 common file
Date: Fri, 19 Aug 2016 12:32:12 -0600
Message-ID: <20160819183212.GA20340@obsidianresearch.com>
References: <1471355123-6227-1-git-send-email-leon@kernel.org>
 <1471355123-6227-5-git-send-email-leon@kernel.org>
 <20160817061630.GB27477@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160817061630.GB27477-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 17, 2016 at 02:16:31AM -0400, ira.weiny wrote:
> On Tue, Aug 16, 2016 at 04:45:21PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > 
> > Move HFI1 IOCTL declarations to rdma_user_ioctl.h file.
> 
> I have not tried with the patch but I'm 99% sure this will break the PSM2
> library build which includes hfi1_user.h.
> 
> This is one of those things I have pondered in the past.  Most of the rdma
> libraries don't actually use these definitions directly.  PSM2 does.
> 
> I'm not sure what other libraries do.

They should all be fixed to use the new uapi headers instead of
cloning them privately. If we go ahead with the rdma-plumbing I might
even do it..

> In the final patch of this series you admit that the name changes in that patch
> will break userspace which uses the defines directly.  Can we, should we, do
> that?

This happens from time to time, userspace should gain a build-time
test to deal with it, if it is a big enough deal, IMHO.

We don't guarentee 100% source compatibility..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
