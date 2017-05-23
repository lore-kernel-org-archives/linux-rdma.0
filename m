From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 4/4] IB/core: Remove NOIO QP create flag
Date: Tue, 23 May 2017 11:39:53 +0300
Message-ID: <20170523083953.14892-5-leon@kernel.org>
References: <20170523083953.14892-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170523083953.14892-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There are no users for IB_QP_CREATE_USE_GFP_NOIO flag,
so let's remove it.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ba8314ec5768..b07ea8ab1b9b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1056,7 +1056,7 @@ enum ib_qp_create_flags {
 	IB_QP_CREATE_MANAGED_RECV               = 1 << 4,
 	IB_QP_CREATE_NETIF_QP			= 1 << 5,
 	IB_QP_CREATE_SIGNATURE_EN		= 1 << 6,
-	IB_QP_CREATE_USE_GFP_NOIO		= 1 << 7,
+	/* FREE					= 1 << 7, */
 	IB_QP_CREATE_SCATTER_FCS		= 1 << 8,
 	IB_QP_CREATE_CVLAN_STRIPPING		= 1 << 9,
 	/* reserve bits 26-31 for low level drivers' internal use */
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
