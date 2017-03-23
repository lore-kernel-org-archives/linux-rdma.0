From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: libmlx5 doesn't build on s390x
Date: Thu, 23 Mar 2017 10:10:17 -0600
Message-ID: <20170323161017.GB29811@obsidianresearch.com>
References: <afe64964-4f10-0a00-0891-b97bf2c60b50@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <afe64964-4f10-0a00-0891-b97bf2c60b50-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 23, 2017 at 08:51:21AM -0400, Jarod Wilson wrote:
> Not sure if it's intentional, but in my adventure of the past day or two to
> get rdma-core v13 building across all the arches I need to build it for, I
> discovered that the mlx5 bits silently don't build on s390x. No build
> failure, they just aren't attempted, so far as I can see. The only sign of
> failure was when rpm %files globs failed to locate mlx5 bits.

I don't expect anything except mlx4 to *work* on s390 - fixing that
would require making a common IOMEM accessor system.

However, AFAIK, they should build..

> I noted that mlx4 has some s390x-specific trickery in providers/mlx4/mmio.h,
> and wondered if something similar was required for mlx5, or if "does not
> work on s390x and isn't expected to" is the norm. Currently, my builds are
> excluding mlx5 support on s390x due to the current state.

It would be nice if you could post logs for these various
failures..

My guess is that none of the DMA providers were compiled for S390,
which happens if the system cannot compile util/udma_barrier.h.

Perhaps this test is wrong?

#elif defined(__sparc__) || defined(__s390x__)

Maybe it should be

#elif defined(__sparc__) || defined(__s390x__) || defined(__s390__)

??

Also, you should expect mlx5 not to be built on ARM32 and in other
places where we do not support user DMA. Can you accommodate this in
the rpm spec file? Debian has the same issue too... You can simulate
this on x86-64 by patching util/udma_barrier.h to always fail to
compile.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
