From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 02/24] IB/qib: add receive header queue size module parameters
Date: Tue, 28 Dec 2010 10:27:00 -0500
Message-ID: <20101228152700.19960.62796.stgit@kop-dev-sles11-04.qlogic.org>
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

The receive header queue sizes need to modified to support
performance tuning.  Three module parameters are added to
support this.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 9031cd8..b35676f 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -111,6 +111,21 @@ static ushort qib_singleport;
 module_param_named(singleport, qib_singleport, ushort, S_IRUGO);
 MODULE_PARM_DESC(singleport, "Use only IB port 1; more per-port buffer space");
 
+/*
+ * Receive header queue sizes
+ */
+static unsigned qib_rcvhdrcnt;
+module_param_named(rcvhdrcnt, qib_rcvhdrcnt, uint, S_IRUGO);
+MODULE_PARM_DESC(rcvhdrcnt, "receive header count");
+
+static unsigned qib_rcvhdrsize;
+module_param_named(rcvhdrsize, qib_rcvhdrsize, uint, S_IRUGO);
+MODULE_PARM_DESC(rcvhdrsize, "receive header size in 32-bit words");
+
+static unsigned qib_rcvhdrentsize;
+module_param_named(rcvhdrentsize, qib_rcvhdrentsize, uint, S_IRUGO);
+MODULE_PARM_DESC(rcvhdrentsize, "receive header entry size in 32-bit words");
+
 #define MAX_ATTEN_LEN 64 /* plenty for any real system */
 /* for read back, default index is ~5m copper cable */
 static char txselect_list[MAX_ATTEN_LEN] = "10";
@@ -3530,8 +3545,11 @@ static void qib_7322_config_ctxts(struct qib_devdata *dd)
 
 	/* kr_rcvegrcnt changes based on the number of contexts enabled */
 	dd->cspec->rcvegrcnt = qib_read_kreg32(dd, kr_rcvegrcnt);
-	dd->rcvhdrcnt = max(dd->cspec->rcvegrcnt,
-				dd->num_pports > 1 ? 1024U : 2048U);
+	if (qib_rcvhdrcnt)
+		dd->rcvhdrcnt = max(dd->cspec->rcvegrcnt, qib_rcvhdrcnt);
+	else
+		dd->rcvhdrcnt = max(dd->cspec->rcvegrcnt,
+				    dd->num_pports > 1 ? 1024U : 2048U);
 }
 
 static int qib_7322_get_ib_cfg(struct qib_pportdata *ppd, int which)
@@ -6097,8 +6115,10 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 		ppd++;
 	}
 
-	dd->rcvhdrentsize = QIB_RCVHDR_ENTSIZE;
-	dd->rcvhdrsize = QIB_DFLT_RCVHDRSIZE;
+	dd->rcvhdrentsize = qib_rcvhdrentsize ?
+		qib_rcvhdrentsize : QIB_RCVHDR_ENTSIZE;
+	dd->rcvhdrsize = qib_rcvhdrsize ?
+		qib_rcvhdrsize : QIB_DFLT_RCVHDRSIZE;
 	dd->rhf_offset = dd->rcvhdrentsize - sizeof(u64) / sizeof(u32);
 
 	/* we always allocate at least 2048 bytes for eager buffers */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
