From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/13] IB/hfi1: Do not read more than a SGE length
Date: Sun, 25 Sep 2016 07:41:32 -0700
Message-ID: <20160925144130.10261.67581.stgit@scvm10.sc.intel.com>
References: <20160925143656.10261.85231.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925143656.10261.85231.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In certain cases, if the tail of an SGE is not
8-byte aligned, bytes beyond the end to an 8-byte
alignment can be read. Change the copy routine
to avoid the over-read. Instead, stop on the final
whole quad-word, then read the remaining bytes.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pio_copy.c |   88 +++++++++++++++------------------
 1 files changed, 40 insertions(+), 48 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pio_copy.c b/drivers/infiniband/hw/hfi1/pio_copy.c
index 3a1ef30..7b0aa19 100644
--- a/drivers/infiniband/hw/hfi1/pio_copy.c
+++ b/drivers/infiniband/hw/hfi1/pio_copy.c
@@ -254,30 +254,6 @@ static inline void read_extra_bytes(struct pio_buf *pbuf,
 }
 
 /*
- * Zero extra bytes from the end of pbuf->carry.
- *
- * NOTES:
- * o zbytes <= old_bytes
- */
-static inline void zero_extra_bytes(struct pio_buf *pbuf, unsigned int zbytes)
-{
-	unsigned int remaining;
-
-	if (zbytes == 0)	/* nothing to do */
-		return;
-
-	remaining = pbuf->carry_bytes - zbytes;	/* remaining bytes */
-
-	/* NOTE: zshift only guaranteed to work if remaining != 0 */
-	if (remaining)
-		pbuf->carry.val64 = (pbuf->carry.val64 << zshift(remaining))
-					>> zshift(remaining);
-	else
-		pbuf->carry.val64 = 0;
-	pbuf->carry_bytes = remaining;
-}
-
-/*
  * Write a quad word using parts of pbuf->carry and the next 8 bytes of src.
  * Put the unused part of the next 8 bytes of src into the LSB bytes of
  * pbuf->carry with the upper bytes zeroed..
@@ -385,20 +361,6 @@ static inline void read_extra_bytes(struct pio_buf *pbuf,
 }
 
 /*
- * Zero extra bytes from the end of pbuf->carry.
- *
- * We do not care about the value of unused bytes in carry, so just
- * reduce the byte count.
- *
- * NOTES:
- * o zbytes <= old_bytes
- */
-static inline void zero_extra_bytes(struct pio_buf *pbuf, unsigned int zbytes)
-{
-	pbuf->carry_bytes -= zbytes;
-}
-
-/*
  * Write a quad word using parts of pbuf->carry and the next 8 bytes of src.
  * Put the unused part of the next 8 bytes of src into the low bytes of
  * pbuf->carry.
@@ -550,8 +512,8 @@ static void mid_copy_mix(struct pio_buf *pbuf, const void *from, size_t nbytes)
 {
 	void __iomem *dest = pbuf->start + (pbuf->qw_written * sizeof(u64));
 	void __iomem *dend;			/* 8-byte data end */
-	unsigned long qw_to_write = (pbuf->carry_bytes + nbytes) >> 3;
-	unsigned long bytes_left = (pbuf->carry_bytes + nbytes) & 0x7;
+	unsigned long qw_to_write = nbytes >> 3;
+	unsigned long bytes_left = nbytes & 0x7;
 
 	/* calculate 8-byte data end */
 	dend = dest + (qw_to_write * sizeof(u64));
@@ -621,16 +583,46 @@ static void mid_copy_mix(struct pio_buf *pbuf, const void *from, size_t nbytes)
 		dest += sizeof(u64);
 	}
 
-	/* adjust carry */
-	if (pbuf->carry_bytes < bytes_left) {
-		/* need to read more */
-		read_extra_bytes(pbuf, from, bytes_left - pbuf->carry_bytes);
+	pbuf->qw_written += qw_to_write;
+
+	/* handle carry and left-over bytes */
+	if (pbuf->carry_bytes + bytes_left >= 8) {
+		unsigned long nread;
+
+		/* there is enough to fill another qw - fill carry */
+		nread = 8 - pbuf->carry_bytes;
+		read_extra_bytes(pbuf, from, nread);
+
+		/*
+		 * One more write - but need to make sure dest is correct.
+		 * Check for wrap and the possibility the write
+		 * should be in SOP space.
+		 *
+		 * The two checks immediately below cannot both be true, hence
+		 * the else. If we have wrapped, we cannot still be within the
+		 * first block. Conversely, if we are still in the first block,
+		 * we cannot have wrapped. We do the wrap check first as that
+		 * is more likely.
+		 */
+		/* adjust if we have wrapped */
+		if (dest >= pbuf->end)
+			dest -= pbuf->size;
+		/* jump to the SOP range if within the first block */
+		else if (pbuf->qw_written < PIO_BLOCK_QWS)
+			dest += SOP_DISTANCE;
+
+		/* flush out full carry */
+		carry8_write8(pbuf->carry, dest);
+		pbuf->qw_written++;
+
+		/* now adjust and read the rest of the bytes into carry */
+		bytes_left -= nread;
+		from += nread; /* from is now not aligned */
+		read_low_bytes(pbuf, from, bytes_left);
 	} else {
-		/* remove invalid bytes */
-		zero_extra_bytes(pbuf, pbuf->carry_bytes - bytes_left);
+		/* not enough to fill another qw, append the rest to carry */
+		read_extra_bytes(pbuf, from, bytes_left);
 	}
-
-	pbuf->qw_written += qw_to_write;
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
