From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Correct nfreectxts for multiple HCAs
Date: Wed, 21 Sep 2011 12:17:36 -0400
Message-ID: <20110921161736.19300.66855.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The code that was recently introduced to report the number
of free contexts is flawed for multiple HCAs:

       /* Return the number of free user ports (contexts) available. */
       return scnprintf(buf, PAGE_SIZE, "%u\n", dd->cfgctxts -
                dd->first_user_ctxt - (u32)qib_stats.sps_ctxts);

The qib_stats is global to the module, not per HCA, so the code is broken
for multiple HCAs.

This patch adds a qib_devdata field, freectxts, that reflects the free
contexts for this HCA.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h          |    4 ++++
 drivers/infiniband/hw/qib/qib_file_ops.c |    2 ++
 drivers/infiniband/hw/qib/qib_init.c     |    1 +
 drivers/infiniband/hw/qib/qib_sysfs.c    |    3 +--
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index c9624ea..ee993e7 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -807,6 +807,10 @@ struct qib_devdata {
 	 * supports, less gives more pio bufs/ctxt, etc.
 	 */
 	u32 cfgctxts;
+	/*
+	 * number of ctxts available for PSM open
+	 */
+	u32 freectxts;
 
 	/*
 	 * hint that we should update pioavailshadow before
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 2625303..7763366 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1284,6 +1284,7 @@ static int setup_ctxt(struct qib_pportdata *ppd, int ctxt,
 	strlcpy(rcd->comm, current->comm, sizeof(rcd->comm));
 	ctxt_fp(fp) = rcd;
 	qib_stats.sps_ctxts++;
+	dd->freectxts++;
 	ret = 0;
 	goto bail;
 
@@ -1792,6 +1793,7 @@ static int qib_close(struct inode *in, struct file *fp)
 		if (dd->pageshadow)
 			unlock_expected_tids(rcd);
 		qib_stats.sps_ctxts--;
+		dd->freectxts--;
 	}
 
 	mutex_unlock(&qib_mutex);
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index a01f3fc..021636d 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -398,6 +398,7 @@ static void enable_chip(struct qib_devdata *dd)
 		if (rcd)
 			dd->f_rcvctrl(rcd->ppd, rcvmask, i);
 	}
+	dd->freectxts = dd->cfgctxts - dd->first_user_ctxt;
 }
 
 static void verify_interrupt(unsigned long opaque)
diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
index 14d129d..78fbd56 100644
--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -515,8 +515,7 @@ static ssize_t show_nfreectxts(struct device *device,
 	struct qib_devdata *dd = dd_from_dev(dev);
 
 	/* Return the number of free user ports (contexts) available. */
-	return scnprintf(buf, PAGE_SIZE, "%u\n", dd->cfgctxts -
-		dd->first_user_ctxt - (u32)qib_stats.sps_ctxts);
+	return scnprintf(buf, PAGE_SIZE, "%u\n", dd->freectxts);
 }
 
 static ssize_t show_serial(struct device *device,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
