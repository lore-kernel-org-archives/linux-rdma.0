From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 07/15] IB/hfi1: Fix a subcontext memory leak
Date: Thu, 04 May 2017 05:14:34 -0700
Message-ID: <20170504121433.32747.5718.stgit@scvm10.sc.intel.com>
References: <20170504120126.32747.45131.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170504120126.32747.45131.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The only context that frees user_exp_rcv data structures is the last
context closed (from a sub-context set).  This leaks the allocations
from the other sub-contexts.  Separate the common frees from the
specific frees and call them at the appropriate time.

Using KEDR to check for memory leaks we get:

Before test:

[leak_check] Possible leaks: 25

After test:

[leak_check] Possible leaks: 31  (6 leaked data structures)

After patch applied (before and after test have the same value)

[leak_check] Possible leaks: 25

Each leak is 192 + 13440 + 6720 = 20352 bytes per sub-context.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c     |    5 ++++-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |   32 ++++++++++++++++-------------
 drivers/infiniband/hw/hfi1/user_exp_rcv.h |    1 +
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 3d9bce4..afdf3ef 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -756,6 +756,9 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	/* release the cpu */
 	hfi1_put_proc_affinity(fdata->rec_cpu_num);
 
+	/* clean up rcv side */
+	hfi1_user_exp_rcv_free(fdata);
+
 	/*
 	 * Clear any left over, unhandled events so the next process that
 	 * gets this context doesn't get confused.
@@ -795,7 +798,7 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 
 	dd->rcd[uctxt->ctxt] = NULL;
 
-	hfi1_user_exp_rcv_free(fdata);
+	hfi1_user_exp_rcv_grp_free(uctxt);
 	hfi1_clear_ctxt_pkey(dd, uctxt->ctxt);
 
 	uctxt->rcvwait_to = 0;
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 35c6e7e..c7f13df 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -252,36 +252,40 @@ int hfi1_user_exp_rcv_init(struct file *fp)
 	return ret;
 }
 
+void hfi1_user_exp_rcv_grp_free(struct hfi1_ctxtdata *uctxt)
+{
+	struct tid_group *grp, *gptr;
+
+	list_for_each_entry_safe(grp, gptr, &uctxt->tid_group_list.list,
+				 list) {
+		list_del_init(&grp->list);
+		kfree(grp);
+	}
+	hfi1_clear_tids(uctxt);
+}
+
 int hfi1_user_exp_rcv_free(struct hfi1_filedata *fd)
 {
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
-	struct tid_group *grp, *gptr;
 
-	if (!test_bit(HFI1_CTXT_SETUP_DONE, &uctxt->event_flags))
-		return 0;
 	/*
 	 * The notifier would have been removed when the process'es mm
 	 * was freed.
 	 */
-	if (fd->handler)
+	if (fd->handler) {
 		hfi1_mmu_rb_unregister(fd->handler);
-
-	kfree(fd->invalid_tids);
-
-	if (!uctxt->cnt) {
+	} else {
 		if (!EXP_TID_SET_EMPTY(uctxt->tid_full_list))
 			unlock_exp_tids(uctxt, &uctxt->tid_full_list, fd);
 		if (!EXP_TID_SET_EMPTY(uctxt->tid_used_list))
 			unlock_exp_tids(uctxt, &uctxt->tid_used_list, fd);
-		list_for_each_entry_safe(grp, gptr, &uctxt->tid_group_list.list,
-					 list) {
-			list_del_init(&grp->list);
-			kfree(grp);
-		}
-		hfi1_clear_tids(uctxt);
 	}
 
+	kfree(fd->invalid_tids);
+	fd->invalid_tids = NULL;
+
 	kfree(fd->entry_to_rb);
+	fd->entry_to_rb = NULL;
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.h b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
index 9bc8d9f..d1d7d3d 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.h
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
@@ -70,6 +70,7 @@
 		(tid) |= EXP_TID_SET(field, (value));			\
 	} while (0)
 
+void hfi1_user_exp_rcv_grp_free(struct hfi1_ctxtdata *uctxt);
 int hfi1_user_exp_rcv_init(struct file *);
 int hfi1_user_exp_rcv_free(struct hfi1_filedata *);
 int hfi1_user_exp_rcv_setup(struct file *, struct hfi1_tid_info *);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
