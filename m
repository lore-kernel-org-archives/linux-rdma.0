From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 03/15] IB/uverbs: Always the attribute size provided by the user
Date: Tue, 13 Feb 2018 12:18:29 +0200
Message-ID: <20180213101841.20101-4-leon@kernel.org>
References: <20180213101841.20101-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213101841.20101-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This fixes several bugs around the copy_to/from user path:
 - copy_to used the user provided size of the attribute
   and could copy data beyond the end of the kernel buffer into
   userspace.
 - copy_from didn't know the size of the kernel buffer and
   could have left kernel memory unexpectedly un-initialized.
 - copy_from did not use the user length to determine if the
   attribute data is inlined or not.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_std_types.c |  5 +++--
 include/rdma/uverbs_ioctl.h                | 35 ++++++++++++++++++++++++------
 2 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index cab0ac3556eb..c6502c7b7c46 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -323,7 +323,8 @@ static int uverbs_create_cq_handler(struct ib_device *ib_dev,
 	cq->res.type = RDMA_RESTRACK_CQ;
 	rdma_restrack_add(&cq->res);
 
-	ret = uverbs_copy_to(attrs, CREATE_CQ_RESP_CQE, &cq->cqe);
+	ret = uverbs_copy_to(attrs, CREATE_CQ_RESP_CQE, &cq->cqe,
+			     sizeof(cq->cqe));
 	if (ret)
 		goto err_cq;
 
@@ -375,7 +376,7 @@ static int uverbs_destroy_cq_handler(struct ib_device *ib_dev,
 	resp.comp_events_reported  = obj->comp_events_reported;
 	resp.async_events_reported = obj->async_events_reported;
 
-	return uverbs_copy_to(attrs, DESTROY_CQ_RESP, &resp);
+	return uverbs_copy_to(attrs, DESTROY_CQ_RESP, &resp, sizeof(resp));
 }
 
 static DECLARE_UVERBS_METHOD(
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 6da44079aa58..32cb14703914 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -351,29 +351,50 @@ static inline const struct uverbs_attr *uverbs_attr_get(const struct uverbs_attr
 }
 
 static inline int uverbs_copy_to(const struct uverbs_attr_bundle *attrs_bundle,
-				 size_t idx, const void *from)
+				 size_t idx, const void *from, size_t size)
 {
 	const struct uverbs_attr *attr = uverbs_attr_get(attrs_bundle, idx);
 	u16 flags;
+	size_t min_size;
 
 	if (IS_ERR(attr))
 		return PTR_ERR(attr);
 
+	min_size = min_t(size_t, attr->ptr_attr.len, size);
+	if (copy_to_user(attr->ptr_attr.ptr, from, min_size))
+		return -EFAULT;
+
 	flags = attr->ptr_attr.flags | UVERBS_ATTR_F_VALID_OUTPUT;
-	return (!copy_to_user(attr->ptr_attr.ptr, from, attr->ptr_attr.len) &&
-		!put_user(flags, &attr->uattr->flags)) ? 0 : -EFAULT;
+	if (put_user(flags, &attr->uattr->flags))
+		return -EFAULT;
+
+	return 0;
 }
 
-static inline int _uverbs_copy_from(void *to, size_t to_size,
+static inline bool uverbs_attr_ptr_is_inline(const struct uverbs_attr *attr)
+{
+	return attr->ptr_attr.len <= sizeof(attr->ptr_attr.data);
+}
+
+static inline int _uverbs_copy_from(void *to,
 				    const struct uverbs_attr_bundle *attrs_bundle,
-				    size_t idx)
+				    size_t idx,
+				    size_t size)
 {
 	const struct uverbs_attr *attr = uverbs_attr_get(attrs_bundle, idx);
 
 	if (IS_ERR(attr))
 		return PTR_ERR(attr);
 
-	if (to_size <= sizeof(((struct ib_uverbs_attr *)0)->data))
+	/*
+	 * Validation ensures attr->ptr_attr.len >= size. If the caller is
+	 * using UVERBS_ATTR_SPEC_F_MIN_SZ then it must call copy_from with
+	 * the right size.
+	 */
+	if (unlikely(size < attr->ptr_attr.len))
+		return -EINVAL;
+
+	if (uverbs_attr_ptr_is_inline(attr))
 		memcpy(to, &attr->ptr_attr.data, attr->ptr_attr.len);
 	else if (copy_from_user(to, attr->ptr_attr.ptr, attr->ptr_attr.len))
 		return -EFAULT;
@@ -382,7 +403,7 @@ static inline int _uverbs_copy_from(void *to, size_t to_size,
 }
 
 #define uverbs_copy_from(to, attrs_bundle, idx)				      \
-	_uverbs_copy_from(to, sizeof(*(to)), attrs_bundle, idx)
+	_uverbs_copy_from(to, attrs_bundle, idx, sizeof(*to))
 
 /* =================================================
  *	 Definitions -> Specs infrastructure
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
