From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fix logging messages about op_vls and mtu mismatch
Date: Thu, 24 May 2012 15:14:20 +0300
Message-ID: <20120524121420.GC2232@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These log messages should be issued only if current operational vl/neighbor mtu
are different from calculated operational vl/neighbor mtu.

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_port.h |   12 +++++++++-
 opensm/osm_lid_mgr.c      |    6 +++-
 opensm/osm_link_mgr.c     |    6 +++-
 opensm/osm_port.c         |   50 +++++++++++++++++++++++---------------------
 4 files changed, 44 insertions(+), 30 deletions(-)

diff --git a/include/opensm/osm_port.h b/include/opensm/osm_port.h
index a6ca780..473b269 100644
--- a/include/opensm/osm_port.h
+++ b/include/opensm/osm_port.h
@@ -1377,7 +1377,8 @@ void osm_port_get_lid_range_ho(IN const osm_port_t * p_port,
 * SYNOPSIS
 */
 uint8_t osm_physp_calc_link_mtu(IN osm_log_t * p_log,
-				IN const osm_physp_t * p_physp);
+				IN const osm_physp_t * p_physp,
+				IN uint8_t current_mtu);
 /*
 * PARAMETERS
 *	p_log
@@ -1386,6 +1387,9 @@ uint8_t osm_physp_calc_link_mtu(IN osm_log_t * p_log,
 *	p_physp
 *		[in] Pointer to an osm_physp_t object.
 *
+*	current_mtu
+*		[in] Current neighbor mtu on this port
+*
 * RETURN VALUES
 *	The MTU of the link to be used.
 *
@@ -1407,7 +1411,8 @@ uint8_t osm_physp_calc_link_mtu(IN osm_log_t * p_log,
 */
 uint8_t osm_physp_calc_link_op_vls(IN osm_log_t * p_log,
 				   IN const osm_subn_t * p_subn,
-				   IN const osm_physp_t * p_physp);
+				   IN const osm_physp_t * p_physp,
+				   IN uint8_t current_op_vls);
 /*
 * PARAMETERS
 *	p_log
@@ -1419,6 +1424,9 @@ uint8_t osm_physp_calc_link_op_vls(IN osm_log_t * p_log,
 *	p_physp
 *		[in] Pointer to an osm_physp_t object.
 *
+*	current_op_vls
+*		[in] Current operational VL on the port
+*
 * RETURN VALUES
 *	The OP_VLS of the link to be used.
 *
diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index 7610df7..a7613e2 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -915,8 +915,10 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 
 		/* calc new op_vls and mtu */
 		op_vls = osm_physp_calc_link_op_vls(p_mgr->p_log, p_mgr->p_subn,
-						    p_physp);
-		mtu = osm_physp_calc_link_mtu(p_mgr->p_log, p_physp);
+					      p_physp,
+					      ib_port_info_get_op_vls(p_old_pi));
+		mtu = osm_physp_calc_link_mtu(p_mgr->p_log, p_physp,
+					      ib_port_info_get_neighbor_mtu(p_old_pi));
 
 		ib_port_info_set_neighbor_mtu(p_pi, mtu);
 
diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index a901023..8fcd0da 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -402,8 +402,10 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 
 		/* calc new op_vls and mtu */
 		op_vls =
