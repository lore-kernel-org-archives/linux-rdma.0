From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/8] libibverbs: Introduce XRC domains
Date: Mon, 24 Sep 2012 21:54:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8F05F@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8E7FB@ORSMSX101.amr.corp.intel.com>
 <20120924203618.GC9472@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8F01C@ORSMSX101.amr.corp.intel.com>
 <20120924211911.GA11120@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120924211911.GA11120-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Well, that patch is pretty complex and it slows down common case high
> speed calls (eg ibv_poll_cq) unless the provider is (fully?)
> upgraded. That is something I wanted to see avoided.

The provider does need to support extensions.  They don't need to support any extra calls.

The cost should really be minimal and goes away as soon as the provider is updated, which I would expect all of them to be before the next release of verbs or OFED.

> Plus I don't see that we should be trying to make extended structures
> for many of the things in patch 2 (ibv_qp, ibv_srq, ibv_ah, ibv_mr,
> ibv_cq, ibv_pd, ibv_mw). Additional functionality for those objects is
> better served through new, optional, function entry points than by
> allowing the consumer to muck about directl in those structures. Those
> structs, in particular, should have been opaque from day 1, IMHO.

There is data sharing that's required between verbs and the provider for verbs to do anything useful.  We need to add an xrcd to the QP and xrcd, cq, and srq_num to the SRQ.  Verbs uses the xrcd's and cq, but the user needs the srq_num.

Verbs doesn't allocate the structures, so it can't store anything.  Adding a bunch of get/set calls seems worse to me than just placing the items in a structure.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
