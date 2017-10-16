From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH] RDMA/uverbs: Make the code in ib_uverbs_cmd_verbs() less confusing
Date: Mon, 16 Oct 2017 08:47:45 -0700
Message-ID: <20171016154745.10033-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch reduces the number of #ifdefs and also avoids that
smatch reports the following:

drivers/infiniband/core/uverbs_ioctl.c:276: ib_uverbs_cmd_verbs() warn: if statement not indented
drivers/infiniband/core/uverbs_ioctl.c:280: ib_uverbs_cmd_verbs() warn: possible memory leak of 'ctx'
drivers/infiniband/core/uverbs_ioctl.c:315: ib_uverbs_cmd_verbs() warn: if statement not indented

References: commit fac9658cabb9 ("IB/core: Add new ioctl interface")
Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Acked-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_ioctl.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
index 5286ad57d903..71ff2644e053 100644
--- a/drivers/infiniband/core/uverbs_ioctl.c
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -241,9 +241,7 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
 	struct uverbs_attr *curr_attr;
 	unsigned long *curr_bitmap;
 	size_t ctx_size;
-#ifdef UVERBS_OPTIMIZE_USING_STACK_SZ
 	uintptr_t data[UVERBS_OPTIMIZE_USING_STACK_SZ / sizeof(uintptr_t)];
-#endif
 
 	if (hdr->reserved)
 		return -EINVAL;
@@ -269,13 +267,10 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
 			(method_spec->num_child_attrs / BITS_PER_LONG +
 			 method_spec->num_buckets);
 
-#ifdef UVERBS_OPTIMIZE_USING_STACK_SZ
 	if (ctx_size <= UVERBS_OPTIMIZE_USING_STACK_SZ)
 		ctx = (void *)data;
-
 	if (!ctx)
-#endif
-	ctx = kmalloc(ctx_size, GFP_KERNEL);
+		ctx = kmalloc(ctx_size, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
@@ -311,10 +306,8 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
 	err = uverbs_handle_method(buf, ctx->uattrs, hdr->num_attrs, ib_dev,
 				   file, method_spec, ctx->uverbs_attr_bundle);
 out:
-#ifdef UVERBS_OPTIMIZE_USING_STACK_SZ
-	if (ctx_size > UVERBS_OPTIMIZE_USING_STACK_SZ)
-#endif
-	kfree(ctx);
+	if (ctx != (void *)data)
+		kfree(ctx);
 	return err;
 }
 
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
