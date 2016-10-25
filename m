From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/7] IB/hfi1: Get rid of divide in pio buffer allocator
Date: Tue, 25 Oct 2016 13:12:28 -0700
Message-ID: <20161025201228.15765.53426.stgit@scvm10.sc.intel.com>
References: <20161025194241.15765.8903.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161025194241.15765.8903.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The div instruction shows costly in profiles.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pio.c |   11 +++++++----
 drivers/infiniband/hw/hfi1/pio.h |    1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index e60fe3e..00a0e9e 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -1242,6 +1242,7 @@ int sc_enable(struct send_context *sc)
 	sc->free = 0;
 	sc->alloc_free = 0;
 	sc->fill = 0;
+	sc->fill_wrap = 0;
 	sc->sr_head = 0;
 	sc->sr_tail = 0;
 	sc->flags = 0;
@@ -1385,7 +1386,7 @@ struct pio_buf *sc_buffer_alloc(struct send_context *sc, u32 dw_len,
 	unsigned long flags;
 	unsigned long avail;
 	unsigned long blocks = dwords_to_blocks(dw_len);
-	unsigned long start_fill;
+	u32 fill_wrap;
 	int trycount = 0;
 	u32 head, next;
 
@@ -1428,8 +1429,11 @@ retry:
 	head = sc->sr_head;
 
 	/* "allocate" the buffer */
-	start_fill = sc->fill;
 	sc->fill += blocks;
+	fill_wrap = sc->fill_wrap;
+	sc->fill_wrap += blocks;
+	if (sc->fill_wrap >= sc->credits)
+		sc->fill_wrap = sc->fill_wrap - sc->credits;
 
 	/*
 	 * Fill the parts that the releaser looks at before moving the head.
@@ -1458,8 +1462,7 @@ retry:
 	spin_unlock_irqrestore(&sc->alloc_lock, flags);
 
 	/* finish filling in the buffer outside the lock */
-	pbuf->start = sc->base_addr + ((start_fill % sc->credits)
-							* PIO_BLOCK_SIZE);
+	pbuf->start = sc->base_addr + fill_wrap * PIO_BLOCK_SIZE;
 	pbuf->size = sc->credits * PIO_BLOCK_SIZE;
 	pbuf->end = sc->base_addr + pbuf->size;
 	pbuf->block_count = blocks;
diff --git a/drivers/infiniband/hw/hfi1/pio.h b/drivers/infiniband/hw/hfi1/pio.h
index bd19507..498b548 100644
--- a/drivers/infiniband/hw/hfi1/pio.h
+++ b/drivers/infiniband/hw/hfi1/pio.h
@@ -119,6 +119,7 @@ struct send_context {
 	unsigned long fill;		/* official alloc count */
 	unsigned long alloc_free;	/* copy of free (less cache thrash) */
 	u32 __percpu *buffers_allocated;/* count of buffers allocated */
+	u32 fill_wrap;			/* tracks fill within ring */
 	/* releaser fields */
 	spinlock_t release_lock ____cacheline_aligned_in_smp;
 	u32 sr_tail;			/* shadow ring tail */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
