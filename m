From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: [PATCH] ipath: remove unreachable code
Date: Thu, 25 Oct 2012 15:27:07 +0100
Message-ID: <20121025142702.16785.26605.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Alan Cox <alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Signed-off-by: Alan Cox <alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---

 drivers/infiniband/hw/ipath/ipath_init_chip.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_init_chip.c b/drivers/infiniband/hw/ipath/ipath_init_chip.c
index 49b09c6..be2a60e 100644
--- a/drivers/infiniband/hw/ipath/ipath_init_chip.c
+++ b/drivers/infiniband/hw/ipath/ipath_init_chip.c
@@ -719,16 +719,6 @@ int ipath_init_chip(struct ipath_devdata *dd, int reinit)
 		goto done;
 
 	/*
-	 * we ignore most issues after reporting them, but have to specially
-	 * handle hardware-disabled chips.
-	 */
-	if (ret == 2) {
-		/* unique error, known to ipath_init_one */
-		ret = -EPERM;
-		goto done;
-	}
-
-	/*
 	 * We could bump this to allow for full rcvegrcnt + rcvtidcnt,
 	 * but then it no longer nicely fits power of two, and since
 	 * we now use routines that backend onto __get_free_pages, the

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
