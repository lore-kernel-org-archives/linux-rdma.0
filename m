From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH rdma-next 1/3] IB/core: Avoid duplicate code
Date: Sun, 14 Feb 2016 17:07:47 +0200
Message-ID: <1455462469-9124-2-git-send-email-leon@leon.nu>
References: <1455462469-9124-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455462469-9124-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Move the check on the validity of the command to a common area.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 39680ae..08f1a7b 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -689,6 +689,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	struct ib_uverbs_file *file = filp->private_data;
 	struct ib_device *ib_dev;
 	struct ib_uverbs_cmd_hdr hdr;
+	__u32 command;
 	__u32 flags;
 	int srcu_key;
 	ssize_t ret;
@@ -707,20 +708,18 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		goto out;
 	}
 
+	if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
+				   IB_USER_VERBS_CMD_COMMAND_MASK)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
+
 	flags = (hdr.command &
 		 IB_USER_VERBS_CMD_FLAGS_MASK) >> IB_USER_VERBS_CMD_FLAGS_SHIFT;
 
 	if (!flags) {
-		__u32 command;
-
-		if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
-					   IB_USER_VERBS_CMD_COMMAND_MASK)) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
-
 		if (command >= ARRAY_SIZE(uverbs_cmd_table) ||
 		    !uverbs_cmd_table[command]) {
 			ret = -EINVAL;
@@ -749,21 +748,11 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 						 hdr.out_words * 4);
 
 	} else if (flags == IB_USER_VERBS_CMD_FLAG_EXTENDED) {
-		__u32 command;
-
 		struct ib_uverbs_ex_cmd_hdr ex_hdr;
 		struct ib_udata ucore;
 		struct ib_udata uhw;
 		size_t written_count = count;
 
-		if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
-					   IB_USER_VERBS_CMD_COMMAND_MASK)) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
-
 		if (command >= ARRAY_SIZE(uverbs_ex_cmd_table) ||
 		    !uverbs_ex_cmd_table[command]) {
 			ret = -ENOSYS;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
