From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/5] IB/ipoib: Limit call to free rdma_netdev for
 capable devices
Date: Wed, 28 Jun 2017 10:09:42 -0600
Message-ID: <20170628160942.GA28839@obsidianresearch.com>
References: <20170614065909.23650-1-leon@kernel.org>
 <20170614065909.23650-3-leon@kernel.org>
 <20170627173407.GA55945@knc-06.sc.intel.com>
 <20170627174156.GA5340@obsidianresearch.com>
 <20170627190838.GA55990@knc-06.sc.intel.com>
 <20170628071315.GZ1248@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170628071315.GZ1248-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 28, 2017 at 10:13:15AM +0300, Leon Romanovsky wrote:

> > Thanks, that is another option. With that, we will be freeing the
> > rdma_netdev from a function pointer call that belongs to that rdma_netdev.
> > Is that ok?  (Though I think it should work fine).

Yes, it is technicaly OK

> The downside of this that the code will be non-symmetrical, for
> alloc_rdma_netdev vs. free_rdma_netdev.

Not sure this really matters.. Obviously the way it is now is hard to
use since this mistake was made.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
