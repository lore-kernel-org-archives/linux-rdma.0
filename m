From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_console.c: Fix display of negative counters in
 console
Date: Wed, 03 Jun 2015 10:59:47 -0400
Message-ID: <556F1663.6090408@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Tue, 26 May 2015 14:38:21 +0300

OpenSM may print negative counters values in console mode due to
the wrong format being used in printf.
This change fixes the problem by changing the format used for counters
of type uint32_t from decimal (%d) to unsigned (%u).

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_console.c |   46 +++++++++++++++++++++++-----------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index f3f79ff..0f68afe 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -482,32 +482,32 @@ static void print_status(osm_opensm_t * p_osm, FILE * out)
 #endif
 		fprintf(out, "\n   MAD stats\n"
 			"   ---------\n"
-			"   QP0 MADs outstanding           : %d\n"
-			"   QP0 MADs outstanding (on wire) : %d\n"
-			"   QP0 MADs rcvd                  : %d\n"
-			"   QP0 MADs sent                  : %d\n"
-			"   QP0 unicasts sent              : %d\n"
-			"   QP0 unknown MADs rcvd          : %d\n"
-			"   SA MADs outstanding            : %d\n"
-			"   SA MADs rcvd                   : %d\n"
-			"   SA MADs sent                   : %d\n"
-			"   SA unknown MADs rcvd           : %d\n"
-			"   SA MADs ignored                : %d\n",
-			p_osm->stats.qp0_mads_outstanding,
-			p_osm->stats.qp0_mads_outstanding_on_wire,
-			p_osm->stats.qp0_mads_rcvd,
-			p_osm->stats.qp0_mads_sent,
-			p_osm->stats.qp0_unicasts_sent,
-			p_osm->stats.qp0_mads_rcvd_unknown,
-			p_osm->stats.sa_mads_outstanding,
-			p_osm->stats.sa_mads_rcvd,
-			p_osm->stats.sa_mads_sent,
-			p_osm->stats.sa_mads_rcvd_unknown,
-			p_osm->stats.sa_mads_ignored);
+			"   QP0 MADs outstanding           : %u\n"
+			"   QP0 MADs outstanding (on wire) : %u\n"
+			"   QP0 MADs rcvd                  : %u\n"
+			"   QP0 MADs sent                  : %u\n"
+			"   QP0 unicasts sent              : %u\n"
+			"   QP0 unknown MADs rcvd          : %u\n"
+			"   SA MADs outstanding            : %u\n"
+			"   SA MADs rcvd                   : %u\n"
+			"   SA MADs sent                   : %u\n"
+			"   SA unknown MADs rcvd           : %u\n"
+			"   SA MADs ignored                : %u\n",
+			(uint32_t)p_osm->stats.qp0_mads_outstanding,
+			(uint32_t)p_osm->stats.qp0_mads_outstanding_on_wire,
+			(uint32_t)p_osm->stats.qp0_mads_rcvd,
+			(uint32_t)p_osm->stats.qp0_mads_sent,
+			(uint32_t)p_osm->stats.qp0_unicasts_sent,
+			(uint32_t)p_osm->stats.qp0_mads_rcvd_unknown,
+			(uint32_t)p_osm->stats.sa_mads_outstanding,
+			(uint32_t)p_osm->stats.sa_mads_rcvd,
+			(uint32_t)p_osm->stats.sa_mads_sent,
+			(uint32_t)p_osm->stats.sa_mads_rcvd_unknown,
+			(uint32_t)p_osm->stats.sa_mads_ignored);
 		fprintf(out, "\n   Subnet flags\n"
 			"   ------------\n"
 			"   Sweeping enabled               : %d\n"
-			"   Sweep interval (seconds)       : %d\n"
+			"   Sweep interval (seconds)       : %u\n"
 			"   Ignore existing lfts           : %d\n"
 			"   Subnet Init errors             : %d\n"
 			"   In sweep hop 0                 : %d\n"
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
