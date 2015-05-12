From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V2] IB/qib: fix test of unsigned variable
Date: Tue, 12 May 2015 12:32:33 -0400
Message-ID: <20150512163233.26836.98544.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit d4988623cc60 ("IB/qib: use arch_phys_wc_add()")
adjusted mtrr inititialization to use the new interface.

Unfortunately, the new interface returns a signed
value and the patch tested the unsigned wc_cookie.

Fix the issue by changing the type of wc_cookie to int.  For
the success case the ret is changed to zero to avoid
a warning from the caller.  For failure wc_cookie
is used as the ret.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h           |    2 +-
 drivers/infiniband/hw/qib/qib_wc_x86_64.c |    8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index ba5173e2..7df16f7 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -903,7 +903,7 @@ struct qib_devdata {
 	/* PCI Device ID (here for NodeInfo) */
 	u16 deviceid;
 	/* for write combining settings */
-	unsigned long wc_cookie;
+	int wc_cookie;
 	unsigned long wc_base;
 	unsigned long wc_len;
 
diff --git a/drivers/infiniband/hw/qib/qib_wc_x86_64.c b/drivers/infiniband/hw/qib/qib_wc_x86_64.c
index 6d61ef9..2f2e15a 100644
--- a/drivers/infiniband/hw/qib/qib_wc_x86_64.c
+++ b/drivers/infiniband/hw/qib/qib_wc_x86_64.c
@@ -117,8 +117,12 @@ int qib_enable_wc(struct qib_devdata *dd)
 
 	if (!ret) {
 		dd->wc_cookie = arch_phys_wc_add(pioaddr, piolen);
-		if (dd->wc_cookie < 0)
-			ret = -EINVAL;
+		if (dd->wc_cookie >= 0)
+			/* insure no warning on success */
+			ret = 0;
+		else
+			/* use error from routine */
+			ret = dd->wc_cookie;
 	}
 
 	return ret;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
