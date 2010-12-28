From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 15/24] IB/qib: Avoid duplicate writes to the rcv head register
Date: Tue, 28 Dec 2010 10:28:08 -0500
Message-ID: <20101228152808.19960.9415.stgit@kop-dev-sles11-04.qlogic.org>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101228152648.19960.84006.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Avoid duplicate writes to the head register as this can lead to lost interrupts
if the context goes full before the second write is done.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_driver.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 9cd1936..3ed0d5a 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -71,6 +71,11 @@ MODULE_DESCRIPTION("QLogic IB driver");
  */
 #define QIB_PIO_MAXIBHDR 128
 
+/*
+ * QIB_MAX_PKT_RCV is the max # if packets processed per receive interrupt.
+ */
+#define QIB_MAX_PKT_RECV 64
+
 struct qlogic_ib_stats qib_stats;
 
 const char *qib_get_unit_name(int unit)
@@ -335,7 +340,7 @@ u32 qib_kreceive(struct qib_ctxtdata *rcd, u32 *llic, u32 *npkts)
 		smp_rmb();  /* prevent speculative reads of dma'ed hdrq */
 	}
 
-	for (last = 0, i = 1; !last && i <= 64; i += !last) {
+	for (last = 0, i = 1; !last; i += !last) {
 		hdr = dd->f_get_msgheader(dd, rhf_addr);
 		eflags = qib_hdrget_err_flags(rhf_addr);
 		etype = qib_hdrget_rcv_type(rhf_addr);
@@ -384,6 +389,9 @@ move_along:
 		l += rsize;
 		if (l >= maxcnt)
 			l = 0;
+		if (i == QIB_MAX_PKT_RECV)
+			last = 1;
+
 		rhf_addr = (__le32 *) rcd->rcvhdrq + l + dd->rhf_offset;
 		if (dd->flags & QIB_NODMA_RTAIL) {
 			u32 seq = qib_hdrget_seq(rhf_addr);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
