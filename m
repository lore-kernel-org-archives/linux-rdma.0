From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Skip napi_schedule if ib_poll_cq fails
Date: Wed, 13 Jul 2016 22:12:25 +0300
Message-ID: <20160713191224.GB2985@yuval-lap>
References: <1468402436-25053-1-git-send-email-yuval.shaia@oracle.com>
 <20160713174742.GE19657@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160713174742.GE19657-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Haakon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 13, 2016 at 11:47:42AM -0600, Jason Gunthorpe wrote:
> On Wed, Jul 13, 2016 at 02:33:56AM -0700, Yuval Shaia wrote:
> > To avoid entering into endless loop when device can't poll CQE from CQ
> > driver should not reschedule if error is not -EAGAIN.
> 
> ?? what causes ib_poll_cq to return an error?
> 
> You need to describe the motivation here.

EAGAIN is fine - HW driver returns this to indicates temporary error and
caller should retry again.
However, other errors (such as EINVAL) may refer to some fatal error where
HW driver is unable to recover from.

Two examples:
- Mellanox folks may comment for example if the case where
  __mlx4_qp_lookup() returns NULL in function mlx4_ib_poll_one() means
  fatal or not.
- At least by reading the of c4iw_poll_cq_one() it is clear that it may
  return fatal error.

We must leave some exit point to HW driver to indicate a fatal and
unrecoverable state.

> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
