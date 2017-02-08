From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 27/27] IB/hfi1: Code reuse with memdup_copy
Date: Wed, 08 Feb 2017 05:28:31 -0800
Message-ID: <20170208132830.16442.93943.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Update several usages of kmalloc/user_copy to memdup_copy and
memdup_copy_nul.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/debugfs.c      |   39 ++++++++---------------------
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |   17 ++++---------
 drivers/infiniband/hw/hfi1/user_sdma.c    |   17 ++++++-------
 3 files changed, 25 insertions(+), 48 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index ed4a217..cd06f1f 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -53,6 +53,7 @@
 #include <linux/types.h>
 #include <linux/ratelimit.h>
 #include <linux/fault-inject.h>
+#include <linux/string.h>
 
 #include "hfi.h"
 #include "trace.h"
@@ -507,18 +508,11 @@ static ssize_t asic_flags_write(struct file *file, const char __user *buf,
 	ppd = private2ppd(file);
 	dd = ppd->dd;
 
-	buff = kmalloc(count + 1, GFP_KERNEL);
-	if (!buff)
-		return -ENOMEM;
-
-	ret = copy_from_user(buff, buf, count);
-	if (ret > 0) {
-		ret = -EFAULT;
-		goto do_free;
-	}
-
 	/* zero terminate and read the expected integer */
-	buff[count] = 0;
+	buff = memdup_user_nul(buf, count);
+	if (IS_ERR(buff))
+		return PTR_ERR(buff);
+
 	ret = kstrtoull(buff, 0, &value);
 	if (ret)
 		goto do_free;
@@ -696,15 +690,9 @@ static ssize_t __i2c_debugfs_write(struct file *file, const char __user *buf,
 	if (i2c_addr == 0)
 		return -EINVAL;
 
-	buff = kmalloc(count, GFP_KERNEL);
-	if (!buff)
-		return -ENOMEM;
-
-	ret = copy_from_user(buff, buf, count);
-	if (ret > 0) {
-		ret = -EFAULT;
-		goto _free;
-	}
+	buff = memdup_user(buf, count);
+	if (IS_ERR(buff))
+		return PTR_ERR(buff);
 
 	total_written = i2c_write(ppd, target, i2c_addr, offset, buff, count);
 	if (total_written < 0) {
@@ -809,15 +797,10 @@ static ssize_t __qsfp_debugfs_write(struct file *file, const char __user *buf,
 
 	ppd = private2ppd(file);
 
-	buff = kmalloc(count, GFP_KERNEL);
-	if (!buff)
-		return -ENOMEM;
+	buff = memdup_user(buf, count);
+	if (IS_ERR(buff))
+		return PTR_ERR(buff);
 
-	ret = copy_from_user(buff, buf, count);
-	if (ret > 0) {
-		ret = -EFAULT;
-		goto _free;
-	}
 	total_written = qsfp_write(ppd, target, *ppos, buff, count);
 	if (total_written < 0) {
 		ret = total_written;
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 64d2652..4a82953 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -45,6 +45,7 @@
  *
  */
 #include <asm/page.h>
+#include <linux/string.h>
 
 #include "user_exp_rcv.h"
 #include "trace.h"
@@ -577,16 +578,10 @@ int hfi1_user_exp_rcv_clear(struct file *fp, struct hfi1_tid_info *tinfo)
 	u32 *tidinfo;
 	unsigned tididx;
 
-	tidinfo = kcalloc(tinfo->tidcnt, sizeof(*tidinfo), GFP_KERNEL);
-	if (!tidinfo)
-		return -ENOMEM;
-
-	if (copy_from_user(tidinfo, (void __user *)(unsigned long)
-			   tinfo->tidlist, sizeof(tidinfo[0]) *
-			   tinfo->tidcnt)) {
-		ret = -EFAULT;
-		goto done;
-	}
+	tidinfo = memdup_user((void __user *)(unsigned long)tinfo->tidlist,
+			      sizeof(tidinfo[0]) * tinfo->tidcnt);
+	if (IS_ERR(tidinfo))
+		return PTR_ERR(tidinfo);
 
 	mutex_lock(&uctxt->exp_lock);
 	for (tididx = 0; tididx < tinfo->tidcnt; tididx++) {
@@ -602,7 +597,7 @@ int hfi1_user_exp_rcv_clear(struct file *fp, struct hfi1_tid_info *tinfo)
 	spin_unlock(&fd->tid_lock);
 	tinfo->tidcnt = tididx;
 	mutex_unlock(&uctxt->exp_lock);
-done:
+
 	kfree(tidinfo);
 	return ret;
 }
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 7d22f8e..e6811c4 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -60,6 +60,7 @@
 #include <linux/mmu_context.h>
 #include <linux/module.h>
 #include <linux/vmalloc.h>
+#include <linux/string.h>
 
 #include "hfi.h"
 #include "sdma.h"
@@ -725,30 +726,28 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	 */
 	if (req_opcode(req->info.ctrl) == EXPECTED) {
 		u16 ntids = iovec[idx].iov_len / sizeof(*req->tids);
+		u32 *tmp;
 
 		if (!ntids || ntids > MAX_TID_PAIR_ENTRIES) {
 			ret = -EINVAL;
 			goto free_req;
 		}
-		req->tids = kcalloc(ntids, sizeof(*req->tids), GFP_KERNEL);
-		if (!req->tids) {
-			ret = -ENOMEM;
-			goto free_req;
-		}
+
 		/*
 		 * We have to copy all of the tids because they may vary
 		 * in size and, therefore, the TID count might not be
 		 * equal to the pkt count. However, there is no way to
 		 * tell at this point.
 		 */
-		ret = copy_from_user(req->tids, iovec[idx].iov_base,
-				     ntids * sizeof(*req->tids));
-		if (ret) {
+		tmp = memdup_user(iovec[idx].iov_base,
+				  ntids * sizeof(*req->tids));
+		if (IS_ERR(tmp)) {
+			ret = PTR_ERR(tmp);
 			SDMA_DBG(req, "Failed to copy %d TIDs (%d)",
 				 ntids, ret);
-			ret = -EFAULT;
 			goto free_req;
 		}
+		req->tids = tmp;
 		req->n_tids = ntids;
 		idx++;
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
