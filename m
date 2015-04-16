From: Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 2/2] IB/core: dma unmap optimizations
Date: Thu, 16 Apr 2015 16:11:03 +0300
Message-ID: <1429189863-16460-3-git-send-email-guysh@mellanox.com>
References: <1429189863-16460-1-git-send-email-guysh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429189863-16460-1-git-send-email-guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

While unmapping an ODP writable page, the dirty bit of the page is set. In
order to do so, the head of the compound page is found.
Currently, the compound head is found even on non-writable pages, where it is
never used, leading to unnecessary cpu barrier that impacts performance.

This patch moves the search for the compound head to be done only when needed.

Signed-off-by: Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/umem_odp.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index aba4739..cc6e604 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -637,7 +637,6 @@ void ib_umem_odp_unmap_dma_pages(struct ib_umem *umem, u64 virt,
 		idx = (addr - ib_umem_start(umem)) / PAGE_SIZE;
 		if (umem->odp_data->page_list[idx]) {
 			struct page *page = umem->odp_data->page_list[idx];
-			struct page *head_page = compound_head(page);
 			dma_addr_t dma = umem->odp_data->dma_list[idx];
 			dma_addr_t dma_addr = dma & ODP_DMA_ADDR_MASK;
 
@@ -655,7 +654,7 @@ void ib_umem_odp_unmap_dma_pages(struct ib_umem *umem, u64 virt,
 				 * continuing and allowing the page mapping to
 				 * be removed.
 				 */
-				set_page_dirty(head_page);
+				set_page_dirty(compound_head(page));
 			/* on demand pinning support */
 			if (!umem->context->invalidate_range)
 				put_page(page);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
