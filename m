From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/7] IB/hfi1: Optimize pio_buf and send_context structs
Date: Tue, 25 Oct 2016 13:12:34 -0700
Message-ID: <20161025201233.15765.61466.stgit@scvm10.sc.intel.com>
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

Both pio_buf and send_context structs have oversized
fields and have cachelines that can be optimized.

Reduce oversized fields for both structs.
Make sure pio_buf struct fits within a cacheline.
Move read-only fields to their own cacheline in
send_context struct.

All of this will avoid cacheline trading as the ring
progresses and pio buffers/send contexts are used.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pio.c      |    5 ++---
 drivers/infiniband/hw/hfi1/pio.h      |   29 +++++++++++++++--------------
 drivers/infiniband/hw/hfi1/pio_copy.c |   22 +++++++++++-----------
 3 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index 00a0e9e..92701f1 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -758,6 +758,7 @@ struct send_context *sc_alloc(struct hfi1_devdata *dd, int type,
 	sc->hw_context = hw_context;
 	cr_group_addresses(sc, &dma);
 	sc->credits = sci->credits;
+	sc->size = sc->credits * PIO_BLOCK_SIZE;
 
 /* PIO Send Memory Address details */
 #define PIO_ADDR_CONTEXT_MASK 0xfful
@@ -1463,9 +1464,7 @@ retry:
 
 	/* finish filling in the buffer outside the lock */
 	pbuf->start = sc->base_addr + fill_wrap * PIO_BLOCK_SIZE;
-	pbuf->size = sc->credits * PIO_BLOCK_SIZE;
-	pbuf->end = sc->base_addr + pbuf->size;
-	pbuf->block_count = blocks;
+	pbuf->end = sc->base_addr + sc->size;
 	pbuf->qw_written = 0;
 	pbuf->carry_bytes = 0;
 	pbuf->carry.val64 = 0;
diff --git a/drivers/infiniband/hw/hfi1/pio.h b/drivers/infiniband/hw/hfi1/pio.h
index 498b548..867e5ff 100644
--- a/drivers/infiniband/hw/hfi1/pio.h
+++ b/drivers/infiniband/hw/hfi1/pio.h
@@ -83,43 +83,43 @@ struct pio_buf {
 	void *arg;		/* argument for cb */
 	void __iomem *start;	/* buffer start address */
 	void __iomem *end;	/* context end address */
-	unsigned long size;	/* context size, in bytes */
 	unsigned long sent_at;	/* buffer is sent when <= free */
-	u32 block_count;	/* size of buffer, in blocks */
-	u32 qw_written;		/* QW written so far */
-	u32 carry_bytes;	/* number of valid bytes in carry */
 	union mix carry;	/* pending unwritten bytes */
+	u16 qw_written;		/* QW written so far */
+	u8 carry_bytes;	/* number of valid bytes in carry */
 };
 
 /* cache line aligned pio buffer array */
 union pio_shadow_ring {
 	struct pio_buf pbuf;
-	u64 unused[16];		/* cache line spacer */
 } ____cacheline_aligned;
 
 /* per-NUMA send context */
 struct send_context {
 	/* read-only after init */
 	struct hfi1_devdata *dd;		/* device */
-	void __iomem *base_addr;	/* start of PIO memory */
 	union pio_shadow_ring *sr;	/* shadow ring */
+	void __iomem *base_addr;	/* start of PIO memory */
+	u32 __percpu *buffers_allocated;/* count of buffers allocated */
+	u32 size;			/* context size, in bytes */
 
-	struct work_struct halt_work;	/* halted context work queue entry */
-	unsigned long flags;		/* flags */
 	int node;			/* context home node */
-	int type;			/* context type */
-	u32 sw_index;			/* software index number */
-	u32 hw_context;			/* hardware context number */
-	u32 credits;			/* number of blocks in context */
 	u32 sr_size;			/* size of the shadow ring */
-	u32 group;			/* credit return group */
+	u16 flags;			/* flags */
+	u8  type;			/* context type */
+	u8  sw_index;			/* software index number */
+	u8  hw_context;			/* hardware context number */
+	u8  group;			/* credit return group */
+
 	/* allocator fields */
 	spinlock_t alloc_lock ____cacheline_aligned_in_smp;
 	u32 sr_head;			/* shadow ring head */
 	unsigned long fill;		/* official alloc count */
 	unsigned long alloc_free;	/* copy of free (less cache thrash) */
-	u32 __percpu *buffers_allocated;/* count of buffers allocated */
 	u32 fill_wrap;			/* tracks fill within ring */
+	u32 credits;			/* number of blocks in context */
+	/* adding a new field here would make it part of this cacheline */
+
 	/* releaser fields */
 	spinlock_t release_lock ____cacheline_aligned_in_smp;
 	u32 sr_tail;			/* shadow ring tail */
@@ -131,6 +131,7 @@ struct send_context {
 	u32 credit_intr_count;		/* count of credit intr users */
 	u64 credit_ctrl;		/* cache for credit control */
 	wait_queue_head_t halt_wait;    /* wait until kernel sees interrupt */
+	struct work_struct halt_work;	/* halted context work queue entry */
 };
 
 /* send context flags */
diff --git a/drivers/infiniband/hw/hfi1/pio_copy.c b/drivers/infiniband/hw/hfi1/pio_copy.c
index aa77736..03024ce 100644
--- a/drivers/infiniband/hw/hfi1/pio_copy.c
+++ b/drivers/infiniband/hw/hfi1/pio_copy.c
@@ -129,8 +129,8 @@ void pio_copy(struct hfi1_devdata *dd, struct pio_buf *pbuf, u64 pbc,
 				dest += sizeof(u64);
 			}
 
-			dest -= pbuf->size;
-			dend -= pbuf->size;
+			dest -= pbuf->sc->size;
+			dend -= pbuf->sc->size;
 		}
 
 		/* write 8-byte non-SOP, non-wrap chunk data */
@@ -361,8 +361,8 @@ void seg_pio_copy_start(struct pio_buf *pbuf, u64 pbc,
 				dest += sizeof(u64);
 			}
 
-			dest -= pbuf->size;
-			dend -= pbuf->size;
+			dest -= pbuf->sc->size;
+			dend -= pbuf->sc->size;
 		}
 
 		/* write 8-byte non-SOP, non-wrap chunk data */
