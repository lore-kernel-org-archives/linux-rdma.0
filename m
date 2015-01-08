From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm 3/5] Use routing engine calculated LFT for SA queries
Date: Thu, 08 Jan 2015 07:49:54 -0500
Message-ID: <54AE7CF2.30207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Use LFT as calculated by routing engine for SA queries and dump files,
instead of LFT that OpenSM successfully assigned on the switches.

Without this change, OpenSM calculate replies to path record queries
based on the LFTs that were successfully assigned on the switches in the
fabric.

During the time between routing stage and LFTs assignment, some LFTs
might be zeroed, and OpenSM might respond to path record queries that
there is no path between two nodes.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_switch.h |   34 ++++++++++++++++++++++++++++++----
 opensm/osm_console.c        |    6 ++++--
 opensm/osm_dump.c           |    8 +++++---
 opensm/osm_switch.c         |    7 ++++---
 opensm/osm_ucast_file.c     |    2 +-
 opensm/osm_ucast_mgr.c      |    6 ++++--
 6 files changed, 48 insertions(+), 15 deletions(-)

diff --git a/include/opensm/osm_switch.h b/include/opensm/osm_switch.h
index 41ac959..5047b86 100644
--- a/include/opensm/osm_switch.h
+++ b/include/opensm/osm_switch.h
@@ -407,6 +407,21 @@ uint8_t osm_switch_get_port_least_hops(IN const osm_switch_t * p_sw,
 *	Switch object
 *********/
 
+/****d* OpenSM: osm_lft_type_enum
+* NAME
+*	osm_lft_type_enum
+*
+* DESCRIPTION
+*	Enumerates LFT sets types of a switch.
+*
+* SYNOPSIS
+*/
+typedef enum osm_lft_type_enum {
+	OSM_LFT = 0,
+	OSM_NEW_LFT
+} osm_lft_type_enum;
+/***********/
+
 /****f* OpenSM: Switch/osm_switch_get_port_by_lid
 * NAME
 *	osm_switch_get_port_by_lid
@@ -417,11 +432,12 @@ uint8_t osm_switch_get_port_least_hops(IN const osm_switch_t * p_sw,
 * SYNOPSIS
 */
 static inline uint8_t osm_switch_get_port_by_lid(IN const osm_switch_t * p_sw,
-						 IN uint16_t lid_ho)
+						 IN uint16_t lid_ho,
+						 IN osm_lft_type_enum lft_enum)
 {
 	if (lid_ho == 0 || lid_ho > p_sw->max_lid_ho)
 		return OSM_NO_PATH;
-	return p_sw->lft[lid_ho];
+	return lft_enum == OSM_LFT ? p_sw->lft[lid_ho] : p_sw->new_lft[lid_ho];
 }
 /*
 * PARAMETERS
@@ -431,6 +447,10 @@ static inline uint8_t osm_switch_get_port_by_lid(IN const osm_switch_t * p_sw,
 *	lid_ho
 *		[in] LID (host order) for which to retrieve the shortest hop count.
 *
+*	lft_enum
+*		[in] Use LFT that was calculated by routing engine, or
+*		current LFT on the switch.
+*
 * RETURN VALUES
 *	Returns the switch port on which the specified LID is routed.
 *
@@ -457,7 +477,8 @@ static inline osm_physp_t *osm_switch_get_route_by_lid(IN const osm_switch_t *
 	CL_ASSERT(p_sw);
 	CL_ASSERT(lid);
 
-	port_num = osm_switch_get_port_by_lid(p_sw, cl_ntoh16(lid));
+	port_num = osm_switch_get_port_by_lid(p_sw, cl_ntoh16(lid),
+					      OSM_NEW_LFT);
 
 	/*
 	   In order to avoid holes in the subnet (usually happens when
@@ -921,7 +942,8 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 				  IN boolean_t routing_for_lmc,
 				  IN boolean_t dor,
 				  IN boolean_t port_shifting,
-				  IN uint32_t scatter_ports);
+				  IN uint32_t scatter_ports,
+				  IN osm_lft_type_enum lft_enum);
 /*
 * PARAMETERS
 *	p_sw
@@ -963,6 +985,10 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 * 	scatter_ports
 * 		[in] If not zero, randomize the selection of the best ports.
 *
+* 	lft_enum
+*		[in] Use LFT that was calculated by routing engine, or
+*		current LFT on the switch.
+*
 * RETURN VALUE
 *	Returns the recommended port on which to route this LID.
 *
diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index b2bd9d6..f3f79ff 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -1069,7 +1069,8 @@ static void switchbalance_check(osm_opensm_t * p_osm,
 			continue;
 
 		for (lid_ho = min_lid_ho; lid_ho <= max_lid_ho; lid_ho++) {
-			port_num = osm_switch_get_port_by_lid(p_sw, lid_ho);
+			port_num = osm_switch_get_port_by_lid(p_sw, lid_ho,
+							      OSM_NEW_LFT);
 			if (port_num == OSM_NO_PATH)
 				continue;
 
@@ -1219,7 +1220,8 @@ static void lidbalance_check(osm_opensm_t * p_osm,
 			boolean_t rem_node_found = FALSE;
 			unsigned int indx = 0;
 
-			port_num = osm_switch_get_port_by_lid(p_sw, lid_ho);
+			port_num = osm_switch_get_port_by_lid(p_sw, lid_ho,
+							      OSM_NEW_LFT);
 			if (port_num == OSM_NO_PATH)
 				continue;
 
diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index 8da4279..05672bc 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -149,7 +149,8 @@ static void dump_ucast_routes(cl_map_item_t * item, FILE * file, void *cxt)
 			continue;
 		}
 
-		port_num = osm_switch_get_port_by_lid(p_sw, lid_ho);
+		port_num = osm_switch_get_port_by_lid(p_sw, lid_ho,
+						      OSM_NEW_LFT);
 		if (port_num == OSM_NO_PATH) {
 			/*
 			   This may occur if there are 'holes' in the existing
@@ -225,7 +226,8 @@ static void dump_ucast_routes(cl_map_item_t * item, FILE * file, void *cxt)
 							      lid_ho, 1, TRUE,
 							      FALSE, dor,
 							      p_osm->subn.opt.port_shifting,
-							      p_osm->subn.opt.scatter_ports);
+							      p_osm->subn.opt.scatter_ports,
+							      OSM_NEW_LFT);
 			fprintf(file, "No %u hop path possible via port %u!",
 				best_hops, best_port);
 		}
@@ -342,7 +344,7 @@ static void dump_ucast_lfts(cl_map_item_t * item, FILE * file, void *cxt)
 		cl_ntoh64(osm_node_get_node_guid(p_node)), p_node->print_desc);
 	for (lid = 0; lid <= max_lid; lid++) {
 		osm_port_t *p_port;
-		port = osm_switch_get_port_by_lid(p_sw, lid);
+		port = osm_switch_get_port_by_lid(p_sw, lid, OSM_NEW_LFT);
 
 		if (port >= max_port)
 			continue;
diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
index a28ec28..8c0f223 100644
--- a/opensm/osm_switch.c
+++ b/opensm/osm_switch.c
@@ -169,7 +169,7 @@ boolean_t osm_switch_get_lft_block(IN const osm_switch_t * p_sw,
 		return FALSE;
 
 	CL_ASSERT(base_lid_ho + IB_SMP_DATA_SIZE - 1 <= IB_LID_UCAST_END_HO);
-	memcpy(p_block, &(p_sw->lft[base_lid_ho]), IB_SMP_DATA_SIZE);
+	memcpy(p_block, &(p_sw->new_lft[base_lid_ho]), IB_SMP_DATA_SIZE);
 	return TRUE;
 }
 
@@ -235,7 +235,8 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 				  IN boolean_t routing_for_lmc,
 				  IN boolean_t dor,
 				  IN boolean_t port_shifting,
-				  IN uint32_t scatter_ports)
+				  IN uint32_t scatter_ports,
+				  IN osm_lft_type_enum lft_enum)
 {
 	/*
 	   We support an enhanced LMC aware routing mode:
@@ -319,7 +320,7 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 	   4. the port has min-hops to the target (avoid loops)
 	 */
 	if (!ignore_existing) {
-		port_num = osm_switch_get_port_by_lid(p_sw, lid_ho);
+		port_num = osm_switch_get_port_by_lid(p_sw, lid_ho, lft_enum);
 
 		if (port_num != OSM_NO_PATH) {
 			CL_ASSERT(port_num < num_ports);
diff --git a/opensm/osm_ucast_file.c b/opensm/osm_ucast_file.c
index 730ce80..f891281 100644
--- a/opensm/osm_ucast_file.c
+++ b/opensm/osm_ucast_file.c
@@ -85,7 +85,7 @@ static void add_path(osm_opensm_t * p_osm,
 	uint8_t old_port;
 
 	new_lid = port_guid ? remap_lid(p_osm, lid, port_guid) : lid;
-	old_port = osm_switch_get_port_by_lid(p_sw, new_lid);
+	old_port = osm_switch_get_port_by_lid(p_sw, new_lid, OSM_LFT);
 	if (old_port != OSM_NO_PATH && old_port != port_num) {
 		OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
 			"LID collision is detected on switch "
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index a52b044..7dc69f3 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -234,7 +234,8 @@ static void ucast_mgr_process_port(IN osm_ucast_mgr_t * p_mgr,
 
 	if (lid_offset && !p_mgr->is_dor)
 		/* ignore potential overflow - it is handled in osm_switch.c */
-		start_from = osm_switch_get_port_by_lid(p_sw, lid_ho - 1) + 1;
+		start_from =
+		    osm_switch_get_port_by_lid(p_sw, lid_ho - 1, OSM_LFT) + 1;
 
 	OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
 		"Processing port 0x%" PRIx64
@@ -259,7 +260,8 @@ static void ucast_mgr_process_port(IN osm_ucast_mgr_t * p_mgr,
 					 p_mgr->p_subn->opt.lmc,
 					 p_mgr->is_dor,
 					 p_mgr->p_subn->opt.port_shifting,
-					 p_port->use_scatter);
+					 p_port->use_scatter,
+					 OSM_LFT);
 
 	if (port == OSM_NO_PATH) {
 		/* do not try to overwrite the ppro of non existing port ... */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
