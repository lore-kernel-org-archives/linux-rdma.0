From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v1 REPOST 04/10] IB/uverbs: Add XRQ creation parameter to UAPI
Date: Thu, 17 Aug 2017 15:52:06 +0300
Message-ID: <20170817125212.3173-5-leon@kernel.org>
References: <20170817125212.3173-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125212.3173-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add tm_list_size parameter to struct ib_uverbs_create_xsrq.
If SRQ type is tag-matching this field defines maximum size
of tag matching list. Otherwise, it is expected to be zero.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yossi Itigin <yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/uapi/rdma/ib_user_verbs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 63656d2e8705..d5434bbf40c8 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -1024,7 +1024,7 @@ struct ib_uverbs_create_xsrq {
 	__u32 max_wr;
 	__u32 max_sge;
 	__u32 srq_limit;
-	__u32 reserved;
+	__u32 max_num_tags;
 	__u32 xrcd_handle;
 	__u32 cq_handle;
 	__u64 driver_data[0];
--
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
