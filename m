From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V2 8/9] IB/core: Export vendor specific structures
Date: Thu, 22 Sep 2016 17:31:18 +0300
Message-ID: <1474554679-21953-9-git-send-email-leon@kernel.org>
References: <1474554679-21953-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474554679-21953-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Export following drivers:
 * mlx5, mlx4, cxgb3, cxgb4, ocrdma, nes and mthca.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/uapi/rdma/Kbuild | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/uapi/rdma/Kbuild b/include/uapi/rdma/Kbuild
index 4edb0f2..5579a97 100644
--- a/include/uapi/rdma/Kbuild
+++ b/include/uapi/rdma/Kbuild
@@ -7,3 +7,10 @@ header-y += rdma_netlink.h
 header-y += rdma_user_cm.h
 header-y += hfi/
 header-y += rdma_user_rxe.h
+header-y += mlx4-abi.h
+header-y += mlx5-abi.h
+header-y += cxgb3-abi.h
+header-y += cxgb4-abi.h
+header-y += ocrdma-abi.h
+header-y += nes-abi.h
+header-y += mthca-abi.h
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
