From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 04/15] IB/uverbs: Use inline data transfer for UHW_IN
Date: Tue, 13 Feb 2018 12:18:30 +0200
Message-ID: <20180213101841.20101-5-leon@kernel.org>
References: <20180213101841.20101-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213101841.20101-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The rule for the API is pointers less than 8 bytes are inlined into
the .data field of the attribute. Fix the creation of the driver udata
struct to follow this rule and point to the .data itself when the size
is less than 8 bytes.

Otherwise if the UHW struct is less than 8 bytes the driver will get
EFAULT during copy_from_user.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_std_types.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index c6502c7b7c46..7b0e4d778d79 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -234,8 +234,11 @@ static void create_udata(struct uverbs_attr_bundle *ctx,
 		uverbs_attr_get(ctx, UVERBS_UHW_OUT);
 
 	if (!IS_ERR(uhw_in)) {
-		udata->inbuf = uhw_in->ptr_attr.ptr;
 		udata->inlen = uhw_in->ptr_attr.len;
+		if (uverbs_attr_ptr_is_inline(uhw_in))
+			udata->inbuf = &uhw_in->uattr->data;
+		else
+			udata->inbuf = uhw_in->ptr_attr.ptr;
 	} else {
 		udata->inbuf = NULL;
 		udata->inlen = 0;
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
