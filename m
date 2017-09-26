From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-rc 6/7] IB/hfi1: On error,
 fix use after free during user context setup
Date: Tue, 26 Sep 2017 06:06:28 -0700
Message-ID: <20170926130627.31476.88544.stgit@scvm10.sc.intel.com>
References: <20170926130434.31476.81826.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926130434.31476.81826.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

During base context setup, if setup_base_ctxt() fails, the context is
deallocated. This is incorrect because the context is referenced on
return, to notify any waiting subcontext.  If there are no subcontexts
the pointer will be invalid.

Reorganize the error path so that deallocate_ctxt() is called after all
the possible subcontexts have been notified.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c |   41 ++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 2bc8926..d9a1e98 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -930,15 +930,8 @@ static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
 	switch (ret) {
 	case 0:
 		ret = setup_base_ctxt(fd, uctxt);
-		if (uctxt->subctxt_cnt) {
-			/*
-			 * Base context is done (successfully or not), notify
-			 * anybody using a sub-context that is waiting for
-			 * this completion.
-			 */
-			clear_bit(HFI1_CTXT_BASE_UNINIT, &uctxt->event_flags);
-			wake_up(&uctxt->wait);
-		}
+		if (ret)
+			deallocate_ctxt(uctxt);
 		break;
 	case 1:
 		ret = complete_subctxt(fd);
@@ -1305,25 +1298,25 @@ static int setup_base_ctxt(struct hfi1_filedata *fd,
 	/* Now allocate the RcvHdr queue and eager buffers. */
 	ret = hfi1_create_rcvhdrq(dd, uctxt);
 	if (ret)
-		return ret;
+		goto done;
 
 	ret = hfi1_setup_eagerbufs(uctxt);
 	if (ret)
-		goto setup_failed;
+		goto done;
 
 	/* If sub-contexts are enabled, do the appropriate setup */
 	if (uctxt->subctxt_cnt)
 		ret = setup_subctxt(uctxt);
 	if (ret)
-		goto setup_failed;
+		goto done;
 
 	ret = hfi1_alloc_ctxt_rcv_groups(uctxt);
 	if (ret)
-		goto setup_failed;
+		goto done;
 
 	ret = init_user_ctxt(fd, uctxt);
 	if (ret)
-		goto setup_failed;
+		goto done;
 
 	user_init(uctxt);
 
@@ -1331,12 +1324,22 @@ static int setup_base_ctxt(struct hfi1_filedata *fd,
 	fd->uctxt = uctxt;
 	hfi1_rcd_get(uctxt);
 
-	return 0;
+done:
+	if (uctxt->subctxt_cnt) {
+		/*
+		 * On error, set the failed bit so sub-contexts will clean up
+		 * correctly.
+		 */
+		if (ret)
+			set_bit(HFI1_CTXT_BASE_FAILED, &uctxt->event_flags);
 
-setup_failed:
-	/* Set the failed bit so sub-context init can do the right thing */
-	set_bit(HFI1_CTXT_BASE_FAILED, &uctxt->event_flags);
-	deallocate_ctxt(uctxt);
+		/*
+		 * Base context is done (successfully or not), notify anybody
+		 * using a sub-context that is waiting for this completion.
+		 */
+		clear_bit(HFI1_CTXT_BASE_UNINIT, &uctxt->event_flags);
+		wake_up(&uctxt->wait);
+	}
 
 	return ret;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
