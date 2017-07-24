From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 03/13] IB/hfi1: Assign context does not clean up
 file descriptor correctly on error
Date: Mon, 24 Jul 2017 07:45:43 -0700
Message-ID: <20170724144542.10034.35606.stgit@scvm10.sc.intel.com>
References: <20170724144415.10034.26787.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170724144415.10034.26787.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In the error path for context allocation, the file descriptor pointer
should not point to a context when an error occurs.

Clean up the appropriate references on error.

Fixes: Commit 62239fc6e5545b2e59f83dfbc5db231a81f37a45 ("IB/hfi1: Clean up on context initialization failure")
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c |   37 +++++++++++++++++++++++----------
 1 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index fbf5284..d36e177 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -94,6 +94,7 @@ static int find_sub_ctxt(struct hfi1_filedata *fd,
 			 const struct hfi1_user_info *uinfo);
 static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
 			 struct hfi1_user_info *uinfo);
+static void deallocate_ctxt(struct hfi1_ctxtdata *uctxt);
 static unsigned int poll_urgent(struct file *fp, struct poll_table_struct *pt);
 static unsigned int poll_next(struct file *fp, struct poll_table_struct *pt);
 static int user_event_ack(struct hfi1_ctxtdata *uctxt, u16 subctxt,
@@ -813,15 +814,9 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	uctxt->rcvnowait = 0;
 	uctxt->pionowait = 0;
 	uctxt->event_flags = 0;
-
-	hfi1_stats.sps_ctxts--;
-	if (++dd->freectxts == dd->num_user_contexts)
-		aspm_enable_all(dd);
-
-	/* _rcd_put() should be done after releasing mutex */
-	dd->rcd[uctxt->ctxt] = NULL;
 	mutex_unlock(&hfi1_mutex);
-	hfi1_rcd_put(uctxt);  /* dd reference */
+
+	deallocate_ctxt(uctxt);
 done:
 	mmdrop(fdata->mm);
 	kobject_put(&dd->kobj);
@@ -898,10 +893,9 @@ static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
 		if (!ret)
 			ret = init_user_ctxt(fd);
 
-		if (ret) {
+		if (ret)
 			clear_bit(fd->subctxt, fd->uctxt->in_use_ctxts);
-			hfi1_rcd_put(fd->uctxt);
-		}
+
 	} else if (!ret) {
 		ret = setup_base_ctxt(fd);
 		if (fd->uctxt->subctxt_cnt) {
@@ -917,6 +911,14 @@ static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
 				  &fd->uctxt->event_flags);
 			wake_up(&fd->uctxt->wait);
 		}
+		if (ret)
+			deallocate_ctxt(fd->uctxt);
+	}
+
+	/* If an error occurred, clear the reference */
+	if (ret && fd->uctxt) {
+		hfi1_rcd_put(fd->uctxt);
+		fd->uctxt = NULL;
 	}
 
 	return ret;
@@ -1087,6 +1089,19 @@ static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
 	return ret;
 }
 
+static void deallocate_ctxt(struct hfi1_ctxtdata *uctxt)
+{
+	mutex_lock(&hfi1_mutex);
+	hfi1_stats.sps_ctxts--;
+	if (++uctxt->dd->freectxts == uctxt->dd->num_user_contexts)
+		aspm_enable_all(uctxt->dd);
+
+	/* _rcd_put() should be done after releasing mutex */
+	uctxt->dd->rcd[uctxt->ctxt] = NULL;
+	mutex_unlock(&hfi1_mutex);
+	hfi1_rcd_put(uctxt);  /* dd reference */
+}
+
 static int init_subctxts(struct hfi1_ctxtdata *uctxt,
 			 const struct hfi1_user_info *uinfo)
 {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
