From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/1] Initiate heavy sweep in MFTSubnSet fails during idle
 time process
Date: Thu, 12 May 2011 19:14:43 +0300
Message-ID: <20110512161443.GC22389@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

MFTSubnSet failed MADs may leave temporary MC loops in the fabric.
In order to eliminate this faulty state as quick as possible it's a good
thing to initiate a heavy sweep immediately and to wait for the next light
sweep.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_state_mgr.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index dd308f2..aa71b03 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1434,6 +1434,13 @@ static void do_process_mgrp_queue(osm_sm_t * sm)
 		osm_mcast_mgr_process(sm);
 		wait_for_pending_transactions(&sm->p_subn->p_osm->stats);
 	}
+
+	/* if one or more MFTSubnSet MADs fails
+	 * during idle process time initiate heavy sweep */
+	if (sm->p_subn->force_heavy_sweep
+	    || sm->p_subn->subnet_initialization_error)
+		osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
+
 }
 
 void osm_state_mgr_process(IN osm_sm_t * sm, IN osm_signal_t signal)
-- 
1.7.5


-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
