From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] IB/mlx5: Remove dead code from alloc_cached_mr()
Date: Mon, 27 Jul 2015 14:43:23 -0700
Message-ID: <1438033403-13129-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

The only place that assigns mr inside the loop already does a break.
So "if (mr)" will never be true here since the function initializes mr
to NULL at the top.  We can just drop the extra if and break here.

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index bc9a0de897cb..10d2b213a4d8 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -441,9 +441,6 @@ static struct mlx5_ib_mr *alloc_cached_mr(struct mlx5_ib_dev *dev, int order)
 		spin_unlock_irq(&ent->lock);
 
 		queue_work(cache->wq, &ent->work);
-
-		if (mr)
-			break;
 	}
 
 	if (!mr)
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
