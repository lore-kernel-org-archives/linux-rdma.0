From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 8/8] MAINTAINERS: Update RDMA vendor specific UAPI files
Date: Sun, 18 Sep 2016 13:50:23 +0300
Message-ID: <1474195823-10429-9-git-send-email-leon@kernel.org>
References: <1474195823-10429-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474195823-10429-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Update following drivers:
 * mlx5, mlx4, cxgb3, cxgb4, ocrdma and nes.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index db814a8..b2f8b9f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3461,6 +3461,7 @@ L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 W:	http://www.openfabrics.org
 S:	Supported
 F:	drivers/infiniband/hw/cxgb3/
+F:	include/uapi/rdma/cxgb3-abi.h
 
 CXGB4 ETHERNET DRIVER (CXGB4)
 M:	Hariprasad S <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
@@ -3482,6 +3483,7 @@ L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 W:	http://www.openfabrics.org
 S:	Supported
 F:	drivers/infiniband/hw/cxgb4/
+F:	include/uapi/rdma/cxgb4-abi.h
 
 CXGB4VF ETHERNET DRIVER (CXGB4VF)
 M:	Casey Leedom <leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
@@ -7807,6 +7809,7 @@ Q:	http://patchwork.kernel.org/project/linux-rdma/list/
 S:	Supported
 F:	drivers/infiniband/hw/mlx4/
 F:	include/linux/mlx4/
+F:	include/uapi/rdma/mlx4-abi.h
 
 MELLANOX MLX5 core VPI driver
 M:	Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
@@ -7828,6 +7831,7 @@ Q:	http://patchwork.kernel.org/project/linux-rdma/list/
 S:	Supported
 F:	drivers/infiniband/hw/mlx5/
 F:	include/linux/mlx5/
+F:	include/uapi/rdma/mlx5-abi.h
 
 MELEXIS MLX90614 DRIVER
 M:	Crt Mori <cmo-fc6wVz46lShBDgjK7y7TUQ@public.gmane.org>
@@ -8081,6 +8085,7 @@ L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 W:	http://www.intel.com/Products/Server/Adapters/Server-Cluster/Server-Cluster-overview.htm
 S:	Supported
 F:	drivers/infiniband/hw/nes/
+F:	include/uapi/rdma/nes-abi.h
 
 NETEM NETWORK EMULATOR
 M:	Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
@@ -10595,6 +10600,7 @@ L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 W:	http://www.emulex.com
 S:	Supported
 F:	drivers/infiniband/hw/ocrdma/
+F:	include/uapi/rdma/ocrdma-abi.h
 
 SFC NETWORK DRIVER
 M:	Solarflare linux maintainers <linux-net-drivers-s/n/eUQHGBpZroRs9YW3xA@public.gmane.org>
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
