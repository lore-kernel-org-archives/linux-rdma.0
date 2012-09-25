From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/8] libibverbs: Introduce XRC domains
Date: Mon, 24 Sep 2012 18:04:19 -0600
Message-ID: <20120925000419.GB12418@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8E7FB@ORSMSX101.amr.corp.intel.com>
 <20120924203618.GC9472@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8F01C@ORSMSX101.amr.corp.intel.com>
 <20120924211911.GA11120@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8F05F@ORSMSX101.amr.corp.intel.com>
 <20120924220912.GA12418@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8F087@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8F087-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 24, 2012 at 11:00:00PM +0000, Hefty, Sean wrote:
> > > Verbs doesn't allocate the structures, so it can't store anything.
> > 
> > Well, that is the point, verbs shouldn't be storing things, any change
> > to the object state must go through the provider.
> 
> Verbs does stuff like this:

This is all just internal bookkeeping between verbs and the provider,
it doesn't need to be exposed to the user. Verbs and the provider can
negotiate what the internal layout of these object allocations will be
through the context.

> > > Adding a bunch of get/set calls seems worse to me than just placing
> > > the items in a structure.
> > 
> > Really?
> > 
> >  if (cq->comp_mask & IBV_CQ_COMP_MASK_SRQ_NUM)
> >    srq_num = cq->srq_num
> > 
> > vs
> > 
> >  ibv_cq_get_srq_num(cq); // Returns 0 on error
> > 
> > Betcha at least 50% of apps would do the first one wrong....
> 
> An app which uses XRC just needs to access srq->srq_num.  No other
> checks are needed.  If they have an XRC SRQ, the SRQ number must be
> valid.  The mask seems pointless to me.

The mask is part of the API, and not all cases in the future are
guarenteed to be like XRC. Sometimes (like with this XRC example) you
can omit the comp_mask check, others times you can't. It is just too
complex for something low speed.

A function call can't be done wrong ;)

> If you're suggesting that verbs.h remains untouched (for patch 1 of
> this series), but that new structures are defined between the verbs
> and the provider only, that seems reasonable.  It would likely
> result in a bunch of typecasts everywhere.

I'm suggesting this group of provider-allocated structures remain
opaque to the user and we don't add new user-visible things to them at
all (having them non-opaque to start with was a mistake).

Use accessors to implement new functionality on these objects.

Accessors are an overall better strategy for keeping ABI stability,
and should be used whenever possible.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
