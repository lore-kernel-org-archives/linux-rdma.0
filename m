From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/24] IB/qib: fix context allocation with multiple HCAs
Date: Tue, 28 Dec 2010 10:27:42 -0500
Message-ID: <20101228152742.19960.76544.stgit@kop-dev-sles11-04.qlogic.org>
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

The driver was incorrectly choosing HCAs on which to allocate
new user contexts based on overall count of usable ports
regardless whether the usable port was on the currently selected
HCA.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_file_ops.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 79d9971..75bfad1 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1379,17 +1379,17 @@ static int get_a_ctxt(struct file *fp, const struct qib_user_info *uinfo,
 		/* find device (with ACTIVE ports) with fewest ctxts in use */
 		for (ndev = 0; ndev < devmax; ndev++) {
 			struct qib_devdata *dd = qib_lookup(ndev);
-			unsigned cused = 0, cfree = 0;
+			unsigned cused = 0, cfree = 0, pusable = 0;
 			if (!dd)
 				continue;
 			if (port && port <= dd->num_pports &&
 			    usable(dd->pport + port - 1))
-				dusable = 1;
+				pusable = 1;
 			else
 				for (i = 0; i < dd->num_pports; i++)
 					if (usable(dd->pport + i))
-						dusable++;
-			if (!dusable)
+						pusable++;
+			if (!pusable)
 				continue;
 			for (ctxt = dd->first_user_ctxt; ctxt < dd->cfgctxts;
 			     ctxt++)
@@ -1397,7 +1397,7 @@ static int get_a_ctxt(struct file *fp, const struct qib_user_info *uinfo,
 					cused++;
 				else
 					cfree++;
-			if (cfree && cused < inuse) {
+			if (pusable && cfree && cused < inuse) {
 				udd = dd;
 				inuse = cused;
 			}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
