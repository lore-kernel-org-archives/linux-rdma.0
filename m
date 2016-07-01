From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 02/18] IB/hfi1: Remove unnecessary done label in
 hfi1_write_iter
Date: Fri, 01 Jul 2016 16:00:55 -0700
Message-ID: <20160701230054.20160.66207.stgit@scvm10.sc.intel.com>
References: <20160701225824.20160.19055.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701225824.20160.19055.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Simple code clean up of hfi1_write_iter.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c |   31 ++++++++++++++-----------------
 1 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index c702a00..2f097d9 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -392,41 +392,38 @@ static ssize_t hfi1_write_iter(struct kiocb *kiocb, struct iov_iter *from)
 	struct hfi1_filedata *fd = kiocb->ki_filp->private_data;
 	struct hfi1_user_sdma_pkt_q *pq = fd->pq;
 	struct hfi1_user_sdma_comp_q *cq = fd->cq;
-	int ret = 0, done = 0, reqs = 0;
+	int done = 0, reqs = 0;
 	unsigned long dim = from->nr_segs;
 
-	if (!cq || !pq) {
-		ret = -EIO;
-		goto done;
-	}
+	if (!cq || !pq)
+		return -EIO;
 
-	if (!iter_is_iovec(from) || !dim) {
-		ret = -EINVAL;
-		goto done;
-	}
+	if (!iter_is_iovec(from) || !dim)
+		return -EINVAL;
 
 	hfi1_cdbg(SDMA, "SDMA request from %u:%u (%lu)",
 		  fd->uctxt->ctxt, fd->subctxt, dim);
 
-	if (atomic_read(&pq->n_reqs) == pq->n_max_reqs) {
-		ret = -ENOSPC;
-		goto done;
-	}
+	if (atomic_read(&pq->n_reqs) == pq->n_max_reqs)
+		return -ENOSPC;
 
 	while (dim) {
+		int ret;
 		unsigned long count = 0;
 
 		ret = hfi1_user_sdma_process_request(
 			kiocb->ki_filp,	(struct iovec *)(from->iov + done),
 			dim, &count);
-		if (ret)
-			goto done;
+		if (ret) {
+			reqs = ret;
+			break;
+		}
 		dim -= count;
 		done += count;
 		reqs++;
 	}
-done:
-	return ret ? ret : reqs;
+
+	return reqs;
 }
 
 static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
