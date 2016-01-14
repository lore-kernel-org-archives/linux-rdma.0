From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] net/mlx4: Remove unused macro
Date: Thu, 14 Jan 2016 17:48:07 +0200
Message-ID: <1452786487-30438-1-git-send-email-monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The macro mlx4_foreach_non_ib_transport_port() is not used anywhere. Remove it.

Fixes: aa9a2d51a3e7 ("mlx4: Activate RoCE/SRIOV")
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/linux/mlx4/device.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index f70d210..6309ff1 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -982,10 +982,6 @@ struct mlx4_mad_ifc {
 	for ((port) = 1; (port) <= (dev)->caps.num_ports; (port)++)	\
 		if ((type) == (dev)->caps.port_mask[(port)])
 
-#define mlx4_foreach_non_ib_transport_port(port, dev)                     \
-	for ((port) = 1; (port) <= (dev)->caps.num_ports; (port)++)	  \
-		if (((dev)->caps.port_mask[port] != MLX4_PORT_TYPE_IB))
-
 #define mlx4_foreach_ib_transport_port(port, dev)                         \
 	for ((port) = 1; (port) <= (dev)->caps.num_ports; (port)++)	  \
 		if (((dev)->caps.port_mask[port] == MLX4_PORT_TYPE_IB) || \
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
