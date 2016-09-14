From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC rdma-next 3/3] MAINTAINERS: Add mlx5 uapi file
Date: Wed, 14 Sep 2016 11:27:29 +0300
Message-ID: <1473841649-8923-4-git-send-email-leon@kernel.org>
References: <1473841649-8923-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473841649-8923-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index db814a8..f0b82b9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7828,6 +7828,7 @@ Q:	http://patchwork.kernel.org/project/linux-rdma/list/
 S:	Supported
 F:	drivers/infiniband/hw/mlx5/
 F:	include/linux/mlx5/
+F:	include/uapi/rdma/providers/mlx5-abi.h

 MELEXIS MLX90614 DRIVER
 M:	Crt Mori <cmo-fc6wVz46lShBDgjK7y7TUQ@public.gmane.org>
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
