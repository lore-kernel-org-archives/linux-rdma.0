From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] IB/qib: Fix potential buffer overrun in sending diag
 packet routine.
Date: Thu, 20 Feb 2014 11:02:48 -0500
Message-ID: <20140220160247.18021.8281.stgit@phlsvslse11.ph.intel.com>
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

Guards against a potential buffer overrun. Right now the qib driver is protected
by the fact that the data structure in question is only 16 bits. Should that
ever change the problem will be exposed. There is a similar defect in the ipath
driver and this brings the two code paths into sync.

Reported-by: Nico Golde <nico-d12P2N94aB+zQB+pC5nmwQ@public.gmane.org>
Reported-by: Fabian Yamaguchi <fabs-RB2+QK86ijKzQB+pC5nmwQ@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_diag.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_diag.c b/drivers/infiniband/hw/qib/qib_diag.c
index 1686fd4..07f9030 100644
--- a/drivers/infiniband/hw/qib/qib_diag.c
+++ b/drivers/infiniband/hw/qib/qib_diag.c
@@ -546,7 +546,7 @@ static ssize_t qib_diagpkt_write(struct file *fp,
 				 size_t count, loff_t *off)
 {
 	u32 __iomem *piobuf;
-	u32 plen, clen, pbufn;
+	u32 plen, pbufn, maxlen_reserve;
 	struct qib_diag_xpkt dp;
 	u32 *tmpbuf = NULL;
 	struct qib_devdata *dd;
@@ -590,15 +590,20 @@ static ssize_t qib_diagpkt_write(struct file *fp,
 	}
 	ppd = &dd->pport[dp.port - 1];
 
-	/* need total length before first word written */
-	/* +1 word is for the qword padding */
-	plen = sizeof(u32) + dp.len;
-	clen = dp.len >> 2;
-
-	if ((plen + 4) > ppd->ibmaxlen) {
+	/*
+	 * need total length before first word written, plus 2 Dwords. One Dword
+	 * is for padding so we get the full user data when not aligned on
+	 * a word boundary. The other Dword is to make sure we have room for the
+	 * ICRC which gets tacked on later.
+	 */
+	maxlen_reserve = 2 * sizeof(u32);
+	if (dp.len > ppd->ibmaxlen - maxlen_reserve) {
 		ret = -EINVAL;
-		goto bail;      /* before writing pbc */
+		goto bail;
 	}
+
+	plen = sizeof(u32) + dp.len;
+
 	tmpbuf = vmalloc(plen);
 	if (!tmpbuf) {
 		qib_devinfo(dd->pcidev,
@@ -638,11 +643,11 @@ static ssize_t qib_diagpkt_write(struct file *fp,
 	 */
 	if (dd->flags & QIB_PIO_FLUSH_WC) {
 		qib_flush_wc();
-		qib_pio_copy(piobuf + 2, tmpbuf, clen - 1);
+		qib_pio_copy(piobuf + 2, tmpbuf, plen - 1);
 		qib_flush_wc();
-		__raw_writel(tmpbuf[clen - 1], piobuf + clen + 1);
+		__raw_writel(tmpbuf[plen - 1], piobuf + plen + 1);
 	} else
-		qib_pio_copy(piobuf + 2, tmpbuf, clen);
+		qib_pio_copy(piobuf + 2, tmpbuf, plen);
 
 	if (dd->flags & QIB_USE_SPCL_TRIG) {
 		u32 spcl_off = (pbufn >= dd->piobcnt2k) ? 2047 : 1023;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
