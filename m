From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/12] IB/hfi1: Fix an Oops on pci device force remove
Date: Mon, 17 Oct 2016 04:19:19 -0700
Message-ID: <20161017111918.7934.72325.stgit@scvm10.sc.intel.com>
References: <20161017103326.7934.21558.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161017103326.7934.21558.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch fixes an Oops on device unbind, when the device is used
by a PSM user process. PSM processes access device resources which
are freed on device removal. Similar protection exists in uverbs
in ib_core for Verbs clients, but PSM doesn't use ib_uverbs hence
a separate protection is required for PSM clients.

Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c     |    5 +++++
 drivers/infiniband/hw/hfi1/file_ops.c |    5 +++++
 drivers/infiniband/hw/hfi1/hfi.h      |    4 ++++
 drivers/infiniband/hw/hfi1/init.c     |   19 +++++++++++++++++--
 4 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 9bf5f23..7992152 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -14691,6 +14691,11 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	if (ret)
 		goto bail_free_cntrs;
 
+	init_completion(&dd->user_comp);
+
+	/* The user refcount starts with one to inidicate an active device */
+	atomic_set(&dd->user_refcount, 1);
+
 	goto bail;
 
 bail_free_rcverr:
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 677efa0..14fd63f 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -183,6 +183,7 @@ static int hfi1_file_open(struct inode *inode, struct file *fp)
 		fd->rec_cpu_num = -1; /* no cpu affinity by default */
 		fd->mm = current->mm;
 		atomic_inc(&fd->mm->mm_count);
+		atomic_inc(&dd->user_refcount);
 	}
 
 	fp->private_data = fd;
@@ -798,6 +799,10 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 done:
 	mmdrop(fdata->mm);
 	kobject_put(&dd->kobj);
+
+	if (atomic_dec_and_test(&dd->user_refcount))
+		complete(&dd->user_comp);
+
 	kfree(fdata);
 	return 0;
 }
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 3c06d20..368e96c 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1174,6 +1174,10 @@ struct hfi1_devdata {
 	spinlock_t aspm_lock;
 	/* Number of verbs contexts which have disabled ASPM */
 	atomic_t aspm_disabled_cnt;
+	/* Keeps track of user space clients */
+	atomic_t user_refcount;
+	/* Used to wait for outstanding user space clients before dev removal */
+	struct completion user_comp;
 
 	struct hfi1_affinity *affinity;
 	struct rhashtable sdma_rht;
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 60db615..18f1976 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1538,12 +1538,29 @@ bail:
 	return ret;
 }
 
+static void wait_for_clients(struct hfi1_devdata *dd)
+{
+	/*
+	 * Remove the device init value and wait for active
+	 * users to finish if there are any.
+	 */
+	if (atomic_sub_return(1, &dd->user_refcount))
+		wait_for_completion(&dd->user_comp);
+}
+
 static void remove_one(struct pci_dev *pdev)
 {
 	struct hfi1_devdata *dd = pci_get_drvdata(pdev);
 
 	/* close debugfs files before ib unregister */
 	hfi1_dbg_ibdev_exit(&dd->verbs_dev);
+
+	/* remove the /dev hfi1 interface */
+	hfi1_device_remove(dd);
+
+	/* wait for existing user space clients to finish */
+	wait_for_clients(dd);
+
 	/* unregister from IB core */
 	hfi1_unregister_ib_device(dd);
 
@@ -1558,8 +1575,6 @@ static void remove_one(struct pci_dev *pdev)
 	/* wait until all of our (qsfp) queue_work() calls complete */
 	flush_workqueue(ib_wq);
 
-	hfi1_device_remove(dd);
-
 	postinit_cleanup(dd);
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
