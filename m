From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: Fix QLE734X link cycling
Date: Mon, 7 May 2012 14:02:53 -0400
Message-ID: <20120507180252.3609.88446.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The SERDES was using the incorrect Frequency Loop
Bandwidth setting causing the link to cycle through
the Physical link negotiation state machine.
Fixing the Frequency Loop Bandwidth setting in the
SERDES helps the link come up faster and more
reliably.

Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index e7b9ad3..c881e74 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -7709,7 +7709,7 @@ static int serdes_7322_init_new(struct qib_pportdata *ppd)
 	ibsd_wr_allchans(ppd, 5, 0, BMASK(0, 0));
 	msleep(20);
 	/*       Set Frequency Loop Bandwidth */
-	ibsd_wr_allchans(ppd, 2, (7 << 5), BMASK(8, 5));
+	ibsd_wr_allchans(ppd, 2, (15 << 5), BMASK(8, 5));
 	/*       Enable Frequency Loop */
 	ibsd_wr_allchans(ppd, 2, (1 << 4), BMASK(4, 4));
 	/*       Set Timing Loop Bandwidth */


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
