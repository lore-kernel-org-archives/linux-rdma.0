From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/22] ucm: changes ib_ucm_alloc_data() src arg to be a pointer
Date: Sun, 18 Aug 2013 20:28:42 +0200
Message-ID: <ff9087ecefcf4a8dc67c8cb912851dec9ffd043d.1376847403.git.ydroneaud@opteya.com>
References: <cover.1376847403.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ib_icm_alloc_data() is a function to allocate a buffer to
copy a userspace provided buffer.
This patch makes 'src' argument to be an explicit pointer
to userspace buffer, so that static analysis won't get fooled
by 'src' being currently an integer without annotation.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/ucm.c | 43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index e462208..d336a1b 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -685,7 +685,7 @@ static ssize_t ib_ucm_notify(struct ib_ucm_file *file,
 	return result;
 }
 
-static int ib_ucm_alloc_data(const void **dest, u64 src, u32 len)
+static int ib_ucm_alloc_data(const void **dest, const void __user *src, u32 len)
 {
 	void *data;
 
@@ -694,7 +694,7 @@ static int ib_ucm_alloc_data(const void **dest, u64 src, u32 len)
 	if (!len)
 		return 0;
 
-	data = memdup_user((void __user *)(unsigned long)src, len);
+	data = memdup_user(src, len);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
@@ -744,7 +744,9 @@ static ssize_t ib_ucm_send_req(struct ib_ucm_file *file,
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
-	result = ib_ucm_alloc_data(&param.private_data, cmd.data, cmd.len);
+	result = ib_ucm_alloc_data(&param.private_data,
+				   (const void __user *)(unsigned long)cmd.data,
+				   cmd.len);
 	if (result)
 		goto done;
 
@@ -800,7 +802,9 @@ static ssize_t ib_ucm_send_rep(struct ib_ucm_file *file,
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
-	result = ib_ucm_alloc_data(&param.private_data, cmd.data, cmd.len);
+	result = ib_ucm_alloc_data(&param.private_data,
+				   (const void __user *)(unsigned long)cmd.data,
+				   cmd.len);
 	if (result)
 		return result;
 
@@ -840,7 +844,9 @@ static ssize_t ib_ucm_send_private_data(struct ib_ucm_file *file,
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
-	result = ib_ucm_alloc_data(&private_data, cmd.data, cmd.len);
+	result = ib_ucm_alloc_data(&private_data,
+				   (const void __user *)(unsigned long)cmd.data,
+				   cmd.len);
 	if (result)
 		return result;
 
@@ -894,11 +900,15 @@ static ssize_t ib_ucm_send_info(struct ib_ucm_file *file,
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
-	result = ib_ucm_alloc_data(&data, cmd.data, cmd.data_len);
+	result = ib_ucm_alloc_data(&data,
+				   (const void __user *)(unsigned long)cmd.data,
+				   cmd.data_len);
 	if (result)
 		goto done;
 
-	result = ib_ucm_alloc_data(&info, cmd.info, cmd.info_len);
+	result = ib_ucm_alloc_data(&info,
+				   (const void __user *)(unsigned long)cmd.info,
+				   cmd.info_len);
 	if (result)
 		goto done;
 
@@ -942,7 +952,9 @@ static ssize_t ib_ucm_send_mra(struct ib_ucm_file *file,
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
-	result = ib_ucm_alloc_data(&data, cmd.data, cmd.len);
+	result = ib_ucm_alloc_data(&data,
+				   (const void __user *)(unsigned long)cmd.data,
+				   cmd.len);
 	if (result)
 		return result;
 
@@ -970,7 +982,9 @@ static ssize_t ib_ucm_send_lap(struct ib_ucm_file *file,
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
-	result = ib_ucm_alloc_data(&data, cmd.data, cmd.len);
+	result = ib_ucm_alloc_data(&data,
+				   (const void __user *)(unsigned long)cmd.data,
+				   cmd.len);
 	if (result)
 		goto done;
 
@@ -1006,7 +1020,9 @@ static ssize_t ib_ucm_send_sidr_req(struct ib_ucm_file *file,
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
-	result = ib_ucm_alloc_data(&param.private_data, cmd.data, cmd.len);
+	result = ib_ucm_alloc_data(&param.private_data,
+				   (const void __user *)(unsigned long)cmd.data,
+				   cmd.len);
 	if (result)
 		goto done;
 
@@ -1047,11 +1063,14 @@ static ssize_t ib_ucm_send_sidr_rep(struct ib_ucm_file *file,
 		return -EFAULT;
 
 	result = ib_ucm_alloc_data(&param.private_data,
-				   cmd.data, cmd.data_len);
+				   (void __user *)(unsigned long)cmd.data,
+				   cmd.data_len);
 	if (result)
 		goto done;
 
-	result = ib_ucm_alloc_data(&param.info, cmd.info, cmd.info_len);
+	result = ib_ucm_alloc_data(&param.info,
+				   (void __user *)(unsigned long)cmd.info,
+				   cmd.info_len);
 	if (result)
 		goto done;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
