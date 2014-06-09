From: Devesh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sharma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: [PATCH for-next 2/2] RDMA/ocrdma: do not skip setting deffered_arm
Date: Mon, 9 Jun 2014 10:52:38 +0530
Message-ID: <d3731292-b034-440e-b869-f0a50a2920ed@CMEXHTCAS2.ad.emulex.com>
References: <1402291358-24901-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402291358-24901-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

ib_request_notify_cq() when called for the first time
ocrdma tries to skip setting deffered_arm flag. This
may lead CQ to an un-armed state thus, never generating
CQ event and leaving consumer in hung state.

This patch removes the part of code that skkips setting
deffered_arm flag.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 55aad54..0ac7193 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -2846,11 +2846,9 @@ int ocrdma_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags cq_flags)
 	if (cq->first_arm) {
 		ocrdma_ring_cq_db(dev, cq_id, arm_needed, sol_needed, 0);
 		cq->first_arm = false;
-		goto skip_defer;
 	}
-	cq->deferred_arm = true;
 
-skip_defer:
+	cq->deferred_arm = true;
 	cq->deferred_sol = sol_needed;
 	spin_unlock_irqrestore(&cq->cq_lock, flags);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
