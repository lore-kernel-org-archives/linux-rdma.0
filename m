From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-next 2/2] IB/mlx5: Fix iteration overrun in GSI qps
Date: Sun,  3 Jul 2016 15:28:19 +0300
Message-ID: <1467548899-21923-3-git-send-email-leon@kernel.org>
References: <1467548899-21923-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467548899-21923-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Number of outstanding_pi may overflow and as a result may indicate that
there are no elements in the queue. The effect of doing this is that the
MAD layer will get stuck waiting for completions. The MAD layer will
think that the QP is full - because it didn't receive these completions.

This fix changes it so the outstanding_pi number is increased
with 32-bit wraparound and is not limited to max_send_wr so
that the difference between outstanding_pi and outstanding_ci will
really indicate the number of outstanding completions.

Cc: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Fixes: ea6dc2036224 ('IB/mlx5: Reorder GSI completions')
Signed-off-by: Slava Shwartsman <slavash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/gsi.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/gsi.c b/drivers/infiniband/hw/mlx5/gsi.c
index 53e03c8..79e6309 100644
--- a/drivers/infiniband/hw/mlx5/gsi.c
+++ b/drivers/infiniband/hw/mlx5/gsi.c
@@ -69,15 +69,6 @@ static bool mlx5_ib_deth_sqpn_cap(struct mlx5_ib_dev *dev)
 	return MLX5_CAP_GEN(dev->mdev, set_deth_sqpn);
 }
 
-static u32 next_outstanding(struct mlx5_ib_gsi_qp *gsi, u32 index)
-{
-	return ++index % gsi->cap.max_send_wr;
-}
-
-#define for_each_outstanding_wr(gsi, index) \
-	for (index = gsi->outstanding_ci; index != gsi->outstanding_pi; \
-	     index = next_outstanding(gsi, index))
-
 /* Call with gsi->lock locked */
 static void generate_completions(struct mlx5_ib_gsi_qp *gsi)
 {
@@ -85,8 +76,9 @@ static void generate_completions(struct mlx5_ib_gsi_qp *gsi)
 	struct mlx5_ib_gsi_wr *wr;
 	u32 index;
 
-	for_each_outstanding_wr(gsi, index) {
-		wr = &gsi->outstanding_wrs[index];
+	for (index = gsi->outstanding_ci; index != gsi->outstanding_pi;
+	     index++) {
+		wr = &gsi->outstanding_wrs[index % gsi->cap.max_send_wr];
 
 		if (!wr->completed)
 			break;
@@ -430,8 +422,9 @@ static int mlx5_ib_add_outstanding_wr(struct mlx5_ib_gsi_qp *gsi,
 		return -ENOMEM;
 	}
 
-	gsi_wr = &gsi->outstanding_wrs[gsi->outstanding_pi];
-	gsi->outstanding_pi = next_outstanding(gsi, gsi->outstanding_pi);
+	gsi_wr = &gsi->outstanding_wrs[gsi->outstanding_pi %
+				       gsi->cap.max_send_wr];
+	gsi->outstanding_pi++;
 
 	if (!wc) {
 		memset(&gsi_wr->wc, 0, sizeof(gsi_wr->wc));
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
