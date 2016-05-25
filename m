From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Wed, 25 May 2016 14:44:58 +0000
Message-ID: <HE1PR05MB141853FFF8C77E486362D202B1400@HE1PR05MB1418.eurprd05.prod.outlook.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
 <20160524214137.GA6760@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524214137.GA6760-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Wednesday, May 25, 2016 12:42 AM

> > Sean's proposal does away with the rigid nature of the current verbs
> > 1.0 API and makes it much more flexible on a per-driver basis.  This
> > doesn't address the end user API issues, but it at least cleans up the
> > user driver <-> kernel driver API so that one vendor's driver is not
> > forced to carry around all the baggage needed for every other vendor's
> drivers.
> 
> I'm not sure what you are reading, but to me both proposals look very similar.
> They are both based on the generic object/action/method sort of model I talked
> about in an earlier thread.
> 
> The main differences seem to boil down to the data marshalling and the
> dispatching style for the kernel side..
> 
> Sean hasn't explored how to encode the actual method arguments, while
> Mellanox's has a fairly well developed scheme with the netlink encoding and sgl
> result list thingy.
> 

BTW, we can easily incorporate Sean's facility for mapping user-->kernel objects as helper function for method handlers in the proposed patches.

> > Under that model, each vendor only carries what they need.  It would
> > then be libibverbs responsibility to take that driver specific data
> > and
> 
> Either patchset could go in this direction. This is a basic question we need to
> decide on.
> 
> I'm starting to think the basic thrust of the Mellanox series (provide an easy
> compatability with our userspace) is a sane approach. The other options look
> like far too much work to use as a starting point.
> 
> That doesn't mean we can't decide to move in a direct-only direction - the uAPI
> needs to have enough extension points to allow for that. Such work should
> happen incrementally, and mainly target new uAPIs.
> 

Right.

The proposed patches go a long way in enabling extensibility.
Typed parameters allow you to extend/replace/omit object properties as the interface evolves.
New object types allow you to introduce new concepts.
And the vendor channel can be used for arbitrary communication between a provider's user/kernel drivers.

We are not rushing anything.
--Liran

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
