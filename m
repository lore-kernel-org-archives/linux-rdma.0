From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 05/10] iw_cxgb4: Add connection management functions.
Date: Mon, 26 Apr 2010 09:22:17 -0700
Message-ID: <adaeii2mbeu.fsf@roland-alpha.cisco.com>
References: <20100416182924.22495.59421.stgit@build.ogc.int>
	<20100416182951.22495.60351.stgit@build.ogc.int>
	<adask6oo2d4.fsf@roland-alpha.cisco.com>
	<4BD5A98C.8030700@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BD5A98C.8030700-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Mon, 26 Apr 2010 09:56:12 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 >  > +int c4iw_ep_redirect(void *ctx, struct dst_entry *old, struct dst_entry *new,

 > > As far as I can see this function is not called or otherwise referenced
 > > anywhere else (except for a declaration in a header).  Can we drop it?

 > Yes.

OK, I rolled the following up into the big "merge iw_cxgb4" patch I have queued:

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index e1c1ee0..b602438 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2260,24 +2260,6 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 	return ret;
 }
 
-int c4iw_ep_redirect(void *ctx, struct dst_entry *old, struct dst_entry *new,
-		     struct l2t_entry *l2t)
-{
-	struct c4iw_ep *ep = ctx;
-
-	if (ep->dst != old)
-		return 0;
-
-	PDBG("%s ep %p redirect to dst %p l2t %p\n", __func__, ep, new,
-	     l2t);
-	dst_hold(new);
-	cxgb4_l2t_release(ep->l2t);
-	ep->l2t = l2t;
-	dst_release(old);
-	ep->dst = new;
-	return 1;
-}
-
 /*
  * All the CM events are handled on a work queue to have a safe context.
  */

-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
