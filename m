From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH ib-next 3/3] IB/core: Modify conditional on ucontext existence
Date: Thu,  5 Nov 2015 19:40:08 +0200
Message-ID: <1446745208-17733-4-git-send-email-eli@mellanox.com>
References: <1446745208-17733-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446745208-17733-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since we allow to call legacy verbs using their extended counterpart,
the check on ucontext has to move up to a common area in case this verb
is ever extended.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 1740a03e6ac6..1c31324af7e4 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -724,6 +724,12 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
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
 
@@ -734,12 +740,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
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
2.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
