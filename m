From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] IB/hfi1: Don't attempt to free resources if
 initialization failed
Date: Wed, 20 Apr 2016 06:05:36 -0700
Message-ID: <20160420130535.28231.36344.stgit@scvm10.sc.intel.com>
References: <20160420125205.28231.86818.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160420125205.28231.86818.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Attempting to free resources which have not been allocated and
initialized properly led to the following kernel backtrace:

    BUG: unable to handle kernel NULL pointer dereference at           (null)
    IP: [<ffffffffa09658fe>] unlock_exp_tids.isra.8+0x2e/0x120 [hfi1]
    PGD 852a43067 PUD 85d4a6067 PMD 0
    Oops: 0000 [#1] SMP
    CPU: 0 PID: 2831 Comm: osu_bw Tainted: G          IO 3.12.18-wfr+ #1
    task: ffff88085b15b540 ti: ffff8808588fe000 task.ti: ffff8808588fe000
    RIP: 0010:[<ffffffffa09658fe>]  [<ffffffffa09658fe>] unlock_exp_tids.isra.8+0x2e/0x120 [hfi1]
    RSP: 0018:ffff8808588ffde0  EFLAGS: 00010282
    RAX: 0000000000000000 RBX: ffff880858a31800 RCX: 0000000000000000
    RDX: ffff88085d971bc0 RSI: ffff880858a318f8 RDI: ffff880858a318c0
    RBP: ffff8808588ffe20 R08: 0000000000000000 R09: 0000000000000000
    R10: ffff88087ffd6f40 R11: 0000000001100348 R12: ffff880852900000
    R13: ffff880858a318c0 R14: 0000000000000000 R15: ffff88085d971be8
    FS:  00007f4674e83740(0000) GS:ffff88087f400000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 0000000000000000 CR3: 000000085c377000 CR4: 00000000001407f0
    Stack:
     ffffffffa0941a71 ffff880858a318f8 ffff88085d971bc0 ffff880858a31800
     ffff880852900000 ffff880858a31800 00000000003ffff7 ffff88085d971bc0
     ffff8808588ffe60 ffffffffa09663fc ffff8808588ffe60 ffff880858a31800
    Call Trace:
     [<ffffffffa0941a71>] ? find_mmu_handler+0x51/0x70 [hfi1]
     [<ffffffffa09663fc>] hfi1_user_exp_rcv_free+0x6c/0x120 [hfi1]
     [<ffffffffa0932809>] hfi1_file_close+0x1a9/0x340 [hfi1]
     [<ffffffff8116c189>] __fput+0xe9/0x270
     [<ffffffff8116c35e>] ____fput+0xe/0x10
     [<ffffffff81065707>] task_work_run+0xa7/0xe0
     [<ffffffff81002969>] do_notify_resume+0x59/0x80
     [<ffffffff814ffc1a>] int_signal+0x12/0x17

This commit re-arranges the context initialization code in a way that
would allow for context event flags to be used to determine whether
the context has been successfully initialized.

In turn, this can be used to skip the resource de-allocation if they
were never allocated in the first place.

Fixes: 3abb33ac6521 ("staging/hfi1: Add TID cache receive init and free funcs")
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/file_ops.c     |   60 ++++++++++++++----------------
 drivers/staging/rdma/hfi1/user_exp_rcv.c |    2 +
 2 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 8396dc5..ec6c226 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -791,15 +791,16 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	spin_unlock_irqrestore(&dd->uctxt_lock, flags);
 
 	dd->rcd[uctxt->ctxt] = NULL;
+
+	hfi1_user_exp_rcv_free(fdata);
+	hfi1_clear_ctxt_pkey(dd, uctxt->ctxt);
+
 	uctxt->rcvwait_to = 0;
 	uctxt->piowait_to = 0;
 	uctxt->rcvnowait = 0;
 	uctxt->pionowait = 0;
 	uctxt->event_flags = 0;
 
-	hfi1_user_exp_rcv_free(fdata);
-	hfi1_clear_ctxt_pkey(dd, uctxt->ctxt);
-
 	hfi1_stats.sps_ctxts--;
 	if (++dd->freectxts == dd->num_user_contexts)
 		aspm_enable_all(dd);
@@ -1127,27 +1128,13 @@ bail:
 
 static int user_init(struct file *fp)
 {
-	int ret;
 	unsigned int rcvctrl_ops = 0;
 	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 
 	/* make sure that the context has already been setup */
-	if (!test_bit(HFI1_CTXT_SETUP_DONE, &uctxt->event_flags)) {
-		ret = -EFAULT;
-		goto done;
-	}
-
-	/*
-	 * Subctxts don't need to initialize anything since master
-	 * has done it.
-	 */
-	if (fd->subctxt) {
-		ret = wait_event_interruptible(uctxt->wait, !test_bit(
-					       HFI1_CTXT_MASTER_UNINIT,
-					       &uctxt->event_flags));
-		goto expected;
-	}
+	if (!test_bit(HFI1_CTXT_SETUP_DONE, &uctxt->event_flags))
+		return -EFAULT;
 
 	/* initialize poll variables... */
 	uctxt->urgent = 0;
@@ -1202,19 +1189,7 @@ static int user_init(struct file *fp)
 		wake_up(&uctxt->wait);
 	}
 
-expected:
-	/*
-	 * Expected receive has to be setup for all processes (including
-	 * shared contexts). However, it has to be done after the master
-	 * context has been fully configured as it depends on the
-	 * eager/expected split of the RcvArray entries.
-	 * Setting it up here ensures that the subcontexts will be waiting
-	 * (due to the above wait_event_interruptible() until the master
-	 * is setup.
-	 */
-	ret = hfi1_user_exp_rcv_init(fp);
-done:
-	return ret;
+	return 0;
 }
 
 static int get_ctxt_info(struct file *fp, void __user *ubase, __u32 len)
