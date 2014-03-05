From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_sm_state_mgr.c: Reconfigure the fabric when receiving
 HANDOVER/POLLING_TIMEOUT in MASTER state
Date: Wed, 05 Mar 2014 11:33:33 -0500
Message-ID: <531751DD.7060906@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Sun, 5 Aug 2012 11:50:07 +0300

When SM in MASTER state, receives HANDOVER request from some other
MASTER SM or it didn't response (POLLING_TIMEOUT), we must reconfigure
the whole fabric as it was the first SM sweep, as we don't know what
the other MASTER SM configured earlier.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sm_state_mgr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_sm_state_mgr.c b/opensm/osm_sm_state_mgr.c
index e5a11da..5e4b06a 100644
--- a/opensm/osm_sm_state_mgr.c
+++ b/opensm/osm_sm_state_mgr.c
@@ -450,6 +450,8 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			 */
 			sm->p_subn->set_client_rereg_on_sweep = TRUE;
 			sm->polling_sm_guid = 0;
+			sm->p_subn->first_time_master_sweep = TRUE;
+			sm->p_subn->coming_out_of_standby = TRUE;
 			sm->p_subn->force_heavy_sweep = TRUE;
 			osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
 			break;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
