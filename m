From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 11/29] IB/mlx4: Use kmalloc_array() in three functions
Date: Sat, 18 Feb 2017 21:59:51 +0100
Message-ID: <3002f281-292a-c53e-0b37-d23a3be0d5d7@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1935365a-bd7c-461e-6a84-0c5d3a501fff-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Sat, 18 Feb 2017 10:32:32 +0100

Multiplications for the size determination of memory allocations
indicated that array data structures should be processed.
Thus use the corresponding function "kmalloc_array".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index ba6af84cc236..350c9148340e 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -304,7 +304,9 @@ static int mlx4_ib_add_gid(struct ib_device *device,
 		ctx->refcount++;
 	}
 	if (!ret && hw_update) {
-		gids = kmalloc(sizeof(*gids) * MLX4_MAX_PORT_GIDS, GFP_ATOMIC);
+		gids = kmalloc_array(MLX4_MAX_PORT_GIDS,
+				     sizeof(*gids),
+				     GFP_ATOMIC);
 		if (!gids) {
 			ret = -ENOMEM;
 		} else {
@@ -359,7 +361,9 @@ static int mlx4_ib_del_gid(struct ib_device *device,
 	if (!ret && hw_update) {
 		int i;
 
-		gids = kmalloc(sizeof(*gids) * MLX4_MAX_PORT_GIDS, GFP_ATOMIC);
+		gids = kmalloc_array(MLX4_MAX_PORT_GIDS,
+				     sizeof(*gids),
+				     GFP_ATOMIC);
 		if (!gids) {
 			ret = -ENOMEM;
 		} else {
@@ -2828,9 +2832,9 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 			goto err_counter;
 
 		ibdev->ib_uc_qpns_bitmap =
-			kmalloc(BITS_TO_LONGS(ibdev->steer_qpn_count) *
-				sizeof(long),
-				GFP_KERNEL);
+			kmalloc_array(BITS_TO_LONGS(ibdev->steer_qpn_count),
+				      sizeof(long),
+				      GFP_KERNEL);
 		if (!ibdev->ib_uc_qpns_bitmap)
 			goto err_steer_qp_release;
 
-- 
2.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
