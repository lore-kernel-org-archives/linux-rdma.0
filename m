From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next] IB/usnic: Use for_each_sg instead of a for-loop
Date: Thu,  9 Jan 2014 14:48:45 -0800
Message-ID: <1389307725-11670-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Depends on "[PATCH v1 for-next] IB/usnic: usNIC UDP Support" series.

Use for_each_sg instead of a explicit for-loop to iterate
over scatter-gather list.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_uiom.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 200941f..51e5b97 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -80,13 +80,14 @@ static void usnic_uiom_put_pages(struct list_head *chunk_list, int dirty)
 {
 	struct usnic_uiom_chunk *chunk, *tmp;
 	struct page *page;
+	struct scatterlist *sg;
 	int i;
 	dma_addr_t pa;

 	list_for_each_entry_safe(chunk, tmp, chunk_list, list) {
-		for (i = 0; i < chunk->nents; i++) {
-			page = sg_page(&chunk->page_list[i]);
-			pa = sg_phys(&chunk->page_list[i]);
+		for_each_sg(chunk->page_list, sg, chunk->nents, i) {
+			page = sg_page(sg);
+			pa = sg_phys(sg);
 			if (dirty)
 				set_page_dirty_lock(page);
 			put_page(page);
@@ -100,6 +101,7 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
 				int dmasync, struct list_head *chunk_list)
 {
 	struct page **page_list;
+	struct scatterlist *sg;
 	struct usnic_uiom_chunk *chunk;
 	unsigned long locked;
 	unsigned long lock_limit;
@@ -165,11 +167,10 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,

 			chunk->nents = min_t(int, ret, USNIC_UIOM_PAGE_CHUNK);
 			sg_init_table(chunk->page_list, chunk->nents);
-			for (i = 0; i < chunk->nents; ++i) {
-				sg_set_page(&chunk->page_list[i],
-							page_list[i + off],
-							PAGE_SIZE, 0);
-				pa = sg_phys(&chunk->page_list[i]);
+			for_each_sg(chunk->page_list, sg, chunk->nents, i) {
+				sg_set_page(sg, page_list[i + off],
+						PAGE_SIZE, 0);
+				pa = sg_phys(sg);
 				usnic_dbg("va: 0x%lx pa: %pa\n",
 						cur_base + i*PAGE_SIZE, &pa);
 			}
--
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
