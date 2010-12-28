From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 09/24] IB/qib: Multi Florida HCA Hosts panic on reboot
Date: Tue, 28 Dec 2010 10:27:37 -0500
Message-ID: <20101228152737.19960.79055.stgit@kop-dev-sles11-04.qlogic.org>
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

Add check when setting configured contexts that the value
does not exceed the number of contexts allocated for the
card. If the value exceeds the already allocated count,
set it to what is already allocated.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_init.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index f3b5039..7896afb 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -92,9 +92,11 @@ unsigned long *qib_cpulist;
 /* set number of contexts we'll actually use */
 void qib_set_ctxtcnt(struct qib_devdata *dd)
 {
-	if (!qib_cfgctxts)
+	if (!qib_cfgctxts) {
 		dd->cfgctxts = dd->first_user_ctxt + num_online_cpus();
-	else if (qib_cfgctxts < dd->num_pports)
+		if (dd->cfgctxts > dd->ctxtcnt)
+			dd->cfgctxts = dd->ctxtcnt;
+	} else if (qib_cfgctxts < dd->num_pports)
 		dd->cfgctxts = dd->ctxtcnt;
 	else if (qib_cfgctxts <= dd->ctxtcnt)
 		dd->cfgctxts = qib_cfgctxts;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
