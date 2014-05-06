From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH V2 RFC 1/3] svcrdma: Transport and header file changes
Date: Tue, 6 May 2014 17:13:06 -0400
Message-ID: <20140506211306.GR18281@fieldses.org>
References: <20140506174621.18208.24242.stgit@build.ogc.int>
 <20140506174626.18208.95519.stgit@build.ogc.int>
 <20140506192157.GJ18281@fieldses.org>
 <53694DF1.5010808@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53694DF1.5010808-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 06, 2014 at 04:02:41PM -0500, Steve Wise wrote:
> On 5/6/2014 2:21 PM, J. Bruce Fields wrote:
> >On Tue, May 06, 2014 at 12:46:27PM -0500, Steve Wise wrote:
> >>From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> >>
> >>Change poll logic to grab up to 6 completions at a time.
> >>
> >>RDMA write and send completions no longer deal with fastreg objects.
> >>
> >>Set SVCRDMA_DEVCAP_FAST_REG and allocate a dma_mr based on the device
> >>capabilities.
> >>
> >>Signed-off-by: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> >>Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> >>---
> >>
> >>  include/linux/sunrpc/svc_rdma.h          |    3 -
> >>  net/sunrpc/xprtrdma/svc_rdma_transport.c |   62 +++++++++++++++++-------------
> >>  2 files changed, 37 insertions(+), 28 deletions(-)
> >>
> >>diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
> >>index 0b8e3e6..5cf99a0 100644
> >>--- a/include/linux/sunrpc/svc_rdma.h
> >>+++ b/include/linux/sunrpc/svc_rdma.h
> >>@@ -115,14 +115,13 @@ struct svc_rdma_fastreg_mr {
> >>  	struct list_head frmr_list;
> >>  };
> >>  struct svc_rdma_req_map {
> >>-	struct svc_rdma_fastreg_mr *frmr;
> >>  	unsigned long count;
> >>  	union {
> >>  		struct kvec sge[RPCSVC_MAXPAGES];
> >>  		struct svc_rdma_chunk_sge ch[RPCSVC_MAXPAGES];
> >>+		unsigned long lkey[RPCSVC_MAXPAGES];
> >>  	};
> >>  };
> >>-#define RDMACTXT_F_FAST_UNREG	1
> >>  #define RDMACTXT_F_LAST_CTXT	2
> >>  #define	SVCRDMA_DEVCAP_FAST_REG		1	/* fast mr registration */
> >>diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> >>index 25688fa..2c5b201 100644
> >>--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
> >>+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> >>@@ -1,4 +1,5 @@
> >>  /*
> >>+ * Copyright (c) 2014 Open Grid Computing, Inc. All rights reserved.
> >>   * Copyright (c) 2005-2007 Network Appliance, Inc. All rights reserved.
> >>   *
> >>   * This software is available to you under a choice of one of two
> >>@@ -160,7 +161,6 @@ struct svc_rdma_req_map *svc_rdma_get_req_map(void)
> >>  		schedule_timeout_uninterruptible(msecs_to_jiffies(500));
> >>  	}
> >>  	map->count = 0;
> >>-	map->frmr = NULL;
> >>  	return map;
> >>  }
> >>@@ -336,22 +336,21 @@ static void process_context(struct svcxprt_rdma *xprt,
> >>  	switch (ctxt->wr_op) {
> >>  	case IB_WR_SEND:
> >>-		if (test_bit(RDMACTXT_F_FAST_UNREG, &ctxt->flags))
> >>-			svc_rdma_put_frmr(xprt, ctxt->frmr);
> >>+		BUG_ON(ctxt->frmr);
> >>  		svc_rdma_put_context(ctxt, 1);
> >>  		break;
> >>  	case IB_WR_RDMA_WRITE:
> >>+		BUG_ON(ctxt->frmr);
> >>  		svc_rdma_put_context(ctxt, 0);
> >>  		break;
> >>  	case IB_WR_RDMA_READ:
> >>  	case IB_WR_RDMA_READ_WITH_INV:
> >>+		svc_rdma_put_frmr(xprt, ctxt->frmr);
> >>  		if (test_bit(RDMACTXT_F_LAST_CTXT, &ctxt->flags)) {
> >>  			struct svc_rdma_op_ctxt *read_hdr = ctxt->read_hdr;
> >>  			BUG_ON(!read_hdr);
> >>-			if (test_bit(RDMACTXT_F_FAST_UNREG, &ctxt->flags))
> >>-				svc_rdma_put_frmr(xprt, ctxt->frmr);
> >>  			spin_lock_bh(&xprt->sc_rq_dto_lock);
> >>  			set_bit(XPT_DATA, &xprt->sc_xprt.xpt_flags);
> >>  			list_add_tail(&read_hdr->dto_q,
> >>@@ -363,6 +362,7 @@ static void process_context(struct svcxprt_rdma *xprt,
> >>  		break;
> >>  	default:
> >>+		BUG_ON(1);
> >>  		printk(KERN_ERR "svcrdma: unexpected completion type, "
> >>  		       "opcode=%d\n",
> >>  		       ctxt->wr_op);
> >Note the printk's unreachable now.  Should some of these BUG_ON()'s be
> >WARN_ON()'s?
> 
> I'll remove the printk.  And if any of the new BUG_ON()'s can be
> WARN_ON(), then I'll do that.  But only if proceeding after a
> WARN_ON() results in a working server.

The other thing to keep in mind is what the consequences of the BUG
might be--e.g. if we BUG while holding an important lock then that lock
never gets dropped and the system can freeze pretty quickly--possibly
before we get any useful information to the system logs.  On a quick
check that doesn't look like the case here, though.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
