From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: fix sparse warnings in qib_user_sdma.c
Date: Tue, 13 Aug 2013 15:34:38 -0400
Message-ID: <20130813193438.28760.26439.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit fd1b423 ("IB/qib: Improve SDMA performance") introduced
some new sparse warnings.

This patch eliminates all sparse warnings in this file.

Reported-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_user_sdma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index 0544166..d0a0ea0 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -222,7 +222,7 @@ static int qib_user_sdma_page_to_frags(const struct qib_devdata *dd,
 				       struct page *page, u16 put,
 				       u16 offset, u16 len, void *kvaddr)
 {
-	u16 *pbc16;
+	__le16 *pbc16;
 	void *pbcvaddr;
 	struct qib_message_header *hdr;
 	u16 newlen, pbclen, lastdesc, dma_mapped;
@@ -610,7 +610,7 @@ static int qib_user_sdma_pin_pages(const struct qib_devdata *dd,
 				(PAGE_SIZE - fofs) : tlen;
 
 			ret = qib_user_sdma_page_to_frags(dd, pq, pkt,
-				pages[i], 1, fofs, flen, 0);
+				pages[i], 1, fofs, flen, NULL);
 			if (ret < 0) {
 				/* current page has beed taken
 				 * care of inside above call.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
