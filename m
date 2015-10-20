From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH for-next 4/5] RDMA/ocrdma: Prevent CQ-Doorbell floods
Date: Tue, 20 Oct 2015 14:17:59 +0530
Message-ID: <1445330880-3912-5-git-send-email-selvin.xavier@avagotech.com>
References: <1445330880-3912-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445330880-3912-1-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

Changing CQ-Doorbell(DB) logic to prevent DB floods, it is supposed to be
pressed only if any hw CQE is polled. If cq-arm was requested
previously then don't bother about number of hw CQEs polled and
arm the CQ.

Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 1f3affb..1c4e83d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -2933,16 +2933,11 @@ expand_cqe:
 	}
 stop_cqe:
 	cq->getp = cur_getp;
-	if (cq->deferred_arm) {
-		ocrdma_ring_cq_db(dev, cq->id, true, cq->deferred_sol,
-				  polled_hw_cqes);
+	if (cq->deferred_arm || polled_hw_cqes) {
+		ocrdma_ring_cq_db(dev, cq->id, cq->deferred_arm,
+				  cq->deferred_sol, polled_hw_cqes);
 		cq->deferred_arm = false;
 		cq->deferred_sol = false;
-	} else {
-		/* We need to pop the CQE. No need to arm */
-		ocrdma_ring_cq_db(dev, cq->id, false, cq->deferred_sol,
-				  polled_hw_cqes);
-		cq->deferred_sol = false;
 	}
 
 	return i;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
