From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 07/11] RDMA/cxgb4: Don't limit fastreg page list depth.
Date: Thu, 20 May 2010 16:57:59 -0500
Message-ID: <20100520215759.32394.77626.stgit@build.ogc.int>
References: <20100520215727.32394.90669.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100520215727.32394.90669.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/mem.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 993ed1f..7f94da1 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -759,9 +759,6 @@ struct ib_fast_reg_page_list *c4iw_alloc_fastreg_pbl(struct ib_device *device,
 	dma_addr_t dma_addr;
 	int size = sizeof *c4pl + page_list_len * sizeof(u64);
 
-	if (page_list_len > T4_MAX_FR_DEPTH)
-		return ERR_PTR(-EINVAL);
-
 	c4pl = dma_alloc_coherent(&dev->rdev.lldi.pdev->dev, size,
 				  &dma_addr, GFP_KERNEL);
 	if (!c4pl)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
