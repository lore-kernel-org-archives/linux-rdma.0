From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 6/6] mlx4: Fix typo in byte swap direction
Date: Thu,  6 Apr 2017 16:42:25 -0600
Message-ID: <1491518545-14746-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1491518545-14746-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491518545-14746-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The two macros are identical, but sparse notices.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/mlx4/cq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/providers/mlx4/cq.c b/providers/mlx4/cq.c
index 844e4da1305c63..f0a47ae374a689 100644
--- a/providers/mlx4/cq.c
+++ b/providers/mlx4/cq.c
@@ -294,7 +294,7 @@ static inline int mlx4_parse_cqe(struct mlx4_cq *cq,
 		*pwr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
 		++wq->tail;
 	} else if (srq) {
-		wqe_index = htobe16(cqe->wqe_index);
+		wqe_index = be16toh(cqe->wqe_index);
 		*pwr_id = srq->wrid[wqe_index];
 		mlx4_free_srq_wqe(srq, wqe_index);
 	} else {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
