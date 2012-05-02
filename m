From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: add prefetch for eager buffers
Date: Wed, 2 May 2012 11:21:53 -0400
Message-ID: <20120502152153.29126.96770.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When a packet is been stored, add the prefetch call.

The nature of the prefetch is correctly determined by
the alternatives mechanism.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_driver.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 6fc9365..8895cfe 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -38,6 +38,7 @@
 #include <linux/netdevice.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
+#include <linux/prefetch.h>
 
 #include "qib.h"
 
@@ -481,8 +482,10 @@ u32 qib_kreceive(struct qib_ctxtdata *rcd, u32 *llic, u32 *npkts)
 			etail = qib_hdrget_index(rhf_addr);
 			updegr = 1;
 			if (tlen > sizeof(*hdr) ||
-			    etype >= RCVHQ_RCV_TYPE_NON_KD)
+			    etype >= RCVHQ_RCV_TYPE_NON_KD) {
 				ebuf = qib_get_egrbuf(rcd, etail);
+				prefetch_range(ebuf, tlen - sizeof(*hdr));
+			}
 		}
 		if (!eflags) {
 			u16 lrh_len = be16_to_cpu(hdr->lrh[2]) << 2;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