-		    osm_physp_calc_link_op_vls(sm->p_log, sm->p_subn, p_physp);
-		mtu = osm_physp_calc_link_mtu(sm->p_log, p_physp);
+		    osm_physp_calc_link_op_vls(sm->p_log, sm->p_subn, p_physp,
+					       ib_port_info_get_op_vls(p_old_pi));
+		mtu = osm_physp_calc_link_mtu(sm->p_log, p_physp,
+					      ib_port_info_get_neighbor_mtu(p_old_pi));
 
 		ib_port_info_set_neighbor_mtu(p_pi, mtu);
 		if (ib_port_info_get_neighbor_mtu(p_pi) !=
diff --git a/opensm/osm_port.c b/opensm/osm_port.c
index b8e4988..5438c2c 100644
--- a/opensm/osm_port.c
+++ b/opensm/osm_port.c
@@ -174,7 +174,8 @@ void osm_port_get_lid_range_ho(IN const osm_port_t * p_port,
 }
 
 uint8_t osm_physp_calc_link_mtu(IN osm_log_t * p_log,
-				IN const osm_physp_t * p_physp)
+				IN const osm_physp_t * p_physp,
+				IN uint8_t current_mtu)
 {
 	const osm_physp_t *p_remote_physp;
 	uint8_t mtu;
@@ -200,17 +201,17 @@ uint8_t osm_physp_calc_link_mtu(IN osm_log_t * p_log,
 		if (mtu != remote_mtu) {
 			if (mtu > remote_mtu)
 				mtu = remote_mtu;
-
-			OSM_LOG(p_log, OSM_LOG_VERBOSE,
-				"MTU mismatch between ports."
-				"\n\t\t\t\tPort 0x%016" PRIx64 ", port %u"
-				" and port 0x%016" PRIx64 ", port %u."
-				"\n\t\t\t\tUsing lower MTU of %u\n",
-				cl_ntoh64(osm_physp_get_port_guid(p_physp)),
-				osm_physp_get_port_num(p_physp),
-				cl_ntoh64(osm_physp_get_port_guid
-					  (p_remote_physp)),
-				osm_physp_get_port_num(p_remote_physp), mtu);
+			if (mtu != current_mtu)
+				OSM_LOG(p_log, OSM_LOG_VERBOSE,
+					"MTU mismatch between ports."
+					"\n\t\t\t\tPort 0x%016" PRIx64 ", port %u"
+					" and port 0x%016" PRIx64 ", port %u."
+					"\n\t\t\t\tUsing lower MTU of %u\n",
+					cl_ntoh64(osm_physp_get_port_guid(p_physp)),
+					osm_physp_get_port_num(p_physp),
+					cl_ntoh64(osm_physp_get_port_guid
+						  (p_remote_physp)),
+					osm_physp_get_port_num(p_remote_physp), mtu);
 		}
 	} else
 		mtu = ib_port_info_get_neighbor_mtu(&p_physp->port_info);
@@ -227,7 +228,8 @@ uint8_t osm_physp_calc_link_mtu(IN osm_log_t * p_log,
 
 uint8_t osm_physp_calc_link_op_vls(IN osm_log_t * p_log,
 				   IN const osm_subn_t * p_subn,
-				   IN const osm_physp_t * p_physp)
+				   IN const osm_physp_t * p_physp,
+				   IN uint8_t current_op_vls)
 {
 	const osm_physp_t *p_remote_physp;
 	uint8_t op_vls;
@@ -253,17 +255,17 @@ uint8_t osm_physp_calc_link_op_vls(IN osm_log_t * p_log,
 		if (op_vls != remote_op_vls) {
 			if (op_vls > remote_op_vls)
 				op_vls = remote_op_vls;
-
-			OSM_LOG(p_log, OSM_LOG_VERBOSE,
-				"OP_VLS mismatch between ports."
-				"\n\t\t\t\tPort 0x%016" PRIx64 ", port 0x%X"
-				" and port 0x%016" PRIx64 ", port 0x%X."
-				"\n\t\t\t\tUsing lower OP_VLS of %u\n",
-				cl_ntoh64(osm_physp_get_port_guid(p_physp)),
-				osm_physp_get_port_num(p_physp),
-				cl_ntoh64(osm_physp_get_port_guid
-					  (p_remote_physp)),
-				osm_physp_get_port_num(p_remote_physp), op_vls);
+			if (op_vls != current_op_vls)
+				OSM_LOG(p_log, OSM_LOG_VERBOSE,
+					"OP_VLS mismatch between ports."
+					"\n\t\t\t\tPort 0x%016" PRIx64 ", port 0x%X"
+					" and port 0x%016" PRIx64 ", port 0x%X."
+					"\n\t\t\t\tUsing lower OP_VLS of %u\n",
+					cl_ntoh64(osm_physp_get_port_guid(p_physp)),
+					osm_physp_get_port_num(p_physp),
+					cl_ntoh64(osm_physp_get_port_guid
+						  (p_remote_physp)),
+					osm_physp_get_port_num(p_remote_physp), op_vls);
 		}
 	} else
 		op_vls = ib_port_info_get_op_vls(&p_physp->port_info);
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
