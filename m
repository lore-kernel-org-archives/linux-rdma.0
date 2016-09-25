From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/13] IB/hfi1: Combine shift copy and byte copy for SGE
 reads
Date: Sun, 25 Sep 2016 07:41:39 -0700
Message-ID: <20160925144137.10261.50915.stgit@scvm10.sc.intel.com>
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

Prevent over-reading the SGE length by using byte
reads for non quad-word reads.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pio_copy.c |  160 +++++----------------------------
 1 files changed, 23 insertions(+), 137 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pio_copy.c b/drivers/infiniband/hw/hfi1/pio_copy.c
index 7b0aa19..aa77736 100644
--- a/drivers/infiniband/hw/hfi1/pio_copy.c
+++ b/drivers/infiniband/hw/hfi1/pio_copy.c
@@ -165,9 +165,6 @@ void pio_copy(struct hfi1_devdata *dd, struct pio_buf *pbuf, u64 pbc,
 	preempt_enable();
 }
 
-/* USE_SHIFTS is faster in user-space tests on a Xeon X5570 @ 2.93GHz */
-#define USE_SHIFTS 1
-#ifdef USE_SHIFTS
 /*
  * Handle carry bytes using shifts and masks.
  *
@@ -187,126 +184,6 @@ void pio_copy(struct hfi1_devdata *dd, struct pio_buf *pbuf, u64 pbc,
 #define mshift(x) (8 * (x))
 
 /*
- * Read nbytes bytes from "from" and return them in the LSB bytes
- * of pbuf->carry.  Other bytes are zeroed.  Any previous value
- * pbuf->carry is lost.
- *
- * NOTES:
- * o do not read from from if nbytes is zero
- * o from may _not_ be u64 aligned
- * o nbytes must not span a QW boundary
- */
-static inline void read_low_bytes(struct pio_buf *pbuf, const void *from,
-				  unsigned int nbytes)
-{
-	unsigned long off;
-
-	if (nbytes == 0) {
-		pbuf->carry.val64 = 0;
-	} else {
-		/* align our pointer */
-		off = (unsigned long)from & 0x7;
-		from = (void *)((unsigned long)from & ~0x7l);
-		pbuf->carry.val64 = ((*(u64 *)from)
-				<< zshift(nbytes + off))/* zero upper bytes */
-				>> zshift(nbytes);	/* place at bottom */
-	}
-	pbuf->carry_bytes = nbytes;
-}
-
-/*
- * Read nbytes bytes from "from" and put them at the next significant bytes
- * of pbuf->carry.  Unused bytes are zeroed.  It is expected that the extra
- * read does not overfill carry.
- *
- * NOTES:
- * o from may _not_ be u64 aligned
- * o nbytes may span a QW boundary
- */
-static inline void read_extra_bytes(struct pio_buf *pbuf,
-				    const void *from, unsigned int nbytes)
-{
-	unsigned long off = (unsigned long)from & 0x7;
-	unsigned int room, xbytes;
-
-	/* align our pointer */
-	from = (void *)((unsigned long)from & ~0x7l);
-
-	/* check count first - don't read anything if count is zero */
-	while (nbytes) {
-		/* find the number of bytes in this u64 */
-		room = 8 - off;	/* this u64 has room for this many bytes */
-		xbytes = min(room, nbytes);
-
-		/*
-		 * shift down to zero lower bytes, shift up to zero upper
-		 * bytes, shift back down to move into place
-		 */
-		pbuf->carry.val64 |= (((*(u64 *)from)
-					>> mshift(off))
-					<< zshift(xbytes))
-					>> zshift(xbytes + pbuf->carry_bytes);
-		off = 0;
-		pbuf->carry_bytes += xbytes;
-		nbytes -= xbytes;
-		from += sizeof(u64);
-	}
-}
-
-/*
- * Write a quad word using parts of pbuf->carry and the next 8 bytes of src.
- * Put the unused part of the next 8 bytes of src into the LSB bytes of
- * pbuf->carry with the upper bytes zeroed..
- *
- * NOTES:
- * o result must keep unused bytes zeroed
- * o src must be u64 aligned
- */
-static inline void merge_write8(
-	struct pio_buf *pbuf,
-	void __iomem *dest,
-	const void *src)
-{
-	u64 new, temp;
-
-	new = *(u64 *)src;
-	temp = pbuf->carry.val64 | (new << mshift(pbuf->carry_bytes));
-	writeq(temp, dest);
-	pbuf->carry.val64 = new >> zshift(pbuf->carry_bytes);
-}
-
-/*
- * Write a quad word using all bytes of carry.
- */
-static inline void carry8_write8(union mix carry, void __iomem *dest)
-{
-	writeq(carry.val64, dest);
-}
-
-/*
- * Write a quad word using all the valid bytes of carry.  If carry
- * has zero valid bytes, nothing is written.
- * Returns 0 on nothing written, non-zero on quad word written.
- */
-static inline int carry_write8(struct pio_buf *pbuf, void __iomem *dest)
-{
-	if (pbuf->carry_bytes) {
-		/* unused bytes are always kept zeroed, so just write */
-		writeq(pbuf->carry.val64, dest);
-		return 1;
-	}
-
-	return 0;
-}
-
-#else /* USE_SHIFTS */
-/*
- * Handle carry bytes using byte copies.
- *
- * NOTE: the value the unused portion of carry is left uninitialized.
- */
-
-/*
  * Jump copy - no-loop copy for < 8 bytes.
  */
 static inline void jcopy(u8 *dest, const u8 *src, u32 n)
