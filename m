From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH] cxgb4: missing dereference in poll_cq
Date: Mon, 10 Oct 2016 17:27:33 +0200
Message-ID: <1476113253-16880-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sparse complains about using plain integer as NULL pointer here, but
I suspect we really want to check the value anyway, and Steve
confirmed that's indeed the case.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 providers/cxgb4/cq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/providers/cxgb4/cq.c b/providers/cxgb4/cq.c
index 1ed7dfd..3c8dd26 100644
--- a/providers/cxgb4/cq.c
+++ b/providers/cxgb4/cq.c
@@ -438,7 +438,7 @@ static int poll_cq(struct t4_wq *wq, struct t4_cq *cq, struct t4_cqe *cqe,
 		if (!*cqe_flushed && CQE_STATUS(hw_cqe))
 			dump_cqe(hw_cqe);
 
-		BUG_ON((cqe_flushed == 0) && !SW_CQE(hw_cqe));
+		BUG_ON((*cqe_flushed == 0) && !SW_CQE(hw_cqe));
 		goto proc_cqe;
 	}
 
-- 
2.10.1.382.ga23ca1b

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
