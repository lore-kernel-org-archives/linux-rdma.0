From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: Display correct value for number of contexts
Date: Mon, 7 May 2012 14:03:02 -0400
Message-ID: <20120507180302.3640.11948.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A "fix" for a bug with the number of contexts on a
single-port board caused the calculation to be off by
one, which causes problems with the upper layers. The
same problem exists for number of free contexts, which
is also fixed here.

Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_init.c  |    3 ++-
 drivers/infiniband/hw/qib/qib_sysfs.c |    7 +++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index cf0cd30..dc14e10 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -102,6 +102,8 @@ void qib_set_ctxtcnt(struct qib_devdata *dd)
 		dd->cfgctxts = qib_cfgctxts;
 	else
 		dd->cfgctxts = dd->ctxtcnt;
+	dd->freectxts = (dd->first_user_ctxt > dd->cfgctxts) ? 0 :
+		dd->cfgctxts - dd->first_user_ctxt;
 }
 
 /*
@@ -402,7 +404,6 @@ static void enable_chip(struct qib_devdata *dd)
 		if (rcd)
 			dd->f_rcvctrl(rcd->ppd, rcvmask, i);
 	}
-	dd->freectxts = dd->cfgctxts - dd->first_user_ctxt;
 }
 
 static void verify_interrupt(unsigned long opaque)
diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
index dae5160..dd9cd49 100644
--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -503,8 +503,11 @@ static ssize_t show_nctxts(struct device *device,
 	struct qib_devdata *dd = dd_from_dev(dev);
 
 	/* Return the number of user ports (contexts) available. */
-	return scnprintf(buf, PAGE_SIZE, "%u\n", dd->cfgctxts -
-		dd->first_user_ctxt);
+	/* The calculation below deals with a special case where
+	 * cfgctxts is set to 1 on a single-port board. */
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			(dd->first_user_ctxt > dd->cfgctxts) ? 0 :
+			(dd->cfgctxts - dd->first_user_ctxt));
 }
 
 static ssize_t show_nfreectxts(struct device *device,


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
