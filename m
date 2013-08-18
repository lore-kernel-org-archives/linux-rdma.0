From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/22] ucm: changes ib_ucm_path_get() src arg to be a pointer
Date: Sun, 18 Aug 2013 20:28:43 +0200
Message-ID: <662a8b92d9bd5bef52e90173ecda1cbfcbc4beb5.1376847403.git.ydroneaud@opteya.com>
References: <cover.1376847403.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ib_icm_path_get() is a function that read data from userspace buffer.
This patch makes 'src' argument to be an explicit pointer
to userspace buffer, so that static analysis won't get fooled
by 'src' being currently an integer without annotation.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/ucm.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index d336a1b..b53e59b 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -702,7 +702,7 @@ static int ib_ucm_alloc_data(const void **dest, const void __user *src, u32 len)
 	return 0;
 }
 
-static int ib_ucm_path_get(struct ib_sa_path_rec **path, u64 src)
+static int ib_ucm_path_get(struct ib_sa_path_rec **path, const void __user *src)
 {
 	struct ib_user_path_rec upath;
 	struct ib_sa_path_rec  *sa_path;
@@ -716,8 +716,7 @@ static int ib_ucm_path_get(struct ib_sa_path_rec **path, u64 src)
 	if (!sa_path)
 		return -ENOMEM;
 
-	if (copy_from_user(&upath, (void __user *)(unsigned long)src,
-			   sizeof(upath))) {
+	if (copy_from_user(&upath, src, sizeof(upath))) {
 
 		kfree(sa_path);
 		return -EFAULT;
@@ -750,11 +749,13 @@ static ssize_t ib_ucm_send_req(struct ib_ucm_file *file,
 	if (result)
 		goto done;
 
-	result = ib_ucm_path_get(&param.primary_path, cmd.primary_path);
+	result = ib_ucm_path_get(&param.primary_path,
+				 (const void __user *)(unsigned long)cmd.primary_path);
 	if (result)
 		goto done;
 
-	result = ib_ucm_path_get(&param.alternate_path, cmd.alternate_path);
+	result = ib_ucm_path_get(&param.alternate_path,
+				 (const void __user *)(unsigned long)cmd.alternate_path);
 	if (result)
 		goto done;
 
@@ -988,7 +989,8 @@ static ssize_t ib_ucm_send_lap(struct ib_ucm_file *file,
 	if (result)
 		goto done;
 
-	result = ib_ucm_path_get(&path, cmd.path);
+	result = ib_ucm_path_get(&path,
+				 (const void __user *)(unsigned long)cmd.path);
 	if (result)
 		goto done;
 
@@ -1026,7 +1028,8 @@ static ssize_t ib_ucm_send_sidr_req(struct ib_ucm_file *file,
 	if (result)
 		goto done;
 
-	result = ib_ucm_path_get(&param.path, cmd.path);
+	result = ib_ucm_path_get(&param.path,
+				 (const void __user *)(unsigned long)cmd.path);
 	if (result)
 		goto done;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
