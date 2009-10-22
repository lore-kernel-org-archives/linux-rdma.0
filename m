From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] rdma/cm: support option to allow manually setting
	IB path
Date: Wed, 21 Oct 2009 19:35:42 -0600
Message-ID: <20091022013542.GX14520@obsidianresearch.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <A08104C1CF70400F8BEF492AD49C8491@amr.corp.intel.com> <20091020181458.GD14520@obsidianresearch.com> <46770152ACA04B6C8AA9497C45AC8FD0@amr.corp.intel.com> <20091020191404.GH14520@obsidianresearch.com> <9DFD8E65325F4EE990749EEBE4BC33CA@amr.corp.intel.com> <20091022004245.GV14520@obsidianresearch.com> <AE35305D45DB49F591A45DADD822209A@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AE35305D45DB49F591A45DADD822209A-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2009 at 06:07:54PM -0700, Sean Hefty wrote:
> >I'm reluctant to override fields like this to save 4 bytes. The
> >clarity and extensibility of using an additional flags field seems
> >worth it to me, and the processing code is not complex. I cannot think
> >of a motivation to save the 4 bytes?
> 
> I wasn't thinking about saving the 4 bytes.  struct ib_user_path_rec is already
> part of the ABI for query route.  If the preference were used to indicate
> primary versus alternate path, which seems reasonable, then query route can more
> easily convey that information.

I'm not sure why we need to conflate these two functions..

But ucma_abi_query_route_resp is already broken as soon as the kernel
can support more than 2 paths on a QP. The entire point of the flags
scheme is to support more than 2 paths in future.

So ucma_abi_query_route_resp has to be churned in the future, and at
that time it can be synch'd to use the same structure as the path
update, and ibv_kern_path_rec can go away.

In light of that, I'd say pick the flag + raw PR method. That clearly
has the best long term API.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
