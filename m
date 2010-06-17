From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/7] IB/qib: update 7322 serdes tables
Date: Thu, 17 Jun 2010 16:14:09 -0700
Message-ID: <20100617231409.8006.13439.stgit@chromite.mv.qlogic.com>
References: <20100617231338.8006.18131.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100617231338.8006.18131.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_iba7322.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 8ee0ac6..5eedf83 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -543,7 +543,7 @@ struct vendor_txdds_ent {
 static void write_tx_serdes_param(struct qib_pportdata *, struct txdds_ent *);
 
 #define TXDDS_TABLE_SZ 16 /* number of entries per speed in onchip table */
-#define TXDDS_EXTRA_SZ 11 /* number of extra tx settings entries */
+#define TXDDS_EXTRA_SZ 13 /* number of extra tx settings entries */
 #define SERDES_CHANS 4 /* yes, it's obvious, but one less magic number */
 
 #define H1_FORCE_VAL 8
@@ -5629,6 +5629,8 @@ static void set_no_qsfp_atten(struct qib_devdata *dd, int change)
 			if (ppd->port != port || !ppd->link_speed_supported)
 				continue;
 			ppd->cpspec->no_eep = val;
+			if (seth1)
+				ppd->cpspec->h1_val = h1;
 			/* now change the IBC and serdes, overriding generic */
 			init_txdds_table(ppd, 1);
 			any++;
@@ -6069,9 +6071,9 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 		 * the "cable info" setup here.  Can be overridden
 		 * in adapter-specific routines.
 		 */
-		if (!(ppd->dd->flags & QIB_HAS_QSFP)) {
-			if (!IS_QMH(ppd->dd) && !IS_QME(ppd->dd))
-				qib_devinfo(ppd->dd->pcidev, "IB%u:%u: "
+		if (!(dd->flags & QIB_HAS_QSFP)) {
+			if (!IS_QMH(dd) && !IS_QME(dd))
+				qib_devinfo(dd->pcidev, "IB%u:%u: "
 					    "Unknown mezzanine card type\n",
 					    dd->unit, ppd->port);
 			cp->h1_val = IS_QMH(dd) ? H1_FORCE_QMH : H1_FORCE_QME;
@@ -6953,6 +6955,8 @@ static const struct txdds_ent txdds_extra_sdr[TXDDS_EXTRA_SZ] = {
 	{  0, 0, 0, 11 },	/* QME7342 backplane settings */
 	{  0, 0, 0, 11 },	/* QME7342 backplane settings */
 	{  0, 0, 0, 11 },	/* QME7342 backplane settings */
+	{  0, 0, 0,  3 },	/* QMH7342 backplane settings */
+	{  0, 0, 0,  4 },	/* QMH7342 backplane settings */
 };
 
 static const struct txdds_ent txdds_extra_ddr[TXDDS_EXTRA_SZ] = {
@@ -6968,6 +6972,8 @@ static const struct txdds_ent txdds_extra_ddr[TXDDS_EXTRA_SZ] = {
 	{  0, 0, 0, 13 },	/* QME7342 backplane settings */
 	{  0, 0, 0, 13 },	/* QME7342 backplane settings */
 	{  0, 0, 0, 13 },	/* QME7342 backplane settings */
+	{  0, 0, 0,  9 },	/* QMH7342 backplane settings */
+	{  0, 0, 0, 10 },	/* QMH7342 backplane settings */
 };
 
 static const struct txdds_ent txdds_extra_qdr[TXDDS_EXTRA_SZ] = {
@@ -6983,6 +6989,8 @@ static const struct txdds_ent txdds_extra_qdr[TXDDS_EXTRA_SZ] = {
 	{  0, 1, 12,  6 },	/* QME7342 backplane setting */
 	{  0, 1, 12,  7 },	/* QME7342 backplane setting */
 	{  0, 1, 12,  8 },	/* QME7342 backplane setting */
+	{  0, 1,  0, 10 },	/* QMH7342 backplane settings */
+	{  0, 1,  0, 12 },	/* QMH7342 backplane settings */
 };
 
 static const struct txdds_ent *get_atten_table(const struct txdds_ent *txdds,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
