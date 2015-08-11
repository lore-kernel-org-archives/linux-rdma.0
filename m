From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/sa: Restrict SA Netlink to admin users
Date: Mon, 10 Aug 2015 23:38:10 -0600
Message-ID: <20150811053810.GA13314@obsidianresearch.com>
References: <1438895310-6087-1-git-send-email-ira.weiny@intel.com>
 <55C8407C.6060103@mellanox.com>
 <20150810215829.GA12260@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150810215829.GA12260-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 10, 2015 at 05:58:30PM -0400, ira.weiny wrote:

> Furthermore, the check in netlink_bind also uses the socket namespace to
> restrict the use of multicast.  This plus my checks should allow an admin to
> place the SA proxy (ibacm in our test cases) in an alternate network namespace
> if they so desire.  But this is independent to the namespace which may be used
> for data applications.

I think Haggai is on to something, there is certainly a problem here,
that netlink_bind will let a namespace subscribe is a certainly a
problem for what Haggai is working on.

For now, I think, only root (or CAP_ whatever) in the init namespace
should have access to this feature. Not sure how to check that.

Even allowing a namespace to subscribe is problematic because it will
cause timeouts to hit.. Not sure what to do about that..

Also, why the incremental patch? The original isn't ready for mainline
without the message validation stuff..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