@@ -458,8 +458,8 @@ static void mid_copy_mix(struct pio_buf *pbuf, const void *from, size_t nbytes)
 			dest += sizeof(u64);
 		}
 
-		dest -= pbuf->size;
-		dend -= pbuf->size;
+		dest -= pbuf->sc->size;
+		dend -= pbuf->sc->size;
 	}
 
 	/* write 8-byte non-SOP, non-wrap chunk data */
@@ -492,7 +492,7 @@ static void mid_copy_mix(struct pio_buf *pbuf, const void *from, size_t nbytes)
 		 */
 		/* adjust if we have wrapped */
 		if (dest >= pbuf->end)
-			dest -= pbuf->size;
+			dest -= pbuf->sc->size;
 		/* jump to the SOP range if within the first block */
 		else if (pbuf->qw_written < PIO_BLOCK_QWS)
 			dest += SOP_DISTANCE;
@@ -584,8 +584,8 @@ static void mid_copy_straight(struct pio_buf *pbuf,
 			dest += sizeof(u64);
 		}
 
-		dest -= pbuf->size;
-		dend -= pbuf->size;
+		dest -= pbuf->sc->size;
+		dend -= pbuf->sc->size;
 	}
 
 	/* write 8-byte non-SOP, non-wrap chunk data */
@@ -666,7 +666,7 @@ void seg_pio_copy_mid(struct pio_buf *pbuf, const void *from, size_t nbytes)
 			 */
 			/* adjust if we've wrapped */
 			if (dest >= pbuf->end)
-				dest -= pbuf->size;
+				dest -= pbuf->sc->size;
 			/* jump to SOP range if within the first block */
 			else if (pbuf->qw_written < PIO_BLOCK_QWS)
 				dest += SOP_DISTANCE;
@@ -719,7 +719,7 @@ void seg_pio_copy_end(struct pio_buf *pbuf)
 	 */
 	/* adjust if we have wrapped */
 	if (dest >= pbuf->end)
-		dest -= pbuf->size;
+		dest -= pbuf->sc->size;
 	/* jump to the SOP range if within the first block */
 	else if (pbuf->qw_written < PIO_BLOCK_QWS)
 		dest += SOP_DISTANCE;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
