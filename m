From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 08/32] IB/rxe: Add maintainer for rxe driver
Date: Wed, 16 Sep 2015 16:42:42 +0300
Message-ID: <1442410986-28232-9-git-send-email-kamalh@mellanox.com>
References: <1442410986-28232-1-git-send-email-kamalh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442410986-28232-1-git-send-email-kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add maintainer for rxe driver

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 23438a1..916bbf1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6644,6 +6644,15 @@ W:	http://www.mellanox.com
 Q:	http://patchwork.ozlabs.org/project/netdev/list/
 F:	drivers/net/ethernet/mellanox/mlx4/en_*
 
+SOFT-ROCE DRIVER (rxe)
+M:      Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+L:      linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+S:      Supported
+W:      https://github.com/SoftRoCE/rxe-dev/wiki/rxe-dev:-Home
+Q:      http://patchwork.kernel.org/project/linux-rdma/list/
+F:      drivers/staging/rxe/
+F:	include/uapi/rdma/ib_rxe.h
+
 MEMORY MANAGEMENT
 L:	linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
 W:	http://www.linux-mm.org
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
