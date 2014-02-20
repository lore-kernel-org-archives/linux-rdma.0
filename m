From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] IB/ipath: Fix potential buffer overrun in sending diag
 packet routine.
Date: Thu, 20 Feb 2014 11:02:53 -0500
Message-ID: <20140220160253.18021.55055.stgit@phlsvslse11.ph.intel.com>
References: <20140220160126.18021.69712.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140220160126.18021.69712.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Guards against a potential buffer overrun. The size to read from the user is
passed in, and due to the padding that needs to be taken into account, as
well as the place holder for the ICRC it is possible to overflow the 32bit
value which would cause more data to be copied from user space than is
allocated in the buffer.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Reported-by: Nico Golde <nico-d12P2N94aB+zQB+pC5nmwQ@public.gmane.org>
Reported-by: Fabian Yamaguchi <fabs-RB2+QK86ijKzQB+pC5nmwQ@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ipath/ipath_diag.c |   66 +++++++++++-------------------
 1 files changed, 25 insertions(+), 41 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_diag.c b/drivers/infiniband/hw/ipath/ipath_diag.c
index 714293b..e2f9a51 100644
--- a/drivers/infiniband/hw/ipath/ipath_diag.c
+++ b/drivers/infiniband/hw/ipath/ipath_diag.c
@@ -326,7 +326,7 @@ static ssize_t ipath_diagpkt_write(struct file *fp,
 				   size_t count, loff_t *off)
 {
 	u32 __iomem *piobuf;
-	u32 plen, clen, pbufn;
+	u32 plen, pbufn, maxlen_reserve;
 	struct ipath_diag_pkt odp;
 	struct ipath_diag_xpkt dp;
 	u32 *tmpbuf = NULL;
@@ -335,51 +335,29 @@ static ssize_t ipath_diagpkt_write(struct file *fp,
 	u64 val;
 	u32 l_state, lt_state; /* LinkState, LinkTrainingState */
 
-	if (count < sizeof(odp)) {
-		ret = -EINVAL;
-		goto bail;
-	}
 
 	if (count == sizeof(dp)) {
 		if (copy_from_user(&dp, data, sizeof(dp))) {
 			ret = -EFAULT;
 			goto bail;
 		}
-	} else if (copy_from_user(&odp, data, sizeof(odp))) {
-		ret = -EFAULT;
+	} else if (count == sizeof(odp)) {
+		if (copy_from_user(&odp, data, sizeof(odp))) {
+			ret = -EFAULT;
+			goto bail;
+		}
+	} else {
+		ret = -EINVAL;
 		goto bail;
 	}
 
-	/*
-	 * Due to padding/alignment issues (lessened with new struct)
-	 * the old and new structs are the same length. We need to
-	 * disambiguate them, which we can do because odp.len has never
-	 * been less than the total of LRH+BTH+DETH so far, while
-	 * dp.unit (same offset) unit is unlikely to get that high.
-	 * Similarly, dp.data, the pointer to user at the same offset
-	 * as odp.unit, is almost certainly at least one (512byte)page
-	 * "above" NULL. The if-block below can be omitted if compatibility
-	 * between a new driver and older diagnostic code is unimportant.
-	 * compatibility the other direction (new diags, old driver) is
-	 * handled in the diagnostic code, with a warning.
-	 */
-	if (dp.unit >= 20 && dp.data < 512) {
-		/* very probable version mismatch. Fix it up */
-		memcpy(&odp, &dp, sizeof(odp));
-		/* We got a legacy dp, copy elements to dp */
-		dp.unit = odp.unit;
-		dp.data = odp.data;
-		dp.len = odp.len;
-		dp.pbc_wd = 0; /* Indicate we need to compute PBC wd */
-	}
-
 	/* send count must be an exact number of dwords */
 	if (dp.len & 3) {
 		ret = -EINVAL;
 		goto bail;
 	}
 
-	clen = dp.len >> 2;
+	plen = dp.len >> 2;
 
 	dd = ipath_lookup(dp.unit);
 	if (!dd || !(dd->ipath_flags & IPATH_PRESENT) ||
@@ -422,16 +400,22 @@ static ssize_t ipath_diagpkt_write(struct file *fp,
 		goto bail;
 	}
 
-	/* need total length before first word written */
-	/* +1 word is for the qword padding */
-	plen = sizeof(u32) + dp.len;
-
-	if ((plen + 4) > dd->ipath_ibmaxlen) {
+	/*
+	 * need total length before first word written, plus 2 Dwords. One Dword
+	 * is for padding so we get the full user data when not aligned on
+	 * a word boundary. The other Dword is to make sure we have room for the
+	 * ICRC which gets tacked on later.
+	 */
+	maxlen_reserve = 2 * sizeof(u32);
+	if (dp.len > dd->ipath_ibmaxlen - maxlen_reserve) {
 		ipath_dbg("Pkt len 0x%x > ibmaxlen %x\n",
-			  plen - 4, dd->ipath_ibmaxlen);
+			  dp.len, dd->ipath_ibmaxlen);
 		ret = -EINVAL;
-		goto bail;	/* before writing pbc */
+		goto bail;
 	}
+
+	plen = sizeof(u32) + dp.len;
+
 	tmpbuf = vmalloc(plen);
 	if (!tmpbuf) {
 		dev_info(&dd->pcidev->dev, "Unable to allocate tmp buffer, "
@@ -473,11 +457,11 @@ static ssize_t ipath_diagpkt_write(struct file *fp,
 	 */
 	if (dd->ipath_flags & IPATH_PIO_FLUSH_WC) {
 		ipath_flush_wc();
-		__iowrite32_copy(piobuf + 2, tmpbuf, clen - 1);
+		__iowrite32_copy(piobuf + 2, tmpbuf, plen - 1);
 		ipath_flush_wc();
-		__raw_writel(tmpbuf[clen - 1], piobuf + clen + 1);
+		__raw_writel(tmpbuf[plen - 1], piobuf + plen + 1);
 	} else
-		__iowrite32_copy(piobuf + 2, tmpbuf, clen);
+		__iowrite32_copy(piobuf + 2, tmpbuf, plen);
 
 	ipath_flush_wc();
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
