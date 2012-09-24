From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/8] libibverbs: Introduce XRC domains
Date: Mon, 24 Sep 2012 15:19:11 -0600
Message-ID: <20120924211911.GA11120@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8E7FB@ORSMSX101.amr.corp.intel.com>
 <20120924203618.GC9472@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8F01C@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8F01C-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 24, 2012 at 08:45:10PM +0000, Hefty, Sean wrote:
> > > +struct ibv_xrcd *__ibv_open_xrcd(struct ibv_context *context, int fd, int
> > oflags)
> > > +{
> > > +	struct verbs_context *context_ex = verbs_get_ctx(context);
> > > +	struct ibv_xrcd *xrcd;
> > 
> > This patch series seems to be missing the checks against a null return
> > of verbs_get_ctx - if the driver is not extended these functions
> > should return ENOSYS, not crash..
> 
> Patch 2 extends ibv_context for providers that don't by adding a
> translation layer for older providers.  This seemed to keep things
> simpler, since the core verbs code could rely on extension support.

Well, that patch is pretty complex and it slows down common case high
speed calls (eg ibv_poll_cq) unless the provider is (fully?)
upgraded. That is something I wanted to see avoided.

Plus I don't see that we should be trying to make extended structures
for many of the things in patch 2 (ibv_qp, ibv_srq, ibv_ah, ibv_mr,
ibv_cq, ibv_pd, ibv_mw). Additional functionality for those objects is
better served through new, optional, function entry points than by
allowing the consumer to muck about directl in those structures. Those
structs, in particular, should have been opaque from day 1, IMHO.

So at first blush, adding null checks in _ex functions seems like a
lessor evil, IHMO...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
