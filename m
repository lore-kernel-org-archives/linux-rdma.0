From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/24] IB/qib: generate completion callback on errors
Date: Tue, 28 Dec 2010 10:27:16 -0500
Message-ID: <20101228152716.19960.89671.stgit@kop-dev-sles11-04.qlogic.org>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101228152648.19960.84006.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

According to IBTA vol. 1, C11-30.1.1, a notification callback is
invoked if the CQ is armed for the next solicited completion event
or an error completion. The error case wasn't being generated
previously.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_cq.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_cq.c b/drivers/infiniband/hw/qib/qib_cq.c
index a86cbf8..5246aa4 100644
--- a/drivers/infiniband/hw/qib/qib_cq.c
+++ b/drivers/infiniband/hw/qib/qib_cq.c
@@ -100,7 +100,8 @@ void qib_cq_enter(struct qib_cq *cq, struct ib_wc *entry, int solicited)
 	wc->head = next;
 
 	if (cq->notify == IB_CQ_NEXT_COMP ||
-	    (cq->notify == IB_CQ_SOLICITED && solicited)) {
+	    (cq->notify == IB_CQ_SOLICITED &&
+	     (solicited || entry->status != IB_WC_SUCCESS))) {
 		cq->notify = IB_CQ_NONE;
 		cq->triggered++;
 		/*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
