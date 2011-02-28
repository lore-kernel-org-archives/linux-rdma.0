From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Set default LE2 value for active cables to 0
Date: Mon, 28 Feb 2011 08:39:49 -0500
Message-ID: <20110228133949.3275.99446.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom.elken-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

For active and far-EQ cables use an LE2 value of 0 for
improved SI.

Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |   13 ++++++++++---
 drivers/infiniband/hw/qib/qib_qsfp.h    |    2 ++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index d51124a..8f0e506 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -5582,9 +5582,16 @@ static void qsfp_7322_event(struct work_struct *work)
 	 * even on failure to read cable information.  We don't
 	 * get here for QME, so IS_QME check not needed here.
 	 */
-	le2 = (!ret && qd->cache.atten[1] >= qib_long_atten &&
-	       !ppd->dd->cspec->r1 && QSFP_IS_CU(qd->cache.tech)) ?
-		LE2_5m : LE2_DEFAULT;
+	if (!ret && !ppd->dd->cspec->r1) {
+		if (QSFP_IS_ACTIVE_FAR(qd->cache.tech))
+			le2 = LE2_QME;
+		else if (qd->cache.atten[1] >= qib_long_atten &&
+			 QSFP_IS_CU(qd->cache.tech))
+			le2 = LE2_5m;
+		else
+			le2 = LE2_DEFAULT;
+	} else
+		le2 = LE2_DEFAULT;
 	ibsd_wr_allchans(ppd, 13, (le2 << 7), BMASK(9, 7));
 	init_txdds_table(ppd, 0);
 }
diff --git a/drivers/infiniband/hw/qib/qib_qsfp.h b/drivers/infiniband/hw/qib/qib_qsfp.h
index 19b527b..c109bbd 100644
--- a/drivers/infiniband/hw/qib/qib_qsfp.h
+++ b/drivers/infiniband/hw/qib/qib_qsfp.h
@@ -79,6 +79,8 @@
 extern const char *const qib_qsfp_devtech[16];
 /* Active Equalization includes fiber, copper full EQ, and copper near Eq */
 #define QSFP_IS_ACTIVE(tech) ((0xA2FF >> ((tech) >> 4)) & 1)
+/* Active Equalization includes fiber, copper full EQ, and copper far Eq */
+#define QSFP_IS_ACTIVE_FAR(tech) ((0x32FF >> ((tech) >> 4)) & 1)
 /* Attenuation should be valid for copper other than full/near Eq */
 #define QSFP_HAS_ATTEN(tech) ((0x4D00 >> ((tech) >> 4)) & 1)
 /* Length is only valid if technology is "copper" */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
