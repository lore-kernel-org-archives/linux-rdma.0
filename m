From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/8] libibverbs: Introduce XRC domains
Date: Mon, 24 Sep 2012 16:09:12 -0600
Message-ID: <20120924220912.GA12418@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8E7FB@ORSMSX101.amr.corp.intel.com>
 <20120924203618.GC9472@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8F01C@ORSMSX101.amr.corp.intel.com>
 <20120924211911.GA11120@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8F05F@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8F05F-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 24, 2012 at 09:54:22PM +0000, Hefty, Sean wrote:

> The cost should really be minimal and goes away as soon as the
> provider is updated, which I would expect all of them to be before
> the next release of verbs or OFED.

Donno, many don't need to change because they don't support any
extensions..
 
> > Plus I don't see that we should be trying to make extended structures
> > for many of the things in patch 2 (ibv_qp, ibv_srq, ibv_ah, ibv_mr,
> > ibv_cq, ibv_pd, ibv_mw). Additional functionality for those objects is
> > better served through new, optional, function entry points than by
> > allowing the consumer to muck about directl in those structures. Those
> > structs, in particular, should have been opaque from day 1, IMHO.
 
> There is data sharing that's required between verbs and the provider
> for verbs to do anything useful.  We need to add an xrcd to the QP
> and xrcd, cq, and srq_num to the SRQ.  Verbs uses the xrcd's and cq,
> but the user needs the srq_num.

Internally verbs can learn if the cq is extended via inspecting the
context structure, so I don't see the verbs<->provider interface as
the problem here. Exposing this mess to users should be done at little
as possible..

> Verbs doesn't allocate the structures, so it can't store anything.

Well, that is the point, verbs shouldn't be storing things, any change
to the object state must go through the provider.

> Adding a bunch of get/set calls seems worse to me than just placing
> the items in a structure.

Really?

 if (cq->comp_mask & IBV_CQ_COMP_MASK_SRQ_NUM)
   srq_num = cq->srq_num

vs

 ibv_cq_get_srq_num(cq); // Returns 0 on error

Betcha at least 50% of apps would do the first one wrong....

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
