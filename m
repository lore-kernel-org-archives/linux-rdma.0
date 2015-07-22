From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/cxgb3: fail get_dma_mr if the memory footprint can
	exceed 32b
Date: Wed, 22 Jul 2015 14:14:17 -0500
Message-ID: <20150722191417.9306.17387.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

T3 HW only supports MRs of length < 4GB.  If the system can have more
than that we need to fail dma mr allocation so we con't create a MR that
cannot span the entire possible memory space.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb3/iwch_provider.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index b1b7323..bbbe018 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -736,6 +736,10 @@ static struct ib_mr *iwch_get_dma_mr(struct ib_pd *pd, int acc)
 	/*
 	 * T3 only supports 32 bits of size.
 	 */
+	if (sizeof(phys_addr_t) > 4) {
+		pr_warn_once(MOD "Cannot support dma_mrs on this platform.\n");
+		return ERR_PTR(-ENOTSUPP);
+	}
 	bl.size = 0xffffffff;
 	bl.addr = 0;
 	kva = 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
