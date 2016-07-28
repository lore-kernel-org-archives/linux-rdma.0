From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 02/13] IB/hfi1: Remove unused uctxt->subpid and uctxt->pid
Date: Thu, 28 Jul 2016 12:27:26 -0400
Message-ID: <1469723257-27317-3-git-send-email-ira.weiny@intel.com>
References: <1469723257-27317-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469723257-27317-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

These are no longer needed.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c | 4 ----
 drivers/infiniband/hw/hfi1/hfi.h      | 3 ---
 2 files changed, 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index d7c07bc7bd14..b80c8d2ac52b 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -727,7 +727,6 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 
 	if (--uctxt->cnt) {
 		uctxt->active_slaves &= ~(1 << fdata->subctxt);
-		uctxt->subpid[fdata->subctxt] = 0;
 		mutex_unlock(&hfi1_mutex);
 		goto done;
 	}
@@ -753,7 +752,6 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	write_kctxt_csr(dd, uctxt->sc->hw_context, SEND_CTXT_CHECK_ENABLE,
 			hfi1_pkt_default_send_ctxt_mask(dd, uctxt->sc->type));
 	sc_disable(uctxt->sc);
-	uctxt->pid = 0;
 	spin_unlock_irqrestore(&dd->uctxt_lock, flags);
 
 	dd->rcd[uctxt->ctxt] = NULL;
@@ -893,7 +891,6 @@ static int find_shared_ctxt(struct file *fp,
 			}
 			fd->uctxt = uctxt;
 			fd->subctxt  = uctxt->cnt++;
-			uctxt->subpid[fd->subctxt] = current->pid;
 			uctxt->active_slaves |= 1 << fd->subctxt;
 			ret = 1;
 			goto done;
@@ -978,7 +975,6 @@ static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 			return ret;
 	}
 	uctxt->userversion = uinfo->userversion;
-	uctxt->pid = current->pid;
 	uctxt->flags = HFI1_CAP_UGET(MASK);
 	init_waitqueue_head(&uctxt->wait);
 	strlcpy(uctxt->comm, current->comm, sizeof(uctxt->comm));
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index df43732621ee..63ce587d6f94 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -270,9 +270,6 @@ struct hfi1_ctxtdata {
 	u32 urgent;
 	/* saved total number of polled urgent packets for poll edge trigger */
 	u32 urgent_poll;
-	/* pid of process using this ctxt */
-	pid_t pid;
-	pid_t subpid[HFI1_MAX_SHARED_CTXTS];
 	/* same size as task_struct .comm[], command that opened context */
 	char comm[TASK_COMM_LEN];
 	/* so file ops can get at unit */
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
