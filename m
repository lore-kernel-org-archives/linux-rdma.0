From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] Don't re-init wait object in init/fini paths.
Date: Fri, 07 Jan 2011 11:37:59 -0600
Message-ID: <20110107173759.14812.25906.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Re-initializing the wait object in rdma_init()/rdma_fini() causes a
timing window which can lead to a deadlock during close.  Once this
deadlock hits, all RDMA activity over the T4 device will be stuck.

There's no need to re-init the wait object, so remove it.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/qp.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 057cb25..3ccb765 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1029,7 +1029,6 @@ static int rdma_fini(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 	wqe->cookie = (unsigned long) &ep->com.wr_wait;
 
 	wqe->u.fini.type = FW_RI_TYPE_FINI;
-	c4iw_init_wr_wait(&ep->com.wr_wait);
 	ret = c4iw_ofld_send(&rhp->rdev, skb);
 	if (ret)
 		goto out;
@@ -1125,7 +1124,6 @@ static int rdma_init(struct c4iw_dev *rhp, struct c4iw_qp *qhp)
 	if (qhp->attr.mpa_attr.initiator)
 		build_rtr_msg(qhp->attr.mpa_attr.p2p_type, &wqe->u.init);
 
-	c4iw_init_wr_wait(&qhp->ep->com.wr_wait);
 	ret = c4iw_ofld_send(&rhp->rdev, skb);
 	if (ret)
 		goto out;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
