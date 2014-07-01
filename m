From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [for-next 1/4] RDMA/libocrdma: dont skip setting deffer_arm
Date: Tue, 1 Jul 2014 11:24:02 +0530
Message-ID: <164cabce-25f0-4b23-add4-4d5a88368b7d@CMEXHTCAS1.ad.emulex.com>
References: <1404194045-26900-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404194045-26900-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ibv_request_notify_cq() when called for the first time ocrdma tries to skip
setting deffered_arm flag. This may lead CQ to an un-armed state thus, never
generating CQ event and leaving consumer in hung state.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 src/ocrdma_verbs.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/src/ocrdma_verbs.c b/src/ocrdma_verbs.c
index 8e0c344..0f138cf 100644
--- a/src/ocrdma_verbs.c
+++ b/src/ocrdma_verbs.c
@@ -2054,12 +2054,9 @@ int ocrdma_arm_cq(struct ibv_cq *ibcq, int solicited)
 	if (cq->first_arm) {
 		ocrdma_ring_cq_db(cq, 1, solicited, 0);
 		cq->first_arm = 0;
-		goto skip_defer;
 	}
 
 	cq->deferred_arm = 1;
-
-skip_defer:
 	cq->deferred_sol = solicited;
 
 	pthread_spin_unlock(&cq->cq_lock);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
