From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 for-next 2/4] IB/core: Infrastructure to support verbs extensions through uverbs
Date: Wed, 28 Aug 2013 15:47:53 +0300
Message-ID: <1377694075-29287-3-git-send-email-matanb@mellanox.com>
References: <1377694075-29287-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377694075-29287-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hadar Har-Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>

Add infra-structure to support extended uverbs capabilities in a forward/backward
manner. Uverbs command opcodes which are based on the verbs extensions approach should
be greater or equal to IB_USER_VERBS_CMD_THRESHOLD. They have new header format
and processed a bit differently.

Whenever a specific IB_USER_VERBS_CMD_XXX is extended, which practically means
it needs to have additional arguments, we will be able to add them without creating
a completely new IB_USER_VERBS_CMD_YYY command or bumping the uverbs ABI version.

This patch for itself doesn't provide the whole scheme which is also dependent
on adding a comp_mask field to each extended uverbs command struct.

The new header framework allows for future extension of the CMD arguments
(ib_uverbs_cmd_hdr.in_words, ib_uverbs_cmd_hdr.out_words) for an existing
new command (that is a command that supports the new uverbs command header format
suggested in this patch) w/o bumping ABI version and with maintaining backward
and formward compatibility to new and old libibverbs versions.

In the uverbs command we are passing both uverbs arguments and the provider arguments.
We split the ib_uverbs_cmd_hdr.in_words to ib_uverbs_cmd_hdr.in_words which will now carry only
uverbs input argument struct size and  ib_uverbs_cmd_hdr.provider_in_words that will carry
the provider input argument size. Same goes for the response (the uverbs CMD output argument).

For example take the create_cq call and the mlx4_ib provider:

The uverbs layer gets libibverb's struct ibv_create_cq (named struct ib_uverbs_create_cq
in the kernel), mlx4_ib gets libmlx4's struct mlx4_create_cq (which includes struct
ibv_create_cq and is named struct mlx4_ib_create_cq in the kernel) and
in_words = sizeof(mlx4_create_cq)/4 .

Thus ib_uverbs_cmd_hdr.in_words carry both uverbs plus mlx4_ib input argument sizes,
where uverbs assumes it knows the size of its input argument - struct ibv_create_cq.

Now, if we wish to add a variable to struct ibv_create_cq, we can add a comp_mask field
to the struct which is basically bit field indicating which fields exists in the struct
(as done for the libibverbs API extension), but we need a way to tell what is the total
size of the struct and not assume the struct size is predefined (since we may get different
struct sizes from different user libibverbs versions). So we know at which point the
provider input argument (struct mlx4_create_cq) begins. Same goes for extending the
provider struct mlx4_create_cq. Thus we split the ib_uverbs_cmd_hdr.in_words to
ib_uverbs_cmd_hdr.in_words which will now carry only uverbs input argument struct size and
ib_uverbs_cmd_hdr.provider_in_words that will carry the provider (mlx4_ib) input argument size.

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
