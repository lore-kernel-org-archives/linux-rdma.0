From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: additional Intel branding changes
Date: Thu, 29 May 2014 15:46:09 -0400
Message-ID: <20140529194608.10870.66556.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Vinit Agnihotri <vinit.abhay.agnihotri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patches changes user visible function names containing "qlogic"
in module init and cleanup.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vinit Agnihotri <vinit.abhay.agnihotri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_init.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 5b7aeb2..8d3c78d 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1272,7 +1272,7 @@ static int qib_notify_dca(struct notifier_block *nb, unsigned long event,
  * Do all the generic driver unit- and chip-independent memory
  * allocation and initialization.
  */
-static int __init qlogic_ib_init(void)
+static int __init qib_ib_init(void)
 {
 	int ret;
 
@@ -1316,12 +1316,12 @@ bail:
 	return ret;
 }
 
-module_init(qlogic_ib_init);
+module_init(qib_ib_init);
 
 /*
  * Do the non-unit driver cleanup, memory free, etc. at unload.
  */
-static void __exit qlogic_ib_cleanup(void)
+static void __exit qib_ib_cleanup(void)
 {
 	int ret;
 
@@ -1346,7 +1346,7 @@ static void __exit qlogic_ib_cleanup(void)
 	qib_dev_cleanup();
 }
 
-module_exit(qlogic_ib_cleanup);
+module_exit(qib_ib_cleanup);
 
 /* this can only be called after a successful initialization */
 static void cleanup_device_data(struct qib_devdata *dd)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
