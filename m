From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] IB/mlx5: Remove dependency on X86
Date: Thu, 13 Feb 2014 20:49:53 +0200
Message-ID: <1392317393-26762-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, michael.neuling-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove dependency of mlx5_ib on X86 arch since there is no such dependency.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/Kconfig b/drivers/infiniband/hw/mlx5/Kconfig
index 8e6aebfaf8a4..10df386c6344 100644
--- a/drivers/infiniband/hw/mlx5/Kconfig
+++ b/drivers/infiniband/hw/mlx5/Kconfig
@@ -1,6 +1,6 @@
 config MLX5_INFINIBAND
 	tristate "Mellanox Connect-IB HCA support"
-	depends on NETDEVICES && ETHERNET && PCI && X86
+	depends on NETDEVICES && ETHERNET && PCI
 	select NET_VENDOR_MELLANOX
 	select MLX5_CORE
 	---help---
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
