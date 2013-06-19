From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 4/6] IB/core: Infra-structure to support verbs extensions through uverbs
Date: Wed, 19 Jun 2013 10:47:09 +0300
Message-ID: <1371628031-17546-5-git-send-email-ogerlitz@mellanox.com>
References: <1371628031-17546-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1371628031-17546-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>

Add Infra-structure to support extended uverbs capabilities in a forward/backward
manner. Uverbs command opcodes which are based on the verbs extensions approach should
be greater or equal to IB_USER_VERBS_CMD_THRESHOLD. They have new header format
and processed a bit differently.

Signed-off-by: Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c |   29 ++++++++++++++++++++++++-----
 include/uapi/rdma/ib_user_verbs.h     |   10 ++++++++++
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 2c6f0f2..e4e7b24 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -583,9 +583,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	if (copy_from_user(&hdr, buf, sizeof hdr))
 		return -EFAULT;
 
-	if (hdr.in_words * 4 != count)
-		return -EINVAL;
-
 	if (hdr.command >= ARRAY_SIZE(uverbs_cmd_table) ||
 	    !uverbs_cmd_table[hdr.command])
 		return -EINVAL;
@@ -597,8 +594,30 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	if (!(file->device->ib_dev->uverbs_cmd_mask & (1ull << hdr.command)))
 		return -ENOSYS;
 
-	return uverbs_cmd_table[hdr.command](file, buf + sizeof hdr,
-					     hdr.in_words * 4, hdr.out_words * 4);
+	if (hdr.command >= IB_USER_VERBS_CMD_THRESHOLD) {
+		struct ib_uverbs_cmd_hdr_ex hdr_ex;
+
+		if (copy_from_user(&hdr_ex, buf, sizeof(hdr_ex)))
+			return -EFAULT;
+
+		if (((hdr_ex.in_words + hdr_ex.provider_in_words) * 4) != count)
+			return -EINVAL;
+
+		return uverbs_cmd_table[hdr.command](file,
+						     buf + sizeof(hdr_ex),
+						     (hdr_ex.in_words +
+						      hdr_ex.provider_in_words) * 4,
+						     (hdr_ex.out_words +
+						      hdr_ex.provider_out_words) * 4);
+	} else {
+		if (hdr.in_words * 4 != count)
+			return -EINVAL;
+
+		return uverbs_cmd_table[hdr.command](file,
+						     buf + sizeof(hdr),
+						     hdr.in_words * 4,
+						     hdr.out_words * 4);
+	}
 }
 
 static int ib_uverbs_mmap(struct file *filp, struct vm_area_struct *vma)
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 805711e..61535aa 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -43,6 +43,7 @@
  * compatibility are made.
  */
 #define IB_USER_VERBS_ABI_VERSION	6
+#define IB_USER_VERBS_CMD_THRESHOLD    50
 
 enum {
 	IB_USER_VERBS_CMD_GET_CONTEXT,
@@ -123,6 +124,15 @@ struct ib_uverbs_cmd_hdr {
 	__u16 out_words;
 };
 
+struct ib_uverbs_cmd_hdr_ex {
+	__u32 command;
+	__u16 in_words;
+	__u16 out_words;
+	__u16 provider_in_words;
+	__u16 provider_out_words;
+	__u32 cmd_hdr_reserved;
+};
+
 struct ib_uverbs_get_context {
 	__u64 response;
 	__u64 driver_data[0];
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
