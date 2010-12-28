From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 16/24] IB/qib: interrupt mitigation fix
Date: Tue, 28 Dec 2010 10:28:13 -0500
Message-ID: <20101228152813.19960.45901.stgit@kop-dev-sles11-04.qlogic.org>
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

For SusieQ we need to write to the interrupt timer register before updating the
header queue head with interrupt count. This is to ensure that the timer is
enabled properly and a receive available interrupt is delivered else this
interrupt can be lost if the receiver header/eager queues are full before the
timer is enabled.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h         |    2 +-
 drivers/infiniband/hw/qib/qib_driver.c  |    4 ++--
 drivers/infiniband/hw/qib/qib_iba6120.c |    2 +-
 drivers/infiniband/hw/qib/qib_iba7220.c |    2 +-
 drivers/infiniband/hw/qib/qib_iba7322.c |   10 +++++++---
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 64c9e7d..73225ee 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -766,7 +766,7 @@ struct qib_devdata {
 	void (*f_sdma_hw_start_up)(struct qib_pportdata *);
 	void (*f_sdma_init_early)(struct qib_pportdata *);
 	void (*f_set_cntr_sample)(struct qib_pportdata *, u32, u32);
-	void (*f_update_usrhead)(struct qib_ctxtdata *, u64, u32, u32);
+	void (*f_update_usrhead)(struct qib_ctxtdata *, u64, u32, u32, u32);
 	u32 (*f_hdrqempty)(struct qib_ctxtdata *);
 	u64 (*f_portcntr)(struct qib_pportdata *, u32);
 	u32 (*f_read_cntrs)(struct qib_devdata *, loff_t, char **,
diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 3ed0d5a..816a6bd 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -410,7 +410,7 @@ move_along:
 		 */
 		lval = l;
 		if (!last && !(i & 0xf)) {
-			dd->f_update_usrhead(rcd, lval, updegr, etail);
+			dd->f_update_usrhead(rcd, lval, updegr, etail, i);
 			updegr = 0;
 		}
 	}
@@ -452,7 +452,7 @@ bail:
 	 * if no packets were processed.
 	 */
 	lval = (u64)rcd->head | dd->rhdrhead_intr_off;
-	dd->f_update_usrhead(rcd, lval, updegr, etail);
+	dd->f_update_usrhead(rcd, lval, updegr, etail, i);
 	return crcs;
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index a5e29db..774dea8 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -2074,7 +2074,7 @@ static void qib_6120_config_ctxts(struct qib_devdata *dd)
 }
 
 static void qib_update_6120_usrhead(struct qib_ctxtdata *rcd, u64 hd,
-				    u32 updegr, u32 egrhd)
+				    u32 updegr, u32 egrhd, u32 npkts)
 {
 	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
 	if (updegr)
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index 6fd8d74..df49e8e 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -2703,7 +2703,7 @@ static int qib_7220_set_loopback(struct qib_pportdata *ppd, const char *what)
 }
 
 static void qib_update_7220_usrhead(struct qib_ctxtdata *rcd, u64 hd,
-				    u32 updegr, u32 egrhd)
+				    u32 updegr, u32 egrhd, u32 npkts)
 {
 	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
 	if (updegr)
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index a9c8c72..9bc6d08 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -2823,7 +2823,6 @@ static irqreturn_t qib_7322intr(int irq, void *data)
 				ctxtrbits &= ~rmask;
 				if (dd->rcd[i]) {
 					qib_kreceive(dd->rcd[i], NULL, &npkts);
-					adjust_rcv_timeout(dd->rcd[i], npkts);
 				}
 			}
 			rmask <<= 1;
@@ -2873,7 +2872,6 @@ static irqreturn_t qib_7322pintr(int irq, void *data)
 		       (1ULL << QIB_I_RCVURG_LSB)) << rcd->ctxt);
 
 	qib_kreceive(rcd, NULL, &npkts);
-	adjust_rcv_timeout(rcd, npkts);
 
 	return IRQ_HANDLED;
 }
@@ -4047,8 +4045,14 @@ static int qib_7322_set_ib_table(struct qib_pportdata *ppd, int which, void *t)
 }
 
 static void qib_update_7322_usrhead(struct qib_ctxtdata *rcd, u64 hd,
-				    u32 updegr, u32 egrhd)
+				    u32 updegr, u32 egrhd, u32 npkts)
 {
+	/*
+	 * Need to write timeout register before updating rcvhdrhead to ensure
+	 * that the timer is enabled on reception of a packet.
+	 */
+	if (hd >> IBA7322_HDRHEAD_PKTINT_SHIFT)
+		adjust_rcv_timeout(rcd, npkts);
 	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
 	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
 	if (updegr)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
