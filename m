From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 05/11] IB/mlx5: Fix post send fence logic
Date: Wed, 22 Jun 2016 17:27:26 +0300
Message-ID: <1466605652-24798-6-git-send-email-leonro@mellanox.com>
References: <1466605652-24798-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466605652-24798-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

If the caller specified IB_SEND_FENCE in the send flags of the work
request and no previous work request stated that the successive one
should be fenced, the work request would be executed without a fence.
This could result in RDMA read or atomic operations failure due to a MR
being invalidated. Fix this by adding the mlx5 enumeration for fencing
RDMA/atomic operations and fix the logic to apply this.

Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 7 ++++---
 include/linux/mlx5/qp.h         | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index ce43422..ce0a7ab 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3332,10 +3332,11 @@ static u8 get_fence(u8 fence, struct ib_send_wr *wr)
 			return MLX5_FENCE_MODE_SMALL_AND_FENCE;
 		else
 			return fence;
-
-	} else {
-		return 0;
+	} else if (unlikely(wr->send_flags & IB_SEND_FENCE)) {
+		return MLX5_FENCE_MODE_FENCE;
 	}
+
+	return 0;
 }
 
 static int begin_wqe(struct mlx5_ib_qp *qp, void **seg,
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 266320f..ab31081 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -172,6 +172,7 @@ enum {
 enum {
 	MLX5_FENCE_MODE_NONE			= 0 << 5,
 	MLX5_FENCE_MODE_INITIATOR_SMALL		= 1 << 5,
+	MLX5_FENCE_MODE_FENCE			= 2 << 5,
 	MLX5_FENCE_MODE_STRONG_ORDERING		= 3 << 5,
 	MLX5_FENCE_MODE_SMALL_AND_FENCE		= 4 << 5,
 };
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
