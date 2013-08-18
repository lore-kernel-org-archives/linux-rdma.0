From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 08/22] ucm: check userspace input length
Date: Sun, 18 Aug 2013 20:28:44 +0200
Message-ID: <254b9fcdfbee703e8f5fe33fc2e8b280018263c1.1376847403.git.ydroneaud@opteya.com>
References: <cover.1376847403.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Makes ucm functions check the length of the input buffer
before reading the command content: this will detect
truncated command and will prevent ucm from reading past
userspace provided buffer.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/ucm.c | 45 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index b53e59b..7a35520 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -390,6 +390,9 @@ static ssize_t ib_ucm_event(struct ib_ucm_file *file,
 	struct ib_ucm_event *uevent;
 	int result = 0;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (out_len < sizeof(struct ib_ucm_event_resp))
 		return -ENOSPC;
 
@@ -475,6 +478,9 @@ static ssize_t ib_ucm_create_id(struct ib_ucm_file *file,
 	struct ib_ucm_context *ctx;
 	int result;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
 
@@ -522,6 +528,9 @@ static ssize_t ib_ucm_destroy_id(struct ib_ucm_file *file,
 	struct ib_ucm_context *ctx;
 	int result = 0;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
 
@@ -567,6 +576,9 @@ static ssize_t ib_ucm_attr_id(struct ib_ucm_file *file,
 	struct ib_ucm_context *ctx;
 	int result = 0;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
 
@@ -600,6 +612,9 @@ static ssize_t ib_ucm_init_qp_attr(struct ib_ucm_file *file,
 	struct ib_qp_attr qp_attr;
 	int result = 0;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
 
@@ -647,6 +662,9 @@ static ssize_t ib_ucm_listen(struct ib_ucm_file *file,
 	struct ib_ucm_context *ctx;
 	int result;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -673,6 +691,9 @@ static ssize_t ib_ucm_notify(struct ib_ucm_file *file,
 	struct ib_ucm_context *ctx;
 	int result;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -740,6 +761,9 @@ static ssize_t ib_ucm_send_req(struct ib_ucm_file *file,
 	param.primary_path   = NULL;
 	param.alternate_path = NULL;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -800,6 +824,9 @@ static ssize_t ib_ucm_send_rep(struct ib_ucm_file *file,
 
 	param.private_data = NULL;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -842,6 +869,9 @@ static ssize_t ib_ucm_send_private_data(struct ib_ucm_file *file,
 	const void *private_data = NULL;
 	int result;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -898,6 +928,9 @@ static ssize_t ib_ucm_send_info(struct ib_ucm_file *file,
 	const void *info = NULL;
 	int result;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -950,6 +983,9 @@ static ssize_t ib_ucm_send_mra(struct ib_ucm_file *file,
 	const void *data = NULL;
 	int result;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -980,6 +1016,9 @@ static ssize_t ib_ucm_send_lap(struct ib_ucm_file *file,
 	const void *data = NULL;
 	int result;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -1019,6 +1058,9 @@ static ssize_t ib_ucm_send_sidr_req(struct ib_ucm_file *file,
 	param.private_data = NULL;
 	param.path = NULL;
 
+	if (in_len < sizeof(cmd))
+		return -EINVAL;
+
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
@@ -1062,6 +1104,9 @@ static ssize_t ib_ucm_send_sidr_rep(struct ib_ucm_file *file,
 
 	param.info = NULL;
 
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
