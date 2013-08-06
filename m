From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 4/8] RDMA/cxgb4: Account for unsignled SQ WRs that fails to deal with wrap
Date: Tue,  6 Aug 2013 21:04:36 +0530
Message-ID: <1375803280-7916-5-git-send-email-vipul@chelsio.com>
References: <1375803280-7916-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375803280-7916-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

When determining how many WRs are completed with a signaled CQE,
correctly deal with queue wraps.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cq.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index d84b2c0..4e91168 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -611,9 +611,12 @@ proc_cqe:
 		* to the first unsignaled one, and idx points to the
 		* signaled one.  So adjust in_use based on this delta.
 		* if this is not completing any unsigned wrs, then the
-		* delta will be 0.
+		* delta will be 0. Handle wrapping also!
 		*/
-		wq->sq.in_use -= idx - wq->sq.cidx;
+		if (idx < wq->sq.cidx)
+			wq->sq.in_use -= wq->sq.size + idx - wq->sq.cidx;
+		else
+			wq->sq.in_use -= idx - wq->sq.cidx;
 		BUG_ON(wq->sq.in_use < 0 && wq->sq.in_use < wq->sq.size);
 
 		wq->sq.cidx = (uint16_t)idx;
-- 
1.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
