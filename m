From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/core: Allow legacy verbs through extended interfaces
Date: Wed, 4 Nov 2015 21:36:21 +0200
Message-ID: <20151104193621.GA30146@x-vnc01.mtx.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When an extended verbs is an extension to a legacy verb, the original
functionality is preserved. Hence we do not require each hardware driver
to set the extended capability. This will allow to use the extended verb
in its simple form with drivers that do not support the extended
capability.

In addition, avoid code duplication by moving sanity checks to a common
area.

Change-Id: Iedba714224fa07b85325c146621c07e0dbf349fb
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index e3ef28861be6..0ae934d81b04 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -678,6 +678,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	struct ib_uverbs_file *file = filp->private_data;
 	struct ib_device *ib_dev;
 	struct ib_uverbs_cmd_hdr hdr;
+	__u32 command;
 	__u32 flags;
 	int srcu_key;
 	ssize_t ret;
@@ -699,17 +700,15 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	flags = (hdr.command &
 		 IB_USER_VERBS_CMD_FLAGS_MASK) >> IB_USER_VERBS_CMD_FLAGS_SHIFT;
 
-	if (!flags) {
-		__u32 command;
-
-		if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
-					   IB_USER_VERBS_CMD_COMMAND_MASK)) {
-			ret = -EINVAL;
-			goto out;
-		}
+	if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
+				   IB_USER_VERBS_CMD_COMMAND_MASK)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-		command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
+	command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
 
+	if (!flags) {
 		if (command >= ARRAY_SIZE(uverbs_cmd_table) ||
 		    !uverbs_cmd_table[command]) {
 			ret = -EINVAL;
@@ -738,21 +737,11 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
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
@@ -764,7 +753,8 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 			goto out;
 		}
 
-		if (!(ib_dev->uverbs_ex_cmd_mask & (1ull << command))) {
+		if ((command > IB_USER_VERBS_CMD_OPEN_QP) &&
+		    !(ib_dev->uverbs_ex_cmd_mask & (1ull << command))) {
 			ret = -ENOSYS;
 			goto out;
 		}
-- 
2.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
