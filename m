From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 03/17] IB/core: Release allocated memory in
 cache setup failure
Date: Thu, 15 Dec 2016 21:27:43 -0700
Message-ID: <20161216042743.GD3797@obsidianresearch.com>
References: <1478184265-9620-1-git-send-email-leon@kernel.org>
 <1478184265-9620-4-git-send-email-leon@kernel.org>
 <20161216034218.GA12582@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161216034218.GA12582-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 15, 2016 at 10:42:19PM -0500, ira.weiny wrote:
> >  err:
> >  	gid_table_cleanup_one(device);
> > +free:
> > +	kfree(device->cache.pkey_cache);
> > +	kfree(device->cache.lmc_cache);
> 
> Despite the fact that another thread said this is supposed to be ok because
> ib_cache_release_one free's these I much prefer what you have done here.
> 
> However, don't you need to NULL these out so that ib_cache_release_one can
> safely call kfree again?

Yes.

I feel deja vue here, like I've pointed this out before and the
resolution was to just rely on the release function so we don't have
bugs like this.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
