From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Fix a possible data corruption when receiving packets.
Date: Fri, 23 Dec 2011 08:01:43 -0500
Message-ID: <20111223130143.31709.83598.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

Prevent a receive data corruption by ensuring that the write to
update the rcvhdrheadn register to generate an interrupt is at the
very end of the receive processing.

Signed-off-by: Ramkrishna Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba6120.c |    4 +++-
 drivers/infiniband/hw/qib/qib_iba7220.c |    4 +++-
 drivers/infiniband/hw/qib/qib_iba7322.c |    6 ++++--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index 781a802..4f18e2d 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -2076,9 +2076,11 @@ static void qib_6120_config_ctxts(struct qib_devdata *dd)
 static void qib_update_6120_usrhead(struct qib_ctxtdata *rcd, u64 hd,
 				    u32 updegr, u32 egrhd, u32 npkts)
 {
-	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
 	if (updegr)
 		qib_write_ureg(rcd->dd, ur_rcvegrindexhead, egrhd, rcd->ctxt);
+	mmiowb();
+	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
+	mmiowb();
 }
 
 static u32 qib_6120_hdrqempty(struct qib_ctxtdata *rcd)
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index 439d3c5..7ec4048 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -2725,9 +2725,11 @@ static int qib_7220_set_loopback(struct qib_pportdata *ppd, const char *what)
 static void qib_update_7220_usrhead(struct qib_ctxtdata *rcd, u64 hd,
 				    u32 updegr, u32 egrhd, u32 npkts)
 {
-	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
 	if (updegr)
 		qib_write_ureg(rcd->dd, ur_rcvegrindexhead, egrhd, rcd->ctxt);
+	mmiowb();
+	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
+	mmiowb();
 }
 
 static u32 qib_7220_hdrqempty(struct qib_ctxtdata *rcd)
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 1d58959..5a070e8 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -4082,10 +4082,12 @@ static void qib_update_7322_usrhead(struct qib_ctxtdata *rcd, u64 hd,
 	 */
 	if (hd >> IBA7322_HDRHEAD_PKTINT_SHIFT)
 		adjust_rcv_timeout(rcd, npkts);
-	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
-	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
 	if (updegr)
 		qib_write_ureg(rcd->dd, ur_rcvegrindexhead, egrhd, rcd->ctxt);
+	mmiowb();
+	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
+	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
+	mmiowb();
 }
 
 static u32 qib_7322_hdrqempty(struct qib_ctxtdata *rcd)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
