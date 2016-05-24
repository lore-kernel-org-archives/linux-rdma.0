From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Tue, 24 May 2016 15:41:37 -0600
Message-ID: <20160524214137.GA6760@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <11b6d9c1-0b20-f929-c896-ca084fe18192-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 24, 2016 at 01:57:54PM -0400, Doug Ledford wrote:

> Sean's proposal does away with the rigid nature of the current verbs 1.0
> API and makes it much more flexible on a per-driver basis.  This doesn't
> address the end user API issues, but it at least cleans up the user
> driver <-> kernel driver API so that one vendor's driver is not forced
> to carry around all the baggage needed for every other vendor's drivers.

I'm not sure what you are reading, but to me both proposals look very
similar. They are both based on the generic object/action/method sort
of model I talked about in an earlier thread.

The main differences seem to boil down to the data marshalling and the
dispatching style for the kernel side..

Sean hasn't explored how to encode the actual method arguments, while
Mellanox's has a fairly well developed scheme with the netlink
encoding and sgl result list thingy.

> Under that model, each vendor only carries what they need.  It would
> then be libibverbs responsibility to take that driver specific data
> and

Either patchset could go in this direction. This is a basic question
we need to decide on.

I'm starting to think the basic thrust of the Mellanox series (provide
an easy compatability with our userspace) is a sane approach. The
other options look like far too much work to use as a starting point.

That doesn't mean we can't decide to move in a direct-only direction -
the uAPI needs to have enough extension points to allow for that. Such
work should happen incrementally, and mainly target new uAPIs.

> and not also the user visible libibverbs API at the same time.  If all
> we want to talk about is verbs 1.0 over ioctl, then yes, we can do that.
>  But not if we truly want to discuss a verbs 2.0 API.  And I have yet to
> gather from the discussions I hear from people that we are in fact
> decided on pursuing a verbs 1.0 over ioctl API instead of considering a
> verbs 2.0 API.

You are the only person I've heard who wants to restructure the
libibverbs interface at the same time..

When I kicked off this process at the OFA meeting the discussions
revolved around some very clear goals:
 1) Comprehensively close the security issue
 2) Provide 100% support for existing libibverbs users on the current
    libibverbs API
 3) Restructure obvious known weaknesses (eg IB specific areas)
 4) Add additional extension points

I feel like both patches are still going down the above path..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
