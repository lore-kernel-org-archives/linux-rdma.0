From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 3/3] IB/hfi1: Fix for potential refcount leak in
 hfi1_open_file()
Date: Thu, 01 Feb 2018 10:43:58 -0800
Message-ID: <20180201184355.5205.58682.stgit@scvm10.sc.intel.com>
References: <20180201184229.5205.6194.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180201184229.5205.6194.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael J Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The dd refcount is speculatively incremented prior to allocating
the fd memory with kzalloc(). If that kzalloc() failed the dd
refcount leaks.
Increment refcount on kzalloc success.

Fixes: e11ffbd57520 ("IB/hfi1: Do not free hfi1 cdev parent structure early")
Reviewed-by: Michael J Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 1df7da4..acf0ba5 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -196,9 +196,6 @@ static int hfi1_file_open(struct inode *inode, struct file *fp)
 	if (!atomic_inc_not_zero(&dd->user_refcount))
 		return -ENXIO;
 
-	/* Just take a ref now. Not all opens result in a context assign */
-	kobject_get(&dd->kobj);
-
 	/* The real work is performed later in assign_ctxt() */
 
 	fd = kzalloc(sizeof(*fd), GFP_KERNEL);
@@ -208,6 +205,7 @@ static int hfi1_file_open(struct inode *inode, struct file *fp)
 		fd->mm = current->mm;
 		mmgrab(fd->mm);
 		fd->dd = dd;
+		kobject_get(&fd->dd->kobj);
 		fp->private_data = fd;
 	} else {
 		fp->private_data = NULL;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
