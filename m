From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 03/11] RDMA/cxgb4: CQ size must be IQ size - 2.
Date: Thu, 20 May 2010 16:57:38 -0500
Message-ID: <20100520215738.32394.60360.stgit@build.ogc.int>
References: <20100520215727.32394.90669.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100520215727.32394.90669.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

1 for the status page
1 to always have 1 free entry to detect full.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cq.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index fb1aafc..46ac00f 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -780,6 +780,9 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
 	/* account for the status page. */
 	entries++;
 
+	/* IQ needs one extra entry to differentiate full vs empty. */
+	entries++;
+
 	/*
 	 * entries must be multiple of 16 for HW.
 	 */
@@ -801,7 +804,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
 
 	chp->rhp = rhp;
 	chp->cq.size--;				/* status page */
-	chp->ibcq.cqe = chp->cq.size;
+	chp->ibcq.cqe = chp->cq.size - 1;
 	spin_lock_init(&chp->lock);
 	atomic_set(&chp->refcnt, 1);
 	init_waitqueue_head(&chp->wait);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