@@ -314,18 +191,25 @@ static inline void jcopy(u8 *dest, const u8 *src, u32 n)
 	switch (n) {
 	case 7:
 		*dest++ = *src++;
+		/* fall through */
 	case 6:
 		*dest++ = *src++;
+		/* fall through */
 	case 5:
 		*dest++ = *src++;
+		/* fall through */
 	case 4:
 		*dest++ = *src++;
+		/* fall through */
 	case 3:
 		*dest++ = *src++;
+		/* fall through */
 	case 2:
 		*dest++ = *src++;
+		/* fall through */
 	case 1:
 		*dest++ = *src++;
+		/* fall through */
 	}
 }
 
@@ -341,6 +225,7 @@ static inline void jcopy(u8 *dest, const u8 *src, u32 n)
 static inline void read_low_bytes(struct pio_buf *pbuf, const void *from,
 				  unsigned int nbytes)
 {
+	pbuf->carry.val64 = 0;
 	jcopy(&pbuf->carry.val8[0], from, nbytes);
 	pbuf->carry_bytes = nbytes;
 }
@@ -362,25 +247,30 @@ static inline void read_extra_bytes(struct pio_buf *pbuf,
 
 /*
  * Write a quad word using parts of pbuf->carry and the next 8 bytes of src.
- * Put the unused part of the next 8 bytes of src into the low bytes of
- * pbuf->carry.
+ * Put the unused part of the next 8 bytes of src into the LSB bytes of
+ * pbuf->carry with the upper bytes zeroed..
+ *
+ * NOTES:
+ * o result must keep unused bytes zeroed
+ * o src must be u64 aligned
  */
 static inline void merge_write8(
 	struct pio_buf *pbuf,
-	void *dest,
+	void __iomem *dest,
 	const void *src)
 {
-	u32 remainder = 8 - pbuf->carry_bytes;
+	u64 new, temp;
 
-	jcopy(&pbuf->carry.val8[pbuf->carry_bytes], src, remainder);
-	writeq(pbuf->carry.val64, dest);
-	jcopy(&pbuf->carry.val8[0], src + remainder, pbuf->carry_bytes);
+	new = *(u64 *)src;
+	temp = pbuf->carry.val64 | (new << mshift(pbuf->carry_bytes));
+	writeq(temp, dest);
+	pbuf->carry.val64 = new >> zshift(pbuf->carry_bytes);
 }
 
 /*
  * Write a quad word using all bytes of carry.
  */
-static inline void carry8_write8(union mix carry, void *dest)
+static inline void carry8_write8(union mix carry, void __iomem *dest)
 {
 	writeq(carry.val64, dest);
 }
@@ -390,20 +280,16 @@ static inline void carry8_write8(union mix carry, void *dest)
  * has zero valid bytes, nothing is written.
  * Returns 0 on nothing written, non-zero on quad word written.
  */
-static inline int carry_write8(struct pio_buf *pbuf, void *dest)
+static inline int carry_write8(struct pio_buf *pbuf, void __iomem *dest)
 {
 	if (pbuf->carry_bytes) {
-		u64 zero = 0;
-
-		jcopy(&pbuf->carry.val8[pbuf->carry_bytes], (u8 *)&zero,
-		      8 - pbuf->carry_bytes);
+		/* unused bytes are always kept zeroed, so just write */
 		writeq(pbuf->carry.val64, dest);
 		return 1;
 	}
 
 	return 0;
 }
-#endif /* USE_SHIFTS */
 
 /*
  * Segmented PIO Copy - start

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
