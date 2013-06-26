From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: New transmitter tunning settings for Dell 1.1
 backplane
Date: Wed, 26 Jun 2013 10:46:22 -0400
Message-ID: <20130626144622.8958.90725.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The Dell blade chassis got an updated backplane which requires
new transmitter tuning settings.

Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |   59 +++++++++++++++++++------------
 1 file changed, 37 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 08fd74a..16b47ca 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -582,7 +582,7 @@ struct vendor_txdds_ent {
 static void write_tx_serdes_param(struct qib_pportdata *, struct txdds_ent *);
 
 #define TXDDS_TABLE_SZ 16 /* number of entries per speed in onchip table */
-#define TXDDS_EXTRA_SZ 13 /* number of extra tx settings entries */
+#define TXDDS_EXTRA_SZ 18 /* number of extra tx settings entries */
 #define TXDDS_MFG_SZ 2    /* number of mfg tx settings entries */
 #define SERDES_CHANS 4 /* yes, it's obvious, but one less magic number */
 
@@ -7458,15 +7458,20 @@ static const struct txdds_ent txdds_extra_sdr[TXDDS_EXTRA_SZ] = {
 	{  0, 0, 0,  1 },	/* QMH7342 backplane settings */
 	{  0, 0, 0,  2 },	/* QMH7342 backplane settings */
 	{  0, 0, 0,  2 },	/* QMH7342 backplane settings */
-	{  0, 0, 0, 11 },	/* QME7342 backplane settings */
-	{  0, 0, 0, 11 },	/* QME7342 backplane settings */
-	{  0, 0, 0, 11 },	/* QME7342 backplane settings */
-	{  0, 0, 0, 11 },	/* QME7342 backplane settings */
-	{  0, 0, 0, 11 },	/* QME7342 backplane settings */
-	{  0, 0, 0, 11 },	/* QME7342 backplane settings */
-	{  0, 0, 0, 11 },	/* QME7342 backplane settings */
 	{  0, 0, 0,  3 },	/* QMH7342 backplane settings */
 	{  0, 0, 0,  4 },	/* QMH7342 backplane settings */
+	{  0, 1, 4, 15 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1, 3, 15 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1, 0, 12 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1, 0, 11 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1, 0,  9 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1, 0, 14 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1, 2, 15 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1, 0, 11 },       /* QME7342 backplane settings 1.1 */
+	{  0, 1, 0,  7 },       /* QME7342 backplane settings 1.1 */
+	{  0, 1, 0,  9 },       /* QME7342 backplane settings 1.1 */
+	{  0, 1, 0,  6 },       /* QME7342 backplane settings 1.1 */
+	{  0, 1, 0,  8 },       /* QME7342 backplane settings 1.1 */
 };
 
 static const struct txdds_ent txdds_extra_ddr[TXDDS_EXTRA_SZ] = {
@@ -7475,15 +7480,20 @@ static const struct txdds_ent txdds_extra_ddr[TXDDS_EXTRA_SZ] = {
 	{  0, 0, 0,  7 },	/* QMH7342 backplane settings */
 	{  0, 0, 0,  8 },	/* QMH7342 backplane settings */
 	{  0, 0, 0,  8 },	/* QMH7342 backplane settings */
-	{  0, 0, 0, 13 },	/* QME7342 backplane settings */
-	{  0, 0, 0, 13 },	/* QME7342 backplane settings */
-	{  0, 0, 0, 13 },	/* QME7342 backplane settings */
-	{  0, 0, 0, 13 },	/* QME7342 backplane settings */
-	{  0, 0, 0, 13 },	/* QME7342 backplane settings */
-	{  0, 0, 0, 13 },	/* QME7342 backplane settings */
-	{  0, 0, 0, 13 },	/* QME7342 backplane settings */
 	{  0, 0, 0,  9 },	/* QMH7342 backplane settings */
 	{  0, 0, 0, 10 },	/* QMH7342 backplane settings */
+	{  0, 1, 4, 15 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1, 3, 15 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1, 0, 12 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1, 0, 11 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1, 0,  9 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1, 0, 14 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1, 2, 15 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1, 0, 11 },       /* QME7342 backplane settings 1.1 */
+	{  0, 1, 0,  7 },       /* QME7342 backplane settings 1.1 */
+	{  0, 1, 0,  9 },       /* QME7342 backplane settings 1.1 */
+	{  0, 1, 0,  6 },       /* QME7342 backplane settings 1.1 */
+	{  0, 1, 0,  8 },       /* QME7342 backplane settings 1.1 */
 };
 
 static const struct txdds_ent txdds_extra_qdr[TXDDS_EXTRA_SZ] = {
@@ -7492,15 +7502,20 @@ static const struct txdds_ent txdds_extra_qdr[TXDDS_EXTRA_SZ] = {
 	{  0, 1,  0,  5 },	/* QMH7342 backplane settings */
 	{  0, 1,  0,  6 },	/* QMH7342 backplane settings */
 	{  0, 1,  0,  8 },	/* QMH7342 backplane settings */
-	{  0, 1, 12, 10 },	/* QME7342 backplane setting */
-	{  0, 1, 12, 11 },	/* QME7342 backplane setting */
-	{  0, 1, 12, 12 },	/* QME7342 backplane setting */
-	{  0, 1, 12, 14 },	/* QME7342 backplane setting */
-	{  0, 1, 12,  6 },	/* QME7342 backplane setting */
-	{  0, 1, 12,  7 },	/* QME7342 backplane setting */
-	{  0, 1, 12,  8 },	/* QME7342 backplane setting */
 	{  0, 1,  0, 10 },	/* QMH7342 backplane settings */
 	{  0, 1,  0, 12 },	/* QMH7342 backplane settings */
+	{  0, 1,  4, 15 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1,  3, 15 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1,  0, 12 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1,  0, 11 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1,  0,  9 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1,  0, 14 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1,  2, 15 },	/* QME7342 backplane settings 1.0 */
+	{  0, 1,  0, 11 },      /* QME7342 backplane settings 1.1 */
+	{  0, 1,  0,  7 },      /* QME7342 backplane settings 1.1 */
+	{  0, 1,  0,  9 },      /* QME7342 backplane settings 1.1 */
+	{  0, 1,  0,  6 },      /* QME7342 backplane settings 1.1 */
+	{  0, 1,  0,  8 },      /* QME7342 backplane settings 1.1 */
 };
 
 static const struct txdds_ent txdds_extra_mfg[TXDDS_MFG_SZ] = {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
