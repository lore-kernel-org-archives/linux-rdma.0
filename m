From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
Date: Wed, 9 Dec 2015 10:46:02 -0700
Message-ID: <20151209174602.GB31636@obsidianresearch.com>
References: <1449595982-20781-1-git-send-email-kaike.wan@intel.com>
 <20151208212133.GC14378@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB1858107A@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB1858107A-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 09, 2015 at 01:07:14PM +0000, Wan, Kaike wrote:

> > > +	/* Determine the default pkey index for SA access first.
> > > +	 *   Order of preference: 0xffff, 0x7fff, first pkey.
> > 
> > No, IBA says that only the default pkey should be used to talk to the SA,
> > every port needs 0x7FFF or the full mebership version. Do not search for the
> > first pkey.
> 
> We use the first pkey only if there is neither 0x7fff nor 0xffff in
> this port. If the port is in compliance with IB Spec, then we will
> be using either 0xffff or 0x7fff for SA access.

This is just confusing for readers, the IBA spec is very clear on what
pkey must be used to talk to the SA, don't ever use something
else. Follow the spec.

> > > +	 * Determine the default pkey for parsing address file as well.
> > > +	 *   order of preference: first full-member non-management pkey,
> > > +	 *   0xffff, first pkey.
> > > +	 */
> > 
> > This really should just be the 0 index pkey, which exactly matches how IPoIB
> > determines the default pkey, which is what matters when talking rdmacm..
> 
> It is true in most default configurations. However, since ibacm will
> use the default pkey for multicast, we want to make sure that it
> will not use a limited-member pkey to create/join a multicast group
> (practically of little use in this case) if such a pkey is placed at
> index 0.

If you don't follow the exact ipoib algorithm then you get different
answers in some cases and ugly subtle failure modes. Ie this algorithm
will not choose 0xFFFF as the pkey in cases where ipoib would - which
is not acceptable, IMHO.

If the 0 index pkey is not usable for ipoib then ipoib will be broken
too and that is far more likely to be noticed than if acm is broken.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
