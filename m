From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 5/6] IB core: Fix ib_sg_to_pages()
Date: Tue, 1 Dec 2015 10:19:09 -0800
Message-ID: <565DE49D.4020102@sandisk.com>
References: <565DE3EC.2070002@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <565DE3EC.2070002-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix the code for detecting gaps and disable the code for chunking.
A gap occurs not only if the second or later scatterlist element
is not aligned but also if any scatterlist element other than the
last does not end at a page boundary. Disable the code for chunking.
Ensure that this function returns a negative error code instead of
zero if the first set_page() call fails.

Fixes: commit 4c67e2bfc8b7 ("IB/core: Introduce new fast registration API")
Reported-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.4+
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 043a60e..95836c6 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1530,10 +1530,9 @@ int ib_sg_to_pages(struct ib_mr *mr,
 		   int (*set_page)(struct ib_mr *, u64))
 {
 	struct scatterlist *sg;
-	u64 last_end_dma_addr = 0, last_page_addr = 0;
 	unsigned int last_page_off = 0;
 	u64 page_mask = ~((u64)mr->page_size - 1);
-	int i;
+	int i, ret;
 
 	mr->iova = sg_dma_address(&sgl[0]);
 	mr->length = 0;
@@ -1544,37 +1543,21 @@ int ib_sg_to_pages(struct ib_mr *mr,
 		u64 end_dma_addr = dma_addr + dma_len;
 		u64 page_addr = dma_addr & page_mask;
 
-		if (i && page_addr != dma_addr) {
-			if (last_end_dma_addr != dma_addr) {
-				/* gap */
-				goto done;
-
-			} else if (last_page_off + dma_len <= mr->page_size) {
-				/* chunk this fragment with the last */
-				mr->length += dma_len;
-				last_end_dma_addr += dma_len;
-				last_page_off += dma_len;
-				continue;
-			} else {
-				/* map starting from the next page */
-				page_addr = last_page_addr + mr->page_size;
-				dma_len -= mr->page_size - last_page_off;
-			}
-		}
+		/* gap */
+		if (i && (last_page_off || page_addr != dma_addr))
+			break;
 
 		do {
-			if (unlikely(set_page(mr, page_addr)))
-				goto done;
+			ret = set_page(mr, page_addr);
+			if (unlikely(ret < 0))
+				return i ? i : ret;
 			page_addr += mr->page_size;
 		} while (page_addr < end_dma_addr);
 
 		mr->length += dma_len;
-		last_end_dma_addr = end_dma_addr;
-		last_page_addr = end_dma_addr & page_mask;
 		last_page_off = end_dma_addr & ~page_mask;
 	}
 
-done:
 	return i;
 }
 EXPORT_SYMBOL(ib_sg_to_pages);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
