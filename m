From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 04/11] IB/core: Add scatter FCS flag to use in WQ creation
Date: Wed, 18 Jan 2017 15:39:57 +0200
Message-ID: <20170118134004.5380-5-leon@kernel.org>
References: <20170118134004.5380-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118134004.5380-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add a new creation flag to set the scatter FCS capability of a WQ.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a5fd7ca..1ee8602 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1497,6 +1497,7 @@ struct ib_wq {
 
 enum ib_wq_flags {
 	IB_WQ_FLAGS_CVLAN_STRIPPING	= 1 << 0,
+	IB_WQ_FLAGS_SCATTER_FCS		= 1 << 1,
 };
 
 struct ib_wq_init_attr {
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
