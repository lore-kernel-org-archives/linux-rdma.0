From: Jianchao Wang <jianchao.w.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] net/mlx4_en: ensure rx_desc updating reaches HW before prod db updating
Date: Fri, 12 Jan 2018 11:42:22 +0800
Message-ID: <1515728542-3060-1-git-send-email-jianchao.w.wang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Customer reported memory corruption issue on previous mlx4_en driver
version where the order-3 pages and multiple page reference counting
were still used.

Finally, find out one of the root causes is that the HW may see stale
rx_descs due to prod db updating reaches HW before rx_desc. Especially
when cross order-3 pages boundary and update a new one, HW may write
on the pages which may has been freed and allocated again by others.

To fix it, add a wmb between rx_desc and prod db updating to ensure
the order. Even thougth order-0 and page recycling has been introduced,
the disorder between rx_desc and prod db still could lead to corruption
on different inbound packages.

Signed-off-by: Jianchao Wang <jianchao.w.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 85e28ef..eefa82c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -555,7 +555,7 @@ static void mlx4_en_refill_rx_buffers(struct mlx4_en_priv *priv,
 			break;
 		ring->prod++;
 	} while (likely(--missing));
-
+	wmb(); /* ensure rx_desc updating reaches HW before prod db updating */
 	mlx4_en_update_rx_prod_db(ring);
 }
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
