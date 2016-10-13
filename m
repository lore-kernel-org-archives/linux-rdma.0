From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 17/17] mlx5: use proper ANSI-C prototypes for functions without arguments
Date: Thu, 13 Oct 2016 21:56:16 +0200
Message-ID: <1476388576-22863-18-git-send-email-hch@lst.de>
References: <1476388576-22863-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476388576-22863-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 providers/mlx5/cq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index 2a53c89..ecfd6eb 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -384,7 +384,7 @@ static enum ibv_wc_status mlx5_handle_error_cqe(struct mlx5_err_cqe *cqe)
 }
 
 #if defined(__x86_64__) || defined (__i386__)
-static inline unsigned long get_cycles()
+static inline unsigned long get_cycles(void)
 {
 	uint32_t low, high;
 	uint64_t val;
@@ -394,7 +394,7 @@ static inline unsigned long get_cycles()
 	return val;
 }
 
-static void mlx5_stall_poll_cq()
+static void mlx5_stall_poll_cq(void)
 {
 	int i;
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
