From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
Date: Wed, 9 Dec 2015 13:07:14 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB1858107A@CRSMSX101.amr.corp.intel.com>
References: <1449595982-20781-1-git-send-email-kaike.wan@intel.com>
 <20151208212133.GC14378@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151208212133.GC14378-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Tuesday, December 08, 2015 4:22 PM
> To: Wan, Kaike
> Cc: Hefty, Sean; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
> 
> On Tue, Dec 08, 2015 at 12:33:02PM -0500, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > In an insecure IB fabric, the default pkey in a port is 0xffff, where
> > each node is allowed to talk to any other node in the fabric,
> > including the SA node. However, in a secure fabric, to limit member
> > access, not all nodes can have the full-member default pkey 0xffff. A
> > typical configuration is to let SA node have pkey 0xffff while all
> > other nodes have pkey 0x7fff; in addition, each node can be assigned
> > some other full-member pkeys, such as
> > 0x8001 and 0x8002, so that it can be assigned to different partitions.
> > In this case, each node can access SA, and yet limits its other access
> > to only those nodes in its assigned partitions. In such a secure
> > fabric, however, ibacm will not work by interpreting "default" in its
> > default address file as 0xffff.
> 
> ipoib always uses the 0 pkey index to create the default ipoib interface. (see
> eg, update_parent_pkey)
> 
> When operating securely the SA should place the pkey for default ipoib
> operation in pkey index 0, and place 0x7FFF in another index. I run alot of
> networks exactly like this and it works very well.

In such a configuration, this patch will enable ibacm to use pkey 0 for address resolution through multicast while use 0x7fff for SA access, exactly matching what ipoib is currently doing. 

> 
> This ensures that ipoib works out of the box without additional configuration.

This is exactly the purpose of this patch.

> 
> > +	/* Determine the default pkey index for SA access first.
> > +	 *   Order of preference: 0xffff, 0x7fff, first pkey.
> 
> No, IBA says that only the default pkey should be used to talk to the SA,
> every port needs 0x7FFF or the full mebership version. Do not search for the
> first pkey.

We use the first pkey only if there is neither 0x7fff nor 0xffff in this port. If the port is in compliance with IB Spec, then we will be using either 0xffff or 0x7fff for SA access.

> 
> > +	 * Determine the default pkey for parsing address file as well.
> > +	 *   order of preference: first full-member non-management pkey,
> > +	 *   0xffff, first pkey.
> > +	 */
> 
> This really should just be the 0 index pkey, which exactly matches how IPoIB
> determines the default pkey, which is what matters when talking rdmacm..

It is true in most default configurations. However, since ibacm will use the default pkey for multicast, we want to make sure that it will not use a limited-member pkey to create/join a multicast group (practically of little use in this case) if such a pkey is placed at index 0.

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
