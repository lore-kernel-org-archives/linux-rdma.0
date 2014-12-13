From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mlx4_core: Check DPDP violation only when DPDP is not supported
Date: Sat, 13 Dec 2014 10:18:40 -0800
Message-ID: <1418494720-1997-1-git-send-email-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The check for DPDP moves out of the loop to make the code more correct and readable

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 90de6e1..0f91096 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -170,9 +170,9 @@ int mlx4_check_port_params(struct mlx4_dev *dev,
 {
 	int i;
 
-	for (i = 0; i < dev->caps.num_ports - 1; i++) {
-		if (port_type[i] != port_type[i + 1]) {
-			if (!(dev->caps.flags & MLX4_DEV_CAP_FLAG_DPDP)) {
+	if (!(dev->caps.flags & MLX4_DEV_CAP_FLAG_DPDP))
+		for (i = 0; i < dev->caps.num_ports - 1; i++) {
+			if (port_type[i] != port_type[i + 1]) {
 				mlx4_err(dev, "Only same port types supported on this HCA, aborting\n");
 				return -EINVAL;
 			}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
