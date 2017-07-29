From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 3/8] IB/hfi1: Only set fd pointer when base context
 is completely initialized
Date: Sat, 29 Jul 2017 08:43:32 -0700
Message-ID: <20170729154331.21487.10042.stgit@scvm10.sc.intel.com>
References: <20170729154124.21487.53119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170729154124.21487.53119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The allocate_ctxt() function adds the context to the fd data structure.
Since the context is not completely initialized, this can cause confusion
as to whether the context is valid or not.

Move the fd reference from allocate_ctxt() to setup_base_ctxt().
Update the necessary functions to be aware of this move.

Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c     |   55 +++++++++++++++++------------
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |    4 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.h |    3 +-
 drivers/infiniband/hw/hfi1/user_sdma.c    |    4 +-
 drivers/infiniband/hw/hfi1/user_sdma.h    |    3 +-
 5 files changed, 40 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 650c1e5..a0c13fa 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -81,19 +81,22 @@
 static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo);
 static int init_subctxts(struct hfi1_ctxtdata *uctxt,
 			 const struct hfi1_user_info *uinfo);
-static int init_user_ctxt(struct hfi1_filedata *fd);
+static int init_user_ctxt(struct hfi1_filedata *fd,
+			  struct hfi1_ctxtdata *uctxt);
 static void user_init(struct hfi1_ctxtdata *uctxt);
 static int get_ctxt_info(struct hfi1_filedata *fd, void __user *ubase,
 			 __u32 len);
 static int get_base_info(struct hfi1_filedata *fd, void __user *ubase,
 			 __u32 len);
-static int setup_base_ctxt(struct hfi1_filedata *fd);
+static int setup_base_ctxt(struct hfi1_filedata *fd,
+			   struct hfi1_ctxtdata *uctxt);
 static int setup_subctxt(struct hfi1_ctxtdata *uctxt);
 
 static int find_sub_ctxt(struct hfi1_filedata *fd,
 			 const struct hfi1_user_info *uinfo);
 static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
-			 struct hfi1_user_info *uinfo);
+			 struct hfi1_user_info *uinfo,
+			 struct hfi1_ctxtdata **cd);
 static void deallocate_ctxt(struct hfi1_ctxtdata *uctxt);
 static unsigned int poll_urgent(struct file *fp, struct poll_table_struct *pt);
 static unsigned int poll_next(struct file *fp, struct poll_table_struct *pt);
@@ -759,7 +762,7 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 
 	flush_wc();
 	/* drain user sdma queue */
-	hfi1_user_sdma_free_queues(fdata);
+	hfi1_user_sdma_free_queues(fdata, uctxt);
 
 	/* release the cpu */
 	hfi1_put_proc_affinity(fdata->rec_cpu_num);
@@ -845,6 +848,7 @@ static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
 {
 	int ret;
 	unsigned int swmajor, swminor;
+	struct hfi1_ctxtdata *uctxt = NULL;
 
 	swmajor = uinfo->userversion >> 16;
 	if (swmajor != HFI1_USER_SWMAJOR)
@@ -870,7 +874,7 @@ static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
 	 * couldn't find a sub context.
 	 */
 	if (!ret)
-		ret = allocate_ctxt(fd, fd->dd, uinfo);
+		ret = allocate_ctxt(fd, fd->dd, uinfo, &uctxt);
 
 	mutex_unlock(&hfi1_mutex);
 
@@ -888,28 +892,27 @@ static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
 
 		/* The only thing a sub context needs is the user_xxx stuff */
 		if (!ret)
-			ret = init_user_ctxt(fd);
+			ret = init_user_ctxt(fd, fd->uctxt);
 
 		if (ret)
 			clear_bit(fd->subctxt, fd->uctxt->in_use_ctxts);
 
 	} else if (!ret) {
-		ret = setup_base_ctxt(fd);
-		if (fd->uctxt->subctxt_cnt) {
+		ret = setup_base_ctxt(fd, uctxt);
+		if (uctxt->subctxt_cnt) {
 			/* If there is an error, set the failed bit. */
 			if (ret)
 				set_bit(HFI1_CTXT_BASE_FAILED,
-					&fd->uctxt->event_flags);
+					&uctxt->event_flags);
 			/*
 			 * Base context is done, notify anybody using a
 			 * sub-context that is waiting for this completion
 			 */
-			clear_bit(HFI1_CTXT_BASE_UNINIT,
-				  &fd->uctxt->event_flags);
-			wake_up(&fd->uctxt->wait);
+			clear_bit(HFI1_CTXT_BASE_UNINIT, &uctxt->event_flags);
+			wake_up(&uctxt->wait);
 		}
 		if (ret)
-			deallocate_ctxt(fd->uctxt);
+			deallocate_ctxt(uctxt);
 	}
 
 	/* If an error occurred, clear the reference */
