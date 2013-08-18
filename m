From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 12/22] ucma: check userspace input length
Date: Sun, 18 Aug 2013 20:28:48 +0200
Message-ID: <609d01c8b8d1b5fd121222b5fda4072f18239130.1376847403.git.ydroneaud@opteya.com>
References: <cover.1376847403.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Makes ucma functions check the length of the input buffer
before reading the command content: this will detect
truncated command and will prevent ucma from reading past
userspace provided buffer.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/ucma.c | 66 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index b0f189b..9e9e899 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -297,6 +297,9 @@ static ssize_t ucma_get_event(struct ucma_file *file, const char __user *inbuf,
 	struct ucma_event *uevent;
 	int ret = 0;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (out_len < sizeof uevent->resp)
 		return -ENOSPC;
 
@@ -374,6 +377,9 @@ static ssize_t ucma_create_id(struct ucma_file *file, const char __user *inbuf,
 	enum ib_qp_type qp_type;
 	int ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
 
@@ -486,6 +492,9 @@ static ssize_t ucma_destroy_id(struct ucma_file *file, const char __user *inbuf,
 	struct ucma_context *ctx;
 	int ret = 0;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
 
@@ -519,6 +528,9 @@ static ssize_t ucma_bind_ip(struct ucma_file *file, const char __user *inbuf,
 	struct ucma_context *ctx;
 	int ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -539,6 +551,9 @@ static ssize_t ucma_bind(struct ucma_file *file, const char __user *inbuf,
 	struct ucma_context *ctx;
 	int ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -563,6 +578,9 @@ static ssize_t ucma_resolve_ip(struct ucma_file *file,
 	struct ucma_context *ctx;
 	int ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -586,6 +604,9 @@ static ssize_t ucma_resolve_addr(struct ucma_file *file,
 	struct ucma_context *ctx;
 	int ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -612,6 +633,9 @@ static ssize_t ucma_resolve_route(struct ucma_file *file,
 	struct ucma_context *ctx;
 	int ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -708,6 +732,9 @@ static ssize_t ucma_query_route(struct ucma_file *file,
 	struct sockaddr *addr;
 	int ret = 0;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
 
@@ -889,6 +916,9 @@ static ssize_t ucma_query(struct ucma_file *file,
 	void __user *response;
 	int ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -940,6 +970,9 @@ static ssize_t ucma_connect(struct ucma_file *file, const char __user *inbuf,
 	struct ucma_context *ctx;
 	int ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -963,6 +996,9 @@ static ssize_t ucma_listen(struct ucma_file *file, const char __user *inbuf,
 	struct ucma_context *ctx;
 	int ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -985,6 +1021,9 @@ static ssize_t ucma_accept(struct ucma_file *file, const char __user *inbuf,
 	struct ucma_context *ctx;
 	int ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -1013,6 +1052,9 @@ static ssize_t ucma_reject(struct ucma_file *file, const char __user *inbuf,
 	struct ucma_context *ctx;
 	int ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -1032,6 +1074,9 @@ static ssize_t ucma_disconnect(struct ucma_file *file, const char __user *inbuf,
 	struct ucma_context *ctx;
 	int ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -1054,6 +1099,9 @@ static ssize_t ucma_init_qp_attr(struct ucma_file *file,
 	struct ib_qp_attr qp_attr;
 	int ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
 
@@ -1187,6 +1235,9 @@ static ssize_t ucma_set_option(struct ucma_file *file, const char __user *inbuf,
 	void *optval;
 	int ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -1217,6 +1268,9 @@ static ssize_t ucma_notify(struct ucma_file *file, const char __user *inbuf,
 	struct ucma_context *ctx;
 	int ret;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -1295,6 +1349,9 @@ static ssize_t ucma_join_ip_multicast(struct ucma_file *file,
 	struct rdma_ucm_join_ip_mcast cmd;
 	struct rdma_ucm_join_mcast join_cmd;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -1314,6 +1371,9 @@ static ssize_t ucma_join_multicast(struct ucma_file *file,
 {
 	struct rdma_ucm_join_mcast cmd;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -1329,6 +1389,9 @@ static ssize_t ucma_leave_multicast(struct ucma_file *file,
 	struct ucma_multicast *mc;
 	int ret = 0;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
 
@@ -1412,6 +1475,9 @@ static ssize_t ucma_migrate_id(struct ucma_file *new_file,
 	struct ucma_file *cur_file;
 	int ret = 0;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
