From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v2] IB/cq: Don't process more than the given budget
Date: Thu,  9 Mar 2017 01:05:58 +0200
Message-ID: <1489014358-13638-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The caller might not want this overhead.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/core/cq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index 2746d2eb3d52..21d1a38af489 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -29,7 +29,8 @@ static int __ib_process_cq(struct ib_cq *cq, int budget)
 {
 	int i, n, completed = 0;
 
-	while ((n = ib_poll_cq(cq, IB_POLL_BATCH, cq->wc)) > 0) {
+	while ((n = ib_poll_cq(cq, min_t(u32, IB_POLL_BATCH,
+			budget - completed), cq->wc)) > 0) {
 		for (i = 0; i < n; i++) {
 			struct ib_wc *wc = &cq->wc[i];
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
