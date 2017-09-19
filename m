From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 02/10] cxgb4: Move sysconf up to driver_init
Date: Tue, 19 Sep 2017 15:18:43 -0600
Message-ID: <1505855931-4956-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505855931-4956-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This follows the pattern of the rest of the providers and lets us
use the PROVIDER_DRIVER macro.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/cxgb4/dev.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/providers/cxgb4/dev.c b/providers/cxgb4/dev.c
index fea9b5527072ec..492b3978995607 100644
--- a/providers/cxgb4/dev.c
+++ b/providers/cxgb4/dev.c
@@ -466,6 +466,10 @@ found:
 	PDBG("%s found vendor %d device %d type %d\n",
 	     __FUNCTION__, vendor, device, CHELSIO_CHIP_VERSION(hca_table[i].device >> 8));
 
+	c4iw_page_size = sysconf(_SC_PAGESIZE);
+	c4iw_page_shift = long_log2(c4iw_page_size);
+	c4iw_page_mask = ~(c4iw_page_size - 1);
+
 	dev = calloc(1, sizeof *dev);
 	if (!dev) {
 		return NULL;
@@ -515,14 +519,7 @@ static const struct verbs_device_ops c4iw_dev_ops = {
 	.alloc_context = c4iw_alloc_context,
 	.free_context = c4iw_free_context,
 };
-
-static __attribute__((constructor)) void cxgb4_register_driver(void)
-{
-	c4iw_page_size = sysconf(_SC_PAGESIZE);
-	c4iw_page_shift = long_log2(c4iw_page_size);
-	c4iw_page_mask = ~(c4iw_page_size - 1);
-	verbs_register_driver(&c4iw_dev_ops);
-}
+PROVIDER_DRIVER(c4iw_dev_ops);
 
 #ifdef STATS
 void __attribute__ ((destructor)) cs_fini(void);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
