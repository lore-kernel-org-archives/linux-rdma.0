From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: srp state in current mainline
Date: Wed, 25 Nov 2015 17:17:38 -0800
Message-ID: <56565DB2.5090505@sandisk.com>
References: <20151110171509.GA27781@infradead.org>
 <20151122135343.GA11703@infradead.org> <20151122143215.GA14667@infradead.org>
 <5651D775.9090500@dev.mellanox.co.il> <20151122151034.GA29240@infradead.org>
 <5651DEA4.8040506@dev.mellanox.co.il> <20151122153106.GA26919@infradead.org>
 <5653B9E8.7020907@sandisk.com> <56560D46.1070904@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56560D46.1070904-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/25/2015 11:34 AM, Bart Van Assche wrote:
> On 11/23/2015 05:14 PM, Bart Van Assche wrote:
>> On 11/22/2015 07:31 AM, Christoph Hellwig wrote:
>>> On Sun, Nov 22, 2015 at 05:26:28PM +0200, Sagi Grimberg wrote:
>>>>> No. register_always=Y is already broken in 4.3, but
>>>>> register_always=N is
>>>>> now also broken in 4.4.
>>>>
>>>> OK, I'm confused so please let me understand slowly :)
>>>>
>>>> Your patch "ib_srp: initialize dma_length in srp_map_idb" solves
>>>> the register_always=Y dma_length = 0 WARN_ON() on 4.4-rc, does it solve
>>>> the data integrity errors too?
>>>
>>> No, it doesn't.
>>>
>>>> This code path is specific to srp because all other ULPs guarantee
>>>> no-gaps...
>>>
>>> Yes.  Life would be simpler if we could just set the virt_boundary
>>> on SRP, and Bart has indicated that he's willing to at least looks at
>>> this for the next merge window.
>>
>> Hello Christoph,
>>
>> Tomorrow I will try to reproduce this behavior on my test setup. I
>> prepared a setup with kernel v4.4-rc2 and on which the SRP initiator and
>> target are running on the same server. Tomorrow I will install xfstests
>> and see whether these tests pass fine against an XFS filesystem.
> 
> (replying to my own e-mail)
> 
> I can reproduce this behavior with both LIO and SCST. I have modified
> initiator and target code such that the target appends a data CRC at the
> end of the SRP_RSP IU and such that the initiator checks that CRC. A CRC
> mismatch was reported for the following SG-list by the initiator:
> 
> scsi host10: srp_check_crc: bufflen 1024; resid 0; sg-list len 2; dir
> DMA_TO_DEVICE; CRC mismatch (0x7916620b <> 0xde97b796); sg-list:
> [0] ffff880407378348 len 512
> [1] ffff880407378000 len 512
> 
> I will check the memory registration code next.

(again replying to my own e-mail)

The patch below helps somewhat but is not sufficient to make the XFS tests
pass. On Monday I will continue to work on this.

Bart.

[PATCH] IB core: Fix ib_sg_to_pages()

Fix the code for detecting gaps and disable the code for chunking.

Fixes: "IB/core: Introduce new fast registration API" (commit 4c67e2bfc8b7)
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 043a60e..3f9c820 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1530,7 +1530,6 @@ int ib_sg_to_pages(struct ib_mr *mr,
 		   int (*set_page)(struct ib_mr *, u64))
 {
 	struct scatterlist *sg;
-	u64 last_end_dma_addr = 0, last_page_addr = 0;
 	unsigned int last_page_off = 0;
 	u64 page_mask = ~((u64)mr->page_size - 1);
 	int i;
@@ -1544,23 +1543,9 @@ int ib_sg_to_pages(struct ib_mr *mr,
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
+			goto done;
 
 		do {
 			if (unlikely(set_page(mr, page_addr)))
@@ -1569,8 +1554,6 @@ int ib_sg_to_pages(struct ib_mr *mr,
 		} while (page_addr < end_dma_addr);
 
 		mr->length += dma_len;
-		last_end_dma_addr = end_dma_addr;
-		last_page_addr = end_dma_addr & page_mask;
 		last_page_off = end_dma_addr & ~page_mask;
 	}
 
-- 
2.1.4



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
