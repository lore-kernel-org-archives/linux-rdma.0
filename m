From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 5/6] IB core: Fix ib_sg_to_pages()
Date: Wed, 2 Dec 2015 18:22:22 -0800
Message-ID: <565FA75E.7010100@sandisk.com>
References: <565DE3EC.2070002@sandisk.com> <565DE49D.4020102@sandisk.com>
 <565DE7D0.4080408@dev.mellanox.co.il> <565DF0A5.6040102@sandisk.com>
 <565EBA78.3050201@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <565EBA78.3050201-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/02/2015 01:31 AM, Sagi Grimberg wrote:
> On 01/12/2015 21:10, Bart Van Assche wrote:
>> On 12/01/2015 10:32 AM, Sagi Grimberg wrote:
>> How ib_sg_to_pages() reports to its caller that mapping the first
>> scatterlist element failed is not important to me. I included that
>> change in this patch because I noticed that in the upstream SRP
>> initiator does not consider ib_map_mr_sg() returning zero as an error. I
>> think either ib_sg_to_pages() or ib_map_mr_sg() should be modified such
>> that "no pages have been mapped" is handled as a mapping failure.
>
> I don't either, but the patch introduces inconsistency in a case where
> the caller passed sg_nents=0 (which will return 0 and not -errno).
>
> Would it make better sense to have srp treat 0 return as error? note
> that all other ULPs treat return_val != sg_nents as error.

Hello Sagi,

Hmm ... why would it be unacceptable to return 0 if sg_nents == 0 ?

Regarding which component to modify if mapping the first page fails:
for almost every kernel function I know a negative return value means
failure and a return value >= 0 means success. Hence my proposal to
change the return value of the ib_map_mr_sg() function if mapping the
first page fails.

How about the patch below ?

Bart.



[PATCH] IB core: Fix ib_sg_to_pages()

Fix the code for detecting gaps. A gap occurs not only if the
second or later scatterlist element is not aligned but also if
any scatterlist element other than the last does not end at a
page boundary. Ensure that this function returns a negative
error code instead of zero if the first set_page() call fails.

Fixes: commit 4c67e2bfc8b7 ("IB/core: Introduce new fast registration API")
Reported-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 043a60e..1972c50 100644
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
@@ -1544,11 +1544,10 @@ int ib_sg_to_pages(struct ib_mr *mr,
 		u64 end_dma_addr = dma_addr + dma_len;
 		u64 page_addr = dma_addr & page_mask;
 
-		if (i && page_addr != dma_addr) {
+		if (i && (page_addr != dma_addr || last_page_off != 0)) {
 			if (last_end_dma_addr != dma_addr) {
 				/* gap */
-				goto done;
-
+				break;
 			} else if (last_page_off + dma_len <= mr->page_size) {
 				/* chunk this fragment with the last */
 				mr->length += dma_len;
@@ -1563,8 +1562,9 @@ int ib_sg_to_pages(struct ib_mr *mr,
 		}
 
 		do {
-			if (unlikely(set_page(mr, page_addr)))
-				goto done;
+			ret = set_page(mr, page_addr);
+			if (unlikely(ret < 0))
+				return i ? : ret;
 			page_addr += mr->page_size;
 		} while (page_addr < end_dma_addr);
 
@@ -1574,7 +1574,6 @@ int ib_sg_to_pages(struct ib_mr *mr,
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
