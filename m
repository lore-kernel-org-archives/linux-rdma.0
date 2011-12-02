From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: correct sense on freectxts increment and decrement
Date: Fri, 2 Dec 2011 12:41:30 -0500
Message-ID: <20111202174130.13373.3854.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The maintenance of dd->nfreectxts was incorrectly opposite
of the patch intention in 53ab1c64983
("IB/qib: Correct nfreectxts for multiple HCAs")

Reviewed-by: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_file_ops.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 574600e..a740324 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1285,7 +1285,7 @@ static int setup_ctxt(struct qib_pportdata *ppd, int ctxt,
 	strlcpy(rcd->comm, current->comm, sizeof(rcd->comm));
 	ctxt_fp(fp) = rcd;
 	qib_stats.sps_ctxts++;
-	dd->freectxts++;
+	dd->freectxts--;
 	ret = 0;
 	goto bail;
 
@@ -1794,7 +1794,7 @@ static int qib_close(struct inode *in, struct file *fp)
 		if (dd->pageshadow)
 			unlock_expected_tids(rcd);
 		qib_stats.sps_ctxts--;
-		dd->freectxts--;
+		dd->freectxts++;
 	}
 
 	mutex_unlock(&qib_mutex);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
