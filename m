From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 11/13] IB/hfi1: Restructure hfi1_file_open
Date: Thu, 28 Jul 2016 12:27:35 -0400
Message-ID: <1469723257-27317-12-git-send-email-ira.weiny@intel.com>
References: <1469723257-27317-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469723257-27317-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Rearrange the file open call in prep for new changes.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index b80c8d2ac52b..0522bafb190b 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -168,6 +168,7 @@ static inline int is_valid_mmap(u64 token)
 
 static int hfi1_file_open(struct inode *inode, struct file *fp)
 {
+	struct hfi1_filedata *fd;
 	struct hfi1_devdata *dd = container_of(inode->i_cdev,
 					       struct hfi1_devdata,
 					       user_cdev);
@@ -176,10 +177,15 @@ static int hfi1_file_open(struct inode *inode, struct file *fp)
 	kobject_get(&dd->kobj);
 
 	/* The real work is performed later in assign_ctxt() */
-	fp->private_data = kzalloc(sizeof(struct hfi1_filedata), GFP_KERNEL);
-	if (fp->private_data) /* no cpu affinity by default */
-		((struct hfi1_filedata *)fp->private_data)->rec_cpu_num = -1;
-	return fp->private_data ? 0 : -ENOMEM;
+
+	fd = kzalloc(sizeof(*fd), GFP_KERNEL);
+
+	if (fd) /* no cpu affinity by default */
+		fd->rec_cpu_num = -1;
+
+	fp->private_data = fd;
+
+	return fd ? 0 : -ENOMEM;
 }
 
 static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
