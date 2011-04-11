From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Prevent driver hang with unprogrammed boards
Date: Mon, 11 Apr 2011 09:45:17 -0400
Message-ID: <20110411134517.3720.3633.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

The time limit test now correctly checks the against
current jiffies to avoid the hang.

Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 4df08b8..30bbea2 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -7545,7 +7545,8 @@ static int serdes_7322_init_new(struct qib_pportdata *ppd)
 	ibsd_wr_allchans(ppd, 4, (1 << 10), BMASK(10, 10));
 	tstart = get_jiffies_64();
 	while (chan_done &&
-	       !time_after64(tstart, tstart + msecs_to_jiffies(500))) {
+	       !time_after64(get_jiffies_64(),
+			tstart + msecs_to_jiffies(500))) {
 		msleep(20);
 		for (chan = 0; chan < SERDES_CHANS; ++chan) {
 			rxcaldone = ahb_mod(ppd->dd, IBSD(ppd->hw_pidx),

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
