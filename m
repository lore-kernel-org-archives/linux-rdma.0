From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI 6/8] IB/core: Add outptr to udata in order to track the output size
Date: Tue, 24 May 2016 17:35:24 +0300
Message-ID: <1464100526-31730-7-git-send-email-leonro@mellanox.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464100526-31730-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Sometimes, a netlink attribute describes a response buffer.
For example, when a vendor writes a response, the uptr netlink
attribute in the core response describe the vendor's response length.
Similarly, the core response length is described by its header, which
is actually a netsted netlink attribute.
Therefore, we need to have a way to count how much data was written
to the udata. Adding an outptr to track this data.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h | 3 +++
 include/rdma/ib_verbs.h          | 8 +++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index a46cb29..c8d8700 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -46,11 +46,13 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_umem.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/ib_user_ioctl.h>
 
 #define INIT_UDATA(udata, ibuf, obuf, ilen, olen)			\
 	do {								\
 		(udata)->inbuf  = (const void __user *) (ibuf);		\
 		(udata)->outbuf = (void __user *) (obuf);		\
+		(udata)->outptr = (void __user *)(obuf);		\
 		(udata)->inlen  = (ilen);				\
 		(udata)->outlen = (olen);				\
 	} while (0)
@@ -59,6 +61,7 @@
 	do {									\
 		(udata)->inbuf  = (ilen) ? (const void __user *) (ibuf) : NULL;	\
 		(udata)->outbuf = (olen) ? (void __user *) (obuf) : NULL;	\
+		(udata)->outptr = (olen) ? (void __user *)(obuf) : NULL;	\
 		(udata)->inlen  = (ilen);					\
 		(udata)->outlen = (olen);					\
 	} while (0)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 1904c02..f5275b9 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1360,6 +1360,7 @@ struct ib_uobject {
 struct ib_udata {
 	const void __user *inbuf;
 	void __user *outbuf;
+	void __user *outptr;
 	size_t       inlen;
 	size_t       outlen;
 };
@@ -1990,7 +1991,12 @@ static inline int ib_copy_from_udata(void *dest, struct ib_udata *udata, size_t
 
 static inline int ib_copy_to_udata(struct ib_udata *udata, void *src, size_t len)
 {
-	return copy_to_user(udata->outbuf, src, len) ? -EFAULT : 0;
+	int ret = copy_to_user(udata->outptr, src, len) ? -EFAULT : 0;
+
+	if (!ret)
+		udata->outptr += len;
+
+	return ret;
 }
 
 static inline bool ib_is_udata_cleared(struct ib_udata *udata,
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
