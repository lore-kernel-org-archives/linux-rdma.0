From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_lid_mgr.c: Don't configure MTU and LMC for base
 SP0
Date: Fri, 16 Aug 2013 15:11:40 -0400
Message-ID: <520E796C.8030704@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

For base switch port 0, these values aren't defined/used.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_lid_mgr.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index d881b5e..85fb44f 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -988,10 +988,11 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 			    ib_port_info_get_port_state(p_old_pi))
 				send_set = TRUE;
 		}
-	} else {
+	} else if (ib_switch_info_is_enhanced_port0(&p_node->sw->switch_info)) {
 		/*
-		   For Port 0, NeighborMTU is relevant only for Enh. SP0.
-		   In this case, we'll set the MTU according to the mtu_cap
+		 * Configure Enh. SP0:
+		 * Set MTU according to the mtu_cap.
+		 * Set LMC if lmc_esp0 is defined.
 		 */
 		ib_port_info_set_neighbor_mtu(p_pi,
 					      ib_port_info_get_mtu_cap
@@ -1006,8 +1007,8 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 			cl_ntoh64(osm_physp_get_port_guid(p_physp)),
 			ib_port_info_get_neighbor_mtu(p_pi));
 
-		/* Determine if enhanced switch port 0 and if so set LMC */
-		if (osm_switch_sp0_is_lmc_capable(p_node->sw, p_mgr->p_subn)) {
+		/* Configure LMC on enhanced SP0 */
+		if (p_mgr->p_subn->opt.lmc_esp0) {
 			/* p_pi->mkey_lmc is initialized earlier */
 			ib_port_info_set_lmc(p_pi, p_mgr->p_subn->opt.lmc);
 			if (ib_port_info_get_lmc(p_pi) !=
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
