From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH rdma-next 2/3] IB/core: IB/core: Allow legacy verbs through extended interfaces
Date: Sun, 14 Feb 2016 17:07:48 +0200
Message-ID: <1455462469-9124-3-git-send-email-leon@leon.nu>
References: <1455462469-9124-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455462469-9124-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When an extended verbs is an extension to a legacy verb, the original
functionality is preserved. Hence we do not require each hardware driver
to set the extended capability. This will allow to use the extended verb
in its simple form with drivers that do not support the extended
capability.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 08f1a7b..20f0049 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -683,6 +683,21 @@ out:
 	return ev_file;
 }
 
+static int verify_command_mask(struct ib_device *ib_dev, __u32 command)
+{
+	u64 mask;
+
+	if (command <= IB_USER_VERBS_CMD_OPEN_QP)
+		mask = ib_dev->uverbs_cmd_mask;
+	else
+		mask = ib_dev->uverbs_ex_cmd_mask;
+
+	if (mask & ((u64)1 << command))
+		return 0;
+
+	return -1;
+}
+
 static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 			     size_t count, loff_t *pos)
 {
@@ -715,6 +730,10 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	}
 
 	command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
+	if (verify_command_mask(ib_dev, command)) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
 
 	flags = (hdr.command &
 		 IB_USER_VERBS_CMD_FLAGS_MASK) >> IB_USER_VERBS_CMD_FLAGS_SHIFT;
@@ -732,11 +751,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 			goto out;
 		}
 
-		if (!(ib_dev->uverbs_cmd_mask & (1ull << command))) {
-			ret = -ENOSYS;
-			goto out;
-		}
-
 		if (hdr.in_words * 4 != count) {
 			ret = -EINVAL;
 			goto out;
@@ -764,11 +778,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 			goto out;
 		}
 
-		if (!(ib_dev->uverbs_ex_cmd_mask & (1ull << command))) {
-			ret = -ENOSYS;
-			goto out;
-		}
-
 		if (count < (sizeof(hdr) + sizeof(ex_hdr))) {
 			ret = -EINVAL;
 			goto out;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