@@ -976,7 +979,8 @@ static int find_sub_ctxt(struct hfi1_filedata *fd,
 }
 
 static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
-			 struct hfi1_user_info *uinfo)
+			 struct hfi1_user_info *uinfo,
+			 struct hfi1_ctxtdata **cd)
 {
 	struct hfi1_ctxtdata *uctxt;
 	u16 ctxt;
@@ -1071,14 +1075,13 @@ static int allocate_ctxt(struct hfi1_filedata *fd, struct hfi1_devdata *dd,
 	 */
 	if (dd->freectxts-- == dd->num_user_contexts)
 		aspm_disable_all(dd);
-	fd->uctxt = uctxt;
 
-	/* Count the reference for the fd */
-	hfi1_rcd_get(uctxt);
+	*cd = uctxt;
 
 	return 0;
 
 ctxdata_free:
+	*cd = NULL;
 	dd->rcd[ctxt] = NULL;
 	hfi1_rcd_put(uctxt);
 	return ret;
@@ -1243,23 +1246,25 @@ static int get_ctxt_info(struct hfi1_filedata *fd, void __user *ubase,
 	return ret;
 }
 
-static int init_user_ctxt(struct hfi1_filedata *fd)
+static int init_user_ctxt(struct hfi1_filedata *fd,
+			  struct hfi1_ctxtdata *uctxt)
 {
-	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	int ret;
 
 	ret = hfi1_user_sdma_alloc_queues(uctxt, fd);
 	if (ret)
 		return ret;
 
-	ret = hfi1_user_exp_rcv_init(fd);
+	ret = hfi1_user_exp_rcv_init(fd, uctxt);
+	if (ret)
+		hfi1_user_sdma_free_queues(fd, uctxt);
 
 	return ret;
 }
 
-static int setup_base_ctxt(struct hfi1_filedata *fd)
+static int setup_base_ctxt(struct hfi1_filedata *fd,
+			   struct hfi1_ctxtdata *uctxt)
 {
-	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 	int ret = 0;
 
@@ -1284,12 +1289,16 @@ static int setup_base_ctxt(struct hfi1_filedata *fd)
 	if (ret)
 		goto setup_failed;
 
-	ret = init_user_ctxt(fd);
+	ret = init_user_ctxt(fd, uctxt);
 	if (ret)
 		goto setup_failed;
 
 	user_init(uctxt);
 
+	/* Now that the context is set up, the fd can get a reference. */
+	fd->uctxt = uctxt;
+	hfi1_rcd_get(uctxt);
+
 	return 0;
 
 setup_failed:
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 3baf719..d9036ba 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -104,9 +104,9 @@ static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo,
  * receive caching. This needs to be done after the context has
  * been configured with the eager/expected RcvEntry counts.
  */
-int hfi1_user_exp_rcv_init(struct hfi1_filedata *fd)
+int hfi1_user_exp_rcv_init(struct hfi1_filedata *fd,
+			   struct hfi1_ctxtdata *uctxt)
 {
-	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 	int ret = 0;
 
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.h b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
index 1bdc61b..6cbaa4c 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.h
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
@@ -51,7 +51,8 @@
 
 #include "exp_rcv.h"
 
-int hfi1_user_exp_rcv_init(struct hfi1_filedata *fd);
+int hfi1_user_exp_rcv_init(struct hfi1_filedata *fd,
+			   struct hfi1_ctxtdata *uctxt);
 void hfi1_user_exp_rcv_free(struct hfi1_filedata *fd);
 int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 			    struct hfi1_tid_info *tinfo);
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 64d31eb..8f02707 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -437,9 +437,9 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
 	return ret;
 }
 
-int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd)
+int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd,
+			       struct hfi1_ctxtdata *uctxt)
 {
-	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_user_sdma_pkt_q *pq;
 
 	hfi1_cdbg(SDMA, "[%u:%u:%u] Freeing user SDMA queues", uctxt->dd->unit,
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index 73c2455..84c199d 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -81,7 +81,8 @@ struct hfi1_user_sdma_comp_q {
 
 int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt,
 				struct hfi1_filedata *fd);
-int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd);
+int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd,
+			       struct hfi1_ctxtdata *uctxt);
 int hfi1_user_sdma_process_request(struct hfi1_filedata *fd,
 				   struct iovec *iovec, unsigned long dim,
 				   unsigned long *count);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
