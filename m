From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_link_mgr.c: Set AM SMSupportExtendedSpeeds bit if port supports ExtPortInfo
Date: Mon,  4 Feb 2013 15:20:06 +0200
Message-ID: <1359984011-30753-5-git-send-email-alexne@mellanox.com>
References: <1359984011-30753-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359984011-30753-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When updating PortInfo we should set AM SMSupportExtendedSpeeds bit for
the ports that support ExtendedSpeeds. Otherwise, we won't be able to update
ExtendedSpeedEnabled field.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_link_mgr.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index 5271d59..9d73e74 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -102,7 +102,7 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 	uint8_t port_num, mtu, op_vls, smsl = OSM_DEFAULT_SL;
 	boolean_t esp0 = FALSE, send_set = FALSE, send_set2 = FALSE;
 	osm_physp_t *p_remote_physp, *physp0;
-	int qdr_change = 0, fdr10_change = 0;
+	int issue_ext = 1, fdr10_change = 0;
 	int ret = 0;
 	ib_net32_t attr_mod, cap_mask;
 	boolean_t update_mkey = FALSE;
@@ -334,19 +334,8 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 							    sm->p_subn->opt.
 							    force_link_speed);
 			if (memcmp(&p_pi->link_speed, &p_old_pi->link_speed,
-				   sizeof(p_pi->link_speed))) {
+				   sizeof(p_pi->link_speed)))
 				send_set = TRUE;
-				/* Determine whether QDR in LSE is being changed */
-				if ((ib_port_info_get_link_speed_enabled(p_pi) &
-				     IB_LINK_SPEED_ACTIVE_10 &&
-				     !(ib_port_info_get_link_speed_enabled(p_old_pi) &
-				      IB_LINK_SPEED_ACTIVE_10)) ||
-				    ((!(ib_port_info_get_link_speed_enabled(p_pi) &
-				       IB_LINK_SPEED_ACTIVE_10) &&
-				      ib_port_info_get_link_speed_enabled(p_old_pi) &
-				      IB_LINK_SPEED_ACTIVE_10)))
-				qdr_change = 1;
-			}
 		}
 
 		if (sm->p_subn->opt.fdr10 &&
@@ -377,7 +366,7 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 		} else
 			cap_mask = p_pi->capability_mask;
 		if (!(cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS))
-			qdr_change = 0;
+			issue_ext = 0;
 
 		/* Do peer ports support extended link speeds ? */
 		if (port_num != 0 && p_remote_physp) {
@@ -462,7 +451,7 @@ Send:
 		goto Exit;
 
 	attr_mod = cl_hton32(port_num);
-	if (qdr_change)
+	if (issue_ext)
 		attr_mod |= cl_hton32(1 << 31);	/* AM SMSupportExtendedSpeeds */
 	status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p_physp),
 			     payload, sizeof(payload), IB_MAD_ATTR_PORT_INFO,
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
