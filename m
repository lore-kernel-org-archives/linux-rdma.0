From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 21/22] uverbs: fix call to INIT_UDATA with no output buffer
Date: Sun, 18 Aug 2013 20:28:57 +0200
Message-ID: <63bb67dce64ea3eb9583cd84e0275fa1b49d8b23.1376847403.git.ydroneaud@opteya.com>
References: <cover.1376847403.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When using INIT_UDATA() with an output buffer set to NULL,
there's no space available, so output buffer length should be set to 0.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs_cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 5981604..df50e81 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1990,7 +1990,7 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 		return -EFAULT;
 
 	INIT_UDATA(&udata, buf + sizeof cmd, NULL, in_len - sizeof cmd,
-		   out_len);
+		   0);
 
 	attr = kmalloc(sizeof *attr, GFP_KERNEL);
 	if (!attr)
@@ -2927,7 +2927,7 @@ ssize_t ib_uverbs_modify_srq(struct ib_uverbs_file *file,
 		return -EFAULT;
 
 	INIT_UDATA(&udata, buf + sizeof cmd, NULL, in_len - sizeof cmd,
-		   out_len);
+		   0);
 
 	srq = idr_read_srq(cmd.srq_handle, file->ucontext);
 	if (!srq)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
