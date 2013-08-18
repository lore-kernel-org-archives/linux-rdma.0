From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 19/22] uverbs: check output length
Date: Sun, 18 Aug 2013 20:28:55 +0200
Message-ID: <8fd74e036ebaab25266672aa8097af44c4cb35c3.1376847403.git.ydroneaud@opteya.com>
References: <cover.1376847403.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Makes uverbs functions check the length of the output buffer:
this will prevent uverbs from writing past userspace provided buffer.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs_cmd.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index d0f9854..dc0574f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1359,6 +1359,9 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1427,6 +1430,9 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1506,6 +1512,9 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -1855,6 +1864,9 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2067,6 +2079,9 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2130,6 +2145,9 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2371,6 +2389,9 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2423,6 +2444,9 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
@@ -2975,6 +2999,9 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
