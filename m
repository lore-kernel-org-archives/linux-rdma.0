From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 18/19 V4] mlx4_core: setting MGM entry size to 512
Date: Thu, 10 Jun 2010 22:09:23 +0300
Message-ID: <4C113863.9090002@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Both Unicast and multicast addresses are using the same table

Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/mlx4.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index 8530032..7a7f787 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -64,7 +64,7 @@ enum {
 };
 
 enum {
-	MLX4_MGM_ENTRY_SIZE	=  0x100,
+	MLX4_MGM_ENTRY_SIZE	=  0x200,
 	MLX4_QP_PER_MGM		= 4 * (MLX4_MGM_ENTRY_SIZE / 16 - 2),
 	MLX4_MTT_ENTRY_PER_SEG	= 8
 };
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
