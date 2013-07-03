From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: fix module level leak
Date: Wed, 03 Jul 2013 13:50:28 -0400
Message-ID: <20130703175027.27786.2171.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The vzalloc()'ed field physshadow is leaked on module
unload.

This patch adds vfree after the sibling page shadow
is freed.

Reported-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index fdae429..36e048e 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1350,7 +1350,7 @@ static void cleanup_device_data(struct qib_devdata *dd)
 	if (dd->pageshadow) {
 		struct page **tmpp = dd->pageshadow;
 		dma_addr_t *tmpd = dd->physshadow;
-		int i, cnt = 0;
+		int i;
 
 		for (ctxt = 0; ctxt < dd->cfgctxts; ctxt++) {
 			int ctxt_tidbase = ctxt * dd->rcvtidcnt;
@@ -1363,13 +1363,13 @@ static void cleanup_device_data(struct qib_devdata *dd)
 					       PAGE_SIZE, PCI_DMA_FROMDEVICE);
 				qib_release_user_pages(&tmpp[i], 1);
 				tmpp[i] = NULL;
-				cnt++;
 			}
 		}
 
-		tmpp = dd->pageshadow;
 		dd->pageshadow = NULL;
 		vfree(tmpp);
+		dd->physshadow = NULL;
+		vfree(tmpd);
 	}
 
 	/*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
