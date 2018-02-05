From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/2] net/mlx5: increase async EQ to avoid EQ overrun
Date: Mon,  5 Feb 2018 16:29:51 +0200
Message-ID: <1517840992-29813-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Cc: vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently the async EQ has 256 entries only. It might not be big enough
for the SW to handle all the needed pending events. For example, in case
of many QPs (let's say 1024) connected to a SRQ created using NVMeOF target
and the target goes down, the FW will raise 1024 "last WQE reached" events
and may cause EQ overrun. Increase the EQ to more reasonable size, that beyond
it the FW should be able to delay the event and raise it later on using internal
backpressure mechanism.

Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index e7e7cef..9ce4add 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -51,7 +51,7 @@ enum {
 
 enum {
 	MLX5_NUM_SPARE_EQE	= 0x80,
-	MLX5_NUM_ASYNC_EQE	= 0x100,
+	MLX5_NUM_ASYNC_EQE	= 0x1000,
 	MLX5_NUM_CMD_EQE	= 32,
 	MLX5_NUM_PF_DRAIN	= 64,
 };
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
