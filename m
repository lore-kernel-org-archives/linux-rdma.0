From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH 3/4] RDMA/libocrdma: Prevent CQ-Doorbell floods
Date: Mon,  2 Nov 2015 01:37:24 -0500
Message-ID: <1446446245-534-4-git-send-email-devesh.sharma@avagotech.com>
References: <1446446245-534-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446446245-534-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Changing CQ-Doorbell(DB) logic to prevent DB floods, it is supposed to be
pressed only if any hw CQE is polled. If cq-arm was requested
previously then don't bother about number of hw CQEs polled and
arm the CQ.

Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 src/ocrdma_verbs.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/src/ocrdma_verbs.c b/src/ocrdma_verbs.c
index d80ab27..cf6f72c 100644
--- a/src/ocrdma_verbs.c
+++ b/src/ocrdma_verbs.c
@@ -2003,14 +2003,11 @@ expand_cqe:
 	}
 stop_cqe:
 	cq->getp = cur_getp;
-	if (cq->deferred_arm) {
-		ocrdma_ring_cq_db(cq, 1, cq->deferred_sol, polled_hw_cqes);
+	if (cq->deferred_arm || polled_hw_cqes) {
+		ocrdma_ring_cq_db(cq, cq->deferred_arm,
+				  cq->deferred_sol, polled_hw_cqes);
 		cq->deferred_arm = 0;
 		cq->deferred_sol = 0;
-	} else {
-		/* We need to pop the CQE. No need to arm */
-		ocrdma_ring_cq_db(cq, 0, cq->deferred_sol, polled_hw_cqes);
-		cq->deferred_sol = 0;
 	}
 
 	return i;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
