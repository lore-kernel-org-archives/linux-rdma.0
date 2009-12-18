From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 07/12] opensm: Make torus-2QoS always use OSM_LOG_INFO,
 never LOG_INFO.
Date: Fri, 18 Dec 2009 13:50:56 -0700
Message-ID: <1261169461-2516-7-git-send-email-jaschut@sandia.gov>
References: <1258744509-11148-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1258744509-11148-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_ucast_torus.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/opensm/opensm/osm_ucast_torus.c b/opensm/opensm/osm_ucast_torus.c
index 0306af9..61e0bf3 100644
--- a/opensm/opensm/osm_ucast_torus.c
+++ b/opensm/opensm/osm_ucast_torus.c
@@ -7971,7 +7971,7 @@ void torus_update_osm_sl2vl(void *context, osm_port_t *sw_mgmt_port,
 		guid_t guid;
 
 		guid = osm_node_get_node_guid(sw_mgmt_port->p_node);
-		OSM_LOG(log, LOG_INFO,
+		OSM_LOG(log, OSM_LOG_INFO,
 			"Error: osm_port (GUID 0x%04llx) "
 			"not in our fabric description\n", ntohllu(guid));
 		return;
@@ -8527,7 +8527,7 @@ uint8_t torus_path_sl(void *context, uint8_t path_sl_hint,
 		sport = osm_port_relink_endpoint(osm_sport);
 		if (!sport) {
 			guid = osm_node_get_node_guid(osm_sport->p_node);
-			OSM_LOG(log, LOG_INFO,
+			OSM_LOG(log, OSM_LOG_INFO,
 				"Error: osm_sport (GUID 0x%04llx) "
 				"not in our fabric description\n",
 				ntohllu(guid));
@@ -8539,7 +8539,7 @@ uint8_t torus_path_sl(void *context, uint8_t path_sl_hint,
 		dport = osm_port_relink_endpoint(osm_dport);
 		if (!dport) {
 			guid = osm_node_get_node_guid(osm_dport->p_node);
-			OSM_LOG(log, LOG_INFO,
+			OSM_LOG(log, OSM_LOG_INFO,
 				"Error: osm_dport (GUID 0x%04llx) "
 				"not in our fabric description\n",
 				ntohllu(guid));
@@ -8552,14 +8552,14 @@ uint8_t torus_path_sl(void *context, uint8_t path_sl_hint,
 	 */
 	if (sport->type != SRCSINK) {
 		guid = osm_node_get_node_guid(osm_sport->p_node);
-		OSM_LOG(log, LOG_INFO,
+		OSM_LOG(log, OSM_LOG_INFO,
 			"Error: osm_sport (GUID 0x%04llx) "
 			"not a data src/sink port\n", ntohllu(guid));
 		goto out;
 	}
 	if (dport->type != SRCSINK) {
 		guid = osm_node_get_node_guid(osm_dport->p_node);
-		OSM_LOG(log, LOG_INFO,
+		OSM_LOG(log, OSM_LOG_INFO,
 			"Error: osm_dport (GUID 0x%04llx) "
 			"not a data src/sink port\n", ntohllu(guid));
 		goto out;
-- 
1.5.6.GIT


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
