From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 07/15] IB/uverbs: Use __aligned_u64 for uapi headers
Date: Tue, 13 Feb 2018 12:18:33 +0200
Message-ID: <20180213101841.20101-8-leon@kernel.org>
References: <20180213101841.20101-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213101841.20101-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This has no impact on the structure layout since these structs already
have their u64s already properly aligned, but it does document that we
have this requirement for 32 bit compatibility.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/uapi/rdma/rdma_user_ioctl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/rdma/rdma_user_ioctl.h b/include/uapi/rdma/rdma_user_ioctl.h
index 03557b5f9aa6..46de0885e800 100644
--- a/include/uapi/rdma/rdma_user_ioctl.h
+++ b/include/uapi/rdma/rdma_user_ioctl.h
@@ -65,7 +65,7 @@ struct ib_uverbs_attr {
 	__u16 len;		/* only for pointers */
 	__u16 flags;		/* combination of UVERBS_ATTR_F_XXXX */
 	__u16 reserved;
-	__u64 data;		/* ptr to command, inline data or idr/fd */
+	__aligned_u64 data;	/* ptr to command, inline data or idr/fd */
 };
 
 struct ib_uverbs_ioctl_hdr {
@@ -73,7 +73,7 @@ struct ib_uverbs_ioctl_hdr {
 	__u16 object_id;
 	__u16 method_id;
 	__u16 num_attrs;
-	__u64 reserved;
+	__aligned_u64 reserved;
 	struct ib_uverbs_attr  attrs[0];
 };
 
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
