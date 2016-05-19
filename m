From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/10] IB/hfi1: Do not free hfi1 cdev parent structure early
Date: Thu, 19 May 2016 05:26:44 -0700
Message-ID: <20160519122642.22041.66203.stgit@scvm10.sc.intel.com>
References: <20160519122318.22041.58871.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160519122318.22041.58871.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The deletion of a cdev is not a fence for holding off references to the
structure. The driver attempts to delete the cdev and then proceeds to
free the parent structure, the hfi1_devdata, or dd. This can potentially
lead to a kernel panic in situations where a user has an FD for the cdev
open, and the pci device gets removed. If the user then closes the FD
there will be a NULL dereference when trying to do put on the cdev's
kobject.

Fix this by pointing the cdev's kobject.parent at a new kobject embedded
in its parent structure. Also take a reference when the device is opened
and put it back when it is closed.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/device.c   |    4 +++-
 drivers/staging/rdma/hfi1/device.h   |    3 ++-
 drivers/staging/rdma/hfi1/file_ops.c |   15 ++++++++++++---
 drivers/staging/rdma/hfi1/hfi.h      |    1 +
 drivers/staging/rdma/hfi1/init.c     |   14 +++++++++++++-
 5 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/device.c b/drivers/staging/rdma/hfi1/device.c
index 6ee800f..bf64b5a 100644
--- a/drivers/staging/rdma/hfi1/device.c
+++ b/drivers/staging/rdma/hfi1/device.c
@@ -60,7 +60,8 @@ static dev_t hfi1_dev;
 int hfi1_cdev_init(int minor, const char *name,
 		   const struct file_operations *fops,
 		   struct cdev *cdev, struct device **devp,
-		   bool user_accessible)
+		   bool user_accessible,
+		   struct kobject *parent)
 {
 	const dev_t dev = MKDEV(MAJOR(hfi1_dev), minor);
 	struct device *device = NULL;
@@ -68,6 +69,7 @@ int hfi1_cdev_init(int minor, const char *name,
 
 	cdev_init(cdev, fops);
 	cdev->owner = THIS_MODULE;
+	cdev->kobj.parent = parent;
 	kobject_set_name(&cdev->kobj, name);
 
 	ret = cdev_add(cdev, dev, 1);
diff --git a/drivers/staging/rdma/hfi1/device.h b/drivers/staging/rdma/hfi1/device.h
index 5bb3e83..c3ec19c 100644
--- a/drivers/staging/rdma/hfi1/device.h
+++ b/drivers/staging/rdma/hfi1/device.h
@@ -50,7 +50,8 @@
 int hfi1_cdev_init(int minor, const char *name,
 		   const struct file_operations *fops,
 		   struct cdev *cdev, struct device **devp,
-		   bool user_accessible);
+		   bool user_accessible,
+		   struct kobject *parent);
 void hfi1_cdev_cleanup(struct cdev *cdev, struct device **devp);
 const char *class_name(void);
 int __init dev_init(void);
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 1139170..7a5b0e6 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -168,6 +168,13 @@ static inline int is_valid_mmap(u64 token)
 
 static int hfi1_file_open(struct inode *inode, struct file *fp)
 {
+	struct hfi1_devdata *dd = container_of(inode->i_cdev,
+					       struct hfi1_devdata,
+					       user_cdev);
+
+	/* Just take a ref now. Not all opens result in a context assign */
+	kobject_get(&dd->kobj);
+
 	/* The real work is performed later in assign_ctxt() */
 	fp->private_data = kzalloc(sizeof(struct hfi1_filedata), GFP_KERNEL);
 	if (fp->private_data) /* no cpu affinity by default */
@@ -690,7 +697,9 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 {
 	struct hfi1_filedata *fdata = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fdata->uctxt;
-	struct hfi1_devdata *dd;
+	struct hfi1_devdata *dd = container_of(inode->i_cdev,
+					       struct hfi1_devdata,
+					       user_cdev);
 	unsigned long flags, *ev;
 
 	fp->private_data = NULL;
@@ -699,7 +708,6 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 		goto done;
 
 	hfi1_cdbg(PROC, "freeing ctxt %u:%u", uctxt->ctxt, fdata->subctxt);
-	dd = uctxt->dd;
 	mutex_lock(&hfi1_mutex);
 
 	flush_wc();
@@ -765,6 +773,7 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	mutex_unlock(&hfi1_mutex);
 	hfi1_free_ctxtdata(dd, uctxt);
 done:
+	kobject_put(&dd->kobj);
 	kfree(fdata);
 	return 0;
 }
@@ -1464,7 +1473,7 @@ static int user_add(struct hfi1_devdata *dd)
 	snprintf(name, sizeof(name), "%s_%d", class_name(), dd->unit);
 	ret = hfi1_cdev_init(dd->unit, name, &hfi1_file_ops,
 			     &dd->user_cdev, &dd->user_device,
-			     true);
+			     true, &dd->kobj);
 	if (ret)
 		user_remove(dd);
 
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 337bd2d..4417a0f 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1169,6 +1169,7 @@ struct hfi1_devdata {
 	atomic_t aspm_disabled_cnt;
 
 	struct hfi1_affinity *affinity;
+	struct kobject kobj;
 };
 
 /* 8051 firmware version helper */
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 9e71abf..61bf7ff 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -989,8 +989,10 @@ static void release_asic_data(struct hfi1_devdata *dd)
 	dd->asic_data = NULL;
 }
 
-void hfi1_free_devdata(struct hfi1_devdata *dd)
+static void __hfi1_free_devdata(struct kobject *kobj)
 {
+	struct hfi1_devdata *dd =
+		container_of(kobj, struct hfi1_devdata, kobj);
 	unsigned long flags;
 
 	spin_lock_irqsave(&hfi1_devs_lock, flags);
@@ -1007,6 +1009,15 @@ void hfi1_free_devdata(struct hfi1_devdata *dd)
 	rvt_dealloc_device(&dd->verbs_dev.rdi);
 }
 
+static struct kobj_type hfi1_devdata_type = {
+	.release = __hfi1_free_devdata,
+};
+
+void hfi1_free_devdata(struct hfi1_devdata *dd)
+{
+	kobject_put(&dd->kobj);
+}
+
 /*
  * Allocate our primary per-unit data structure.  Must be done via verbs
  * allocator, because the verbs cleanup process both does cleanup and
@@ -1102,6 +1113,7 @@ struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra)
 			&pdev->dev,
 			"Could not alloc cpulist info, cpu affinity might be wrong\n");
 	}
+	kobject_init(&dd->kobj, &hfi1_devdata_type);
 	return dd;
 
 bail:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