@@ -1261,7 +1236,7 @@ static int setup_ctxt(struct file *fp)
 	int ret = 0;
 
 	/*
-	 * Context should be set up only once (including allocation and
+	 * Context should be set up only once, including allocation and
 	 * programming of eager buffers. This is done if context sharing
 	 * is not requested or by the master process.
 	 */
@@ -1282,10 +1257,29 @@ static int setup_ctxt(struct file *fp)
 			if (ret)
 				goto done;
 		}
+	} else {
+		ret = wait_event_interruptible(uctxt->wait, !test_bit(
+					       HFI1_CTXT_MASTER_UNINIT,
+					       &uctxt->event_flags));
+		if (ret)
+			goto done;
 	}
+
 	ret = hfi1_user_sdma_alloc_queues(uctxt, fp);
 	if (ret)
 		goto done;
+	/*
+	 * Expected receive has to be setup for all processes (including
+	 * shared contexts). However, it has to be done after the master
+	 * context has been fully configured as it depends on the
+	 * eager/expected split of the RcvArray entries.
+	 * Setting it up here ensures that the subcontexts will be waiting
+	 * (due to the above wait_event_interruptible() until the master
+	 * is setup.
+	 */
+	ret = hfi1_user_exp_rcv_init(fp);
+	if (ret)
+		goto done;
 
 	set_bit(HFI1_CTXT_SETUP_DONE, &uctxt->event_flags);
 done:
diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.c b/drivers/staging/rdma/hfi1/user_exp_rcv.c
index 7507b62..1b640a3 100644
--- a/drivers/staging/rdma/hfi1/user_exp_rcv.c
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.c
@@ -255,6 +255,8 @@ int hfi1_user_exp_rcv_free(struct hfi1_filedata *fd)
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct tid_group *grp, *gptr;
 
+	if (!test_bit(HFI1_CTXT_SETUP_DONE, &uctxt->event_flags))
+		return 0;
 	/*
 	 * The notifier would have been removed when the process'es mm
 	 * was freed.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
