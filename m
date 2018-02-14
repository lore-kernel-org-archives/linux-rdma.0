From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 07/14] RDMA/uverbs: Refactor command header processing
Date: Wed, 14 Feb 2018 14:38:37 +0200
Message-ID: <20180214123844.30321-8-leon@kernel.org>
References: <20180214123844.30321-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180214123844.30321-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Move all command header processing into separate function
and perform those checks before acquiring SRCU read lock.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 62 ++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 90e0b16aed1a..50d43c300112 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -660,6 +660,29 @@ static bool verify_command_idx(__u32 command, bool extended)
 	       uverbs_cmd_table[command];
 }
 
+static ssize_t process_hdr(struct ib_uverbs_cmd_hdr *hdr,
+			   __u32 *command, bool *extended)
+{
+	__u32 flags;
+
+	if (hdr->command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
+				   IB_USER_VERBS_CMD_COMMAND_MASK))
+		return -EINVAL;
+
+	*command = hdr->command & IB_USER_VERBS_CMD_COMMAND_MASK;
+	flags = (hdr->command &
+		 IB_USER_VERBS_CMD_FLAGS_MASK) >> IB_USER_VERBS_CMD_FLAGS_SHIFT;
+
+	*extended = flags & IB_USER_VERBS_CMD_FLAG_EXTENDED;
+	if (flags & ~IB_USER_VERBS_CMD_FLAG_EXTENDED)
+		return -EINVAL;
+
+	if (!verify_command_idx(*command, *extended))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 			     size_t count, loff_t *pos)
 {
@@ -667,9 +690,8 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	struct ib_uverbs_ex_cmd_hdr ex_hdr;
 	struct ib_device *ib_dev;
 	struct ib_uverbs_cmd_hdr hdr;
-	bool extended_command;
+	bool extended;
 	__u32 command;
-	__u32 flags;
 	int srcu_key;
 	ssize_t ret;
 
@@ -685,6 +707,13 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	if (copy_from_user(&hdr, buf, sizeof(hdr)))
 		return -EFAULT;
 
+	ret = process_hdr(&hdr, &command, &extended);
+	if (ret)
+		return ret;
+
+	if (extended && count < (sizeof(hdr) + sizeof(ex_hdr)))
+		return -EINVAL;
+
 	srcu_key = srcu_read_lock(&file->device->disassociate_srcu);
 	ib_dev = srcu_dereference(file->device->ib_dev,
 				  &file->device->disassociate_srcu);
@@ -693,33 +722,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		goto out;
 	}
 
-	if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
-				   IB_USER_VERBS_CMD_COMMAND_MASK)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
-	flags = (hdr.command &
-		 IB_USER_VERBS_CMD_FLAGS_MASK) >> IB_USER_VERBS_CMD_FLAGS_SHIFT;
-
-	extended_command = flags & IB_USER_VERBS_CMD_FLAG_EXTENDED;
-	if (flags & ~IB_USER_VERBS_CMD_FLAG_EXTENDED) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if (extended_command &&
-	    count < (sizeof(hdr) + sizeof(ex_hdr))) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if (!verify_command_idx(command, extended_command)) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-
 	if (!verify_command_mask(ib_dev, command)) {
 		ret = -EOPNOTSUPP;
 		goto out;
@@ -731,7 +733,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		goto out;
 	}
 
-	if (!flags) {
+	if (!extended) {
 		if (hdr.in_words * 4 != count) {
 			ret = -EINVAL;
 			goto out;
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
