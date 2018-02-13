From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 05/15] IB/uverbs: Use u64_to_user_ptr() not a union
Date: Tue, 13 Feb 2018 12:18:31 +0200
Message-ID: <20180213101841.20101-6-leon@kernel.org>
References: <20180213101841.20101-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213101841.20101-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The union approach will get the endianness wrong sometimes if the kernel's
pointer size is 32 bits resulting in EFAULTs when trying to copy to/from
user.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_std_types.c |  4 ++--
 include/rdma/uverbs_ioctl.h                | 10 ++++------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index 7b0e4d778d79..df1360e6774f 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -238,14 +238,14 @@ static void create_udata(struct uverbs_attr_bundle *ctx,
 		if (uverbs_attr_ptr_is_inline(uhw_in))
 			udata->inbuf = &uhw_in->uattr->data;
 		else
-			udata->inbuf = uhw_in->ptr_attr.ptr;
+			udata->inbuf = u64_to_user_ptr(uhw_in->ptr_attr.data);
 	} else {
 		udata->inbuf = NULL;
 		udata->inlen = 0;
 	}
 
 	if (!IS_ERR(uhw_out)) {
-		udata->outbuf = uhw_out->ptr_attr.ptr;
+		udata->outbuf = u64_to_user_ptr(uhw_out->ptr_attr.data);
 		udata->outlen = uhw_out->ptr_attr.len;
 	} else {
 		udata->outbuf = NULL;
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 32cb14703914..38287d9d23a1 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -276,10 +276,7 @@ struct uverbs_object_tree_def {
  */
 
 struct uverbs_ptr_attr {
-	union {
-		u64		data;
-		void	__user *ptr;
-	};
+	u64		data;
 	u16		len;
 	/* Combination of bits from enum UVERBS_ATTR_F_XXXX */
 	u16		flags;
@@ -361,7 +358,7 @@ static inline int uverbs_copy_to(const struct uverbs_attr_bundle *attrs_bundle,
 		return PTR_ERR(attr);
 
 	min_size = min_t(size_t, attr->ptr_attr.len, size);
-	if (copy_to_user(attr->ptr_attr.ptr, from, min_size))
+	if (copy_to_user(u64_to_user_ptr(attr->ptr_attr.data), from, min_size))
 		return -EFAULT;
 
 	flags = attr->ptr_attr.flags | UVERBS_ATTR_F_VALID_OUTPUT;
@@ -396,7 +393,8 @@ static inline int _uverbs_copy_from(void *to,
 
 	if (uverbs_attr_ptr_is_inline(attr))
 		memcpy(to, &attr->ptr_attr.data, attr->ptr_attr.len);
-	else if (copy_from_user(to, attr->ptr_attr.ptr, attr->ptr_attr.len))
+	else if (copy_from_user(to, u64_to_user_ptr(attr->ptr_attr.data),
+				attr->ptr_attr.len))
 		return -EFAULT;
 
 	return 0;
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
