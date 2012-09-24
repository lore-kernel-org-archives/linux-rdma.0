From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/8] libibverbs: Introduce XRC domains
Date: Mon, 24 Sep 2012 20:45:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8F01C@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8E7FB@ORSMSX101.amr.corp.intel.com>
 <20120924203618.GC9472@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120924203618.GC9472-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > +struct ibv_xrcd *__ibv_open_xrcd(struct ibv_context *context, int fd, int
> oflags)
> > +{
> > +	struct verbs_context *context_ex = verbs_get_ctx(context);
> > +	struct ibv_xrcd *xrcd;
> 
> This patch series seems to be missing the checks against a null return
> of verbs_get_ctx - if the driver is not extended these functions
> should return ENOSYS, not crash..

Patch 2 extends ibv_context for providers that don't by adding a translation layer for older providers.  This seemed to keep things simpler, since the core verbs code could rely on extension support.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
