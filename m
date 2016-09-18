From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 7/8] IB/core: Export vendor specific structures
Date: Sun, 18 Sep 2016 13:50:22 +0300
Message-ID: <1474195823-10429-8-git-send-email-leon@kernel.org>
References: <1474195823-10429-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474195823-10429-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Export following drivers:
 * mlx5, mlx4, cxgb3, cxgb4, ocrdma and nes.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/uapi/rdma/Kbuild | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/rdma/Kbuild b/include/uapi/rdma/Kbuild
index 4edb0f2..c973c88 100644
--- a/include/uapi/rdma/Kbuild
+++ b/include/uapi/rdma/Kbuild
@@ -7,3 +7,9 @@ header-y += rdma_netlink.h
 header-y += rdma_user_cm.h
 header-y += hfi/
 header-y += rdma_user_rxe.h
+header-y += mlx4-abi.h
+header-y += mlx5-abi.h
+header-y += cxgb3-abi.h
+header-y += cxgb4-abi.h
+header-y += ocrdma-abi.h
+header-y += nes-abi.h
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
