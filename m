From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 5/6] IB core: Fix ib_sg_to_pages()
Date: Thu, 3 Dec 2015 16:04:17 -0800
Message-ID: <5660D881.7020801@sandisk.com>
References: <565DE3EC.2070002@sandisk.com> <565DE49D.4020102@sandisk.com>
 <565DE7D0.4080408@dev.mellanox.co.il> <565DF0A5.6040102@sandisk.com>
 <565EBA78.3050201@dev.mellanox.co.il> <565FA75E.7010100@sandisk.com>
 <20151203091806.GB21893@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151203091806.GB21893-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/03/2015 01:18 AM, Christoph Hellwig wrote:
> The patch looks good to me, but while we touch this area, how about
> throwing in a few cosmetic fixes as well?
 
How about the patch below ? In that version of the ib_sg_to_pages() fix
these concerns have been addressed and additionally to more bugs have been fixed.

------------

[PATCH] IB core: Fix ib_sg_to_pages()

Fix the code for detecting gaps. A gap occurs not only if the
second or later scatterlist element is not aligned but also if
any scatterlist element other than the last does not end at a
page boundary.

In the code for coalescing contiguous elements, ensure that
mr->length is correct and that last_page_addr is up-to-date.

Ensure that this function returns a negative
error code instead of zero if the first set_page() call fails.

Fixes: commit 4c67e2bfc8b7 ("IB/core: Introduce new fast registration API")
Reported-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 43 +++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 043a60e..545906d 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1516,7 +1516,7 @@ EXPORT_SYMBOL(ib_map_mr_sg);
  * @sg_nents:      number of entries in sg
  * @set_page:      driver page assignment function pointer
  *
- * Core service helper for drivers to covert the largest
+ * Core service helper for drivers to convert the largest
  * prefix of given sg list to a page vector. The sg list
  * prefix converted is the prefix that meet the requirements
  * of ib_map_mr_sg.
@@ -1533,7 +1533,7 @@ int ib_sg_to_pages(struct ib_mr *mr,
 	u64 last_end_dma_addr = 0, last_page_addr = 0;
 	unsigned int last_page_off = 0;
 	u64 page_mask = ~((u64)mr->page_size - 1);
-	int i;
+	int i, ret;
 
 	mr->iova = sg_dma_address(&sgl[0]);
 	mr->length = 0;
@@ -1544,27 +1544,29 @@ int ib_sg_to_pages(struct ib_mr *mr,
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
+		/*
+		 * For the second and later elements, check whether either the
+		 * end of element i-1 or the start of element i is not aligned
+		 * on a page boundary.
+		 */
+		if (i && (last_page_off != 0 || page_addr != dma_addr)) {
+			/* Stop mapping if there is a gap. */
+			if (last_end_dma_addr != dma_addr)
+				break;
+
+			/*
+			 * Coalesce this element with the last. If it is small
+			 * enough just update mr->length. Otherwise start
+			 * mapping from the next page.
+			 */
+			goto next_page;
 		}
 
 		do {
-			if (unlikely(set_page(mr, page_addr)))
-				goto done;
+			ret = set_page(mr, page_addr);
+			if (unlikely(ret < 0))
+				return i ? : ret;
+next_page:
 			page_addr += mr->page_size;
 		} while (page_addr < end_dma_addr);
 
@@ -1574,7 +1576,6 @@ int ib_sg_to_pages(struct ib_mr *mr,
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
