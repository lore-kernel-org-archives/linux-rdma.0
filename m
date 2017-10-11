From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 08/45] RDMA/cxgb3: Annotate locking assumptions
Date: Wed, 11 Oct 2017 10:48:50 -0700
Message-ID: <20171011174927.25113-9-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tell sparse what the locking assumptions are for __flush_qp() such
that it does not complain about the locking operations inside that
function.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_qp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index 7f633da0185d..3871e1fd8395 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -722,10 +722,13 @@ int iwch_post_terminate(struct iwch_qp *qhp, struct respQ_msg_t *rsp_msg)
  */
 static void __flush_qp(struct iwch_qp *qhp, struct iwch_cq *rchp,
 				struct iwch_cq *schp)
+	__releases(&qhp->lock)
+	__acquires(&qhp->lock)
 {
 	int count;
 	int flushed;
 
+	lockdep_assert_held(&qhp->lock);
 
 	pr_debug("%s qhp %p rchp %p schp %p\n", __func__, qhp, rchp, schp);
 	/* take a ref on the qhp since we must release the lock */
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
