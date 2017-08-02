From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core build environment enabling out-of-core providers
Date: Wed, 2 Aug 2017 13:34:03 -0600
Message-ID: <20170802193403.GA23777@obsidianresearch.com>
References: <007601d30b96$f2408170$d6c18450$@opengridcomputing.com>
 <20170802160900.GB21208@obsidianresearch.com>
 <019001d30bc3$cc6648e0$6532daa0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <019001d30bc3$cc6648e0$6532daa0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 02, 2017 at 02:16:09PM -0500, Steve Wise wrote:
> 1) I took my out-of-tree provider, and moved it into rdma-core, updated it to
> use the rdma-core bldenv and APIs.  This included the rdma-core mmio and
> dma/cache services, plus a few other nits like ccan, and the new byte swapping
> API, and got it building.  That was pretty straight forward.

Great, that is what I expected..

> 2) I took the updated out-of-tree provider src from 1), and put it back in the
> out-of-tree provider automake/config bldenv, and then tried to pull in whatever
> was needed from rdma-core to build it.  This resulted in me pulling certain
> files, like you mentioned above.  I just pulled them from the rdma-core/build/
> tree for the sake of getting it to build.   Basically I needed ccan/*
> infiniband/driver.h, and util/compiler.h/udma_barrier.h.  That got it to build.

Just be careful that all the cmake magic is working properly in your
other environment, for all the distros you want to target..

> I haven't tested either of these yet to see if they actually load.  But that's
> where I'm at.  #2 has the issues you describe, in that the atomic header is
> auto-generated based on the installed distro/platform.  So that leads to using
> #1 which is what you recommend.  I'm ok with using #1, but then the issue
> becomes supporting my provider across older non rdma-core installed
> systems.

You can handle this by rolling back the rdma-core repository to the
right points in history and re-instering your provider. This will
require some level of cherry picking future patches (eg ccan, etc),
but may be the simplest approach for this specific requirement.

This would be somewhere around
0c0914e1e9b7a68bcebfe785b6df30500ca7d2e0 for RHEL7 libibverbs.

You can find a similar point for OFED.

This could be automated, so you can develope against upstream, and
then using a script create a rdma-core with the classic private ABI,
and copy the provider from the upstream to build it.

Alternatively, just have your customers use a new libibverbs on
RHEL. That reduces your QA burden and development workload...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
