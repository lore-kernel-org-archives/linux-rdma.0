From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 14/17] nes: use NULL instead of 0 for NULL pointers
Date: Thu, 13 Oct 2016 21:56:13 +0200
Message-ID: <1476388576-22863-15-git-send-email-hch@lst.de>
References: <1476388576-22863-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476388576-22863-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 providers/nes/nes_uverbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/providers/nes/nes_uverbs.c b/providers/nes/nes_uverbs.c
index f404ffd..7e7bb90 100644
--- a/providers/nes/nes_uverbs.c
+++ b/providers/nes/nes_uverbs.c
@@ -324,7 +324,7 @@ int nes_ima_upoll_cq(struct ibv_cq *cq, int num_entries, struct ibv_wc *entry)
 	uint32_t head;
 	uint32_t cq_size;
 
-	volatile struct nes_hw_nic_cqe *cqe = 0;
+	volatile struct nes_hw_nic_cqe *cqe = NULL;
 	volatile struct nes_hw_nic_cqe *cqes;
 
 	struct nes_uqp *nesuqp = nesucq->udqp;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
