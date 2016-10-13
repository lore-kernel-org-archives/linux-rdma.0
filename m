From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 16/17] mlx5: use NULL instead of 0 for NULL pointers
Date: Thu, 13 Oct 2016 21:56:15 +0200
Message-ID: <1476388576-22863-17-git-send-email-hch@lst.de>
References: <1476388576-22863-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476388576-22863-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 providers/mlx5/mlx5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 4b05dc4..747e242 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -310,7 +310,7 @@ static void mlx5_local_cpu_set(struct ibv_device *ibdev, cpu_set_t *cpu_set)
 			p ++;
 		}
 
-		word = strtoul(p, 0, 16);
+		word = strtoul(p, NULL, 16);
 
 		for (k = 0; word; ++k, word >>= 1)
 			if (word & 1)
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
