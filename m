From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 03/37] IB/rdmavt: Add protection domain to rdmavt.
Date: Tue, 8 Dec 2015 19:17:48 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AAFE79BE@ORSMSX109.amr.corp.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
 <20151207204309.8144.26707.stgit@phlsvslse11.ph.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AAFE7252@ORSMSX109.amr.corp.intel.com>
 <20151208190854.GA16976@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151208190854.GA16976-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > +struct ib_pd *rvt_alloc_pd(struct ib_device *ibdev,
> > > +			   struct ib_ucontext *context,
> > > +			   struct ib_udata *udata)
> > > +{
> > > +	struct rvt_dev_info *dev = ib_to_rvt(ibdev);
> > > +	struct rvt_pd *pd;
> > > +	struct ib_pd *ret;
> > > +
> > > +	pd = kmalloc(sizeof(*pd), GFP_KERNEL);
> > > +	if (!pd) {
> > > +		ret = ERR_PTR(-ENOMEM);
> > > +		goto bail;
> > > +	}
> > > +	/*
> > > +	 * This is actually totally arbitrary.  Some correctness tests
> > > +	 * assume there's a maximum number of PDs that can be allocated.
> > > +	 * We don't actually have this limit, but we fail the test if
> > > +	 * we allow allocations of more than we report for this value.
> > > +	 */
> >
> > Why not trap this in user space, rather than forcing the kernel to
> support some test program?
> >
> 
> What do you mean "trap this in user space"?  This code is not supporting
> any
> particular test program.
> 
> If users try and allocate more protection domains then are advertised then
> an
> error should be returned.
> 
> Perhaps the comment should be removed if it is confusing?

There is no theoretical limit on the number of PDs, or likely most other resources.  So why define and enforce an arbitrary limit?  The justification given was that some test program would fail.  If there's a concern about that test program passing, then enforce the limit in user space.

I didn't find the comment confusing.  Just the choice to let a test app drive the design.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
