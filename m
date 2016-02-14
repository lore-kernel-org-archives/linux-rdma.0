From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH rdma-next 3/3] IB/core: Modify conditional on ucontext existence
Date: Sun, 14 Feb 2016 17:07:49 +0200
Message-ID: <1455462469-9124-4-git-send-email-leon@leon.nu>
References: <1455462469-9124-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455462469-9124-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Since we allow to call legacy verbs using their extended counterpart,
the check on ucontext has to move up to a common area in case this verb
is ever extended.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 20f0049..8b299df 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -735,6 +735,12 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		goto out;
 	}
 
+	if (!file->ucontext &&
+	    command != IB_USER_VERBS_CMD_GET_CONTEXT) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	flags = (hdr.command &
 		 IB_USER_VERBS_CMD_FLAGS_MASK) >> IB_USER_VERBS_CMD_FLAGS_SHIFT;
 
@@ -745,12 +751,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 			goto out;
 		}
 
-		if (!file->ucontext &&
-		    command != IB_USER_VERBS_CMD_GET_CONTEXT) {
-			ret = -EINVAL;
-			goto out;
-		}
-
 		if (hdr.in_words * 4 != count) {
 			ret = -EINVAL;
 			goto out;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
