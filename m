From: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [patch 2/2] infiniband/cxgb4: add null check
Date: Mon, 31 May 2010 16:01:52 +0200
Message-ID: <20100531140152.GU5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Earlier in the function we assume that ep->com.cm_id can be null.  I
looked through the code briefly but couldn't tell if it actually is ever
null or not.  Adding a null check here seemed like a cautious thing to
do.

Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 60b5beb..9d11946 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -786,7 +786,8 @@ static void connect_reply_upcall(struct c4iw_ep *ep, int status)
 		ep->com.cm_id->event_handler(ep->com.cm_id, &event);
 	}
 	if (status < 0) {
-		ep->com.cm_id->rem_ref(ep->com.cm_id);
+		if (ep->com.cm_id)
+			ep->com.cm_id->rem_ref(ep->com.cm_id);
 		ep->com.cm_id = NULL;
 		ep->com.qp = NULL;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
