From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 05/11] IB/hfi1: Remove unnecessary if check
Date: Mon, 06 Nov 2017 06:38:45 -0800
Message-ID: <20171106143843.27539.60460.stgit@scvm10.sc.intel.com>
References: <20171106143510.27539.65950.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171106143510.27539.65950.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A for loop condition of data_iovs in user_sdma_free_request
is unnecessarily repeated before the loop as an if check.

Remove the if enveloping the loop.

Reviewed-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 01b9a9c..833d0b7 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -1428,6 +1428,8 @@ static inline void pq_update(struct hfi1_user_sdma_pkt_q *pq)
 
 static void user_sdma_free_request(struct user_sdma_request *req, bool unpin)
 {
+	int i;
+
 	if (!list_empty(&req->txps)) {
 		struct sdma_txreq *t, *p;
 
@@ -1439,22 +1441,20 @@ static void user_sdma_free_request(struct user_sdma_request *req, bool unpin)
 			kmem_cache_free(req->pq->txreq_cache, tx);
 		}
 	}
-	if (req->data_iovs) {
-		struct sdma_mmu_node *node;
-		int i;
-
-		for (i = 0; i < req->data_iovs; i++) {
-			node = req->iovs[i].node;
-			if (!node)
-				continue;
-
-			if (unpin)
-				hfi1_mmu_rb_remove(req->pq->handler,
-						   &node->rb);
-			else
-				atomic_dec(&node->refcount);
-		}
+
+	for (i = 0; i < req->data_iovs; i++) {
+		struct sdma_mmu_node *node = req->iovs[i].node;
+
+		if (!node)
+			continue;
+
+		if (unpin)
+			hfi1_mmu_rb_remove(req->pq->handler,
+					   &node->rb);
+		else
+			atomic_dec(&node->refcount);
 	}
+
 	kfree(req->tids);
 	clear_bit(req->info.comp_idx, req->pq->req_in_use);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
