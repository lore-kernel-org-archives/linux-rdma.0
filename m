From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_opensm.c: Fix race condition between traps handling
 and SA shutdown
Date: Wed, 03 Jun 2015 11:56:30 -0400
Message-ID: <556F23AE.9000608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Mon, 11 May 2015 10:36:46 +0300

Bug description:
When OpenSM handles traps during SA shutdown, it might append these
traps to p_subn->rcvd_traps_list after the list is flushed.
As a result, the memory allocated for the list elements is not released.

With this change, during shutdown process OpenSM shuts down SM before
shutting down the SA, in order to avoid processing traps during SA
shutdown.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_opensm.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/opensm/osm_opensm.c b/opensm/osm_opensm.c
index a64a419..1d60e34 100644
--- a/opensm/osm_opensm.c
+++ b/opensm/osm_opensm.c
@@ -113,17 +113,17 @@ void osm_opensm_destroy(IN osm_opensm_t * p_osm)
 
 	osm_congestion_control_shutdown(&p_osm->cc);
 
-	/* shut down the SA
-	 * - unbind from QP1 messages
-	 */
-	osm_sa_shutdown(&p_osm->sa);
-
 	/* shut down the SM
 	 * - make sure the SM sweeper thread exited
 	 * - unbind from QP0 messages
 	 */
 	osm_sm_shutdown(&p_osm->sm);
 
+	/* shut down the SA
+	 * - unbind from QP1 messages
+	 */
+	osm_sa_shutdown(&p_osm->sa);
+
 	/* cleanup all messages on VL15 fifo that were not sent yet */
 	osm_vl15_shutdown(&p_osm->vl15, &p_osm->mad_pool);
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
