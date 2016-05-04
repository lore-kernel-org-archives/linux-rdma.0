From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 3/9] RDMA/iw_cxgb4: ensure eps don't get freed while the mutex is held
Date: Thu,  5 May 2016 01:27:31 +0530
Message-ID: <1462391857-20939-4-git-send-email-hariprasad@chelsio.com>
References: <1462391857-20939-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462391857-20939-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In rx_data(), with the ep in FPDU_MODE, refcnt=2, if we get unexpected
streaming data, we call c4iw_modify_rc_qp() and move the qp from
RTS -> TERMINATE.  In c4iw_modify_rc_qp(), if rdma_fini() returns
an error, the ep will be dereferenced (refcnt=1).  Then rx_data()
calls c4iw_ep_disconnect() which starts the close operation.
But if send_halfclose() fails in c4iw_ep_disconnect(), we  will call
release_ep_resources() derefing the ep which reduces the refcnt to 0 and
and frees the ep. However we still has the ep mutex at that point, so we
have a touch-after-free bug.  There is a similar issue where
peer_close() calls c4iw_ep_disconnect().

The solution is to add a reference to the ep in c4iw_ep_disconnect()
after acquiring  the mutex, and release it after releasing the mutex.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index cc9836e46800..12eac98661c1 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3416,6 +3416,12 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 	PDBG("%s ep %p state %s, abrupt %d\n", __func__, ep,
 	     states[ep->com.state], abrupt);
 
+	/*
+	 * Ref the ep here in case we have fatal errors causing the
+	 * ep to be released and freed.
+	 */
+	c4iw_get_ep(&ep->com);
+
 	rdev = &ep->com.dev->rdev;
 	if (c4iw_fatal_error(rdev)) {
 		fatal = 1;
@@ -3476,6 +3482,7 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 		}
 	}
 	mutex_unlock(&ep->com.mutex);
+	c4iw_put_ep(&ep->com);
 	if (fatal)
 		release_ep_resources(ep);
 	return ret;
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
