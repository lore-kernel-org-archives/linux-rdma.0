From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 06/12] opensm: Remove redundant function names in
 torus-2QoS logging.
Date: Fri, 18 Dec 2009 13:50:55 -0700
Message-ID: <1261169461-2516-6-git-send-email-jaschut@sandia.gov>
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
 opensm/opensm/osm_ucast_torus.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/opensm/opensm/osm_ucast_torus.c b/opensm/opensm/osm_ucast_torus.c
index b740f93..0306af9 100644
--- a/opensm/opensm/osm_ucast_torus.c
+++ b/opensm/opensm/osm_ucast_torus.c
@@ -8437,7 +8437,7 @@ bool get_lid(struct port_grp *pg, unsigned p,
 	osm_port = ep->osm_port;
 	if (!(osm_port && osm_port->priv == ep)) {
 		OSM_LOG(&pg->sw->torus->osm->log, OSM_LOG_ERROR,
-			"Error: get_lid: ep->osm_port->priv != ep "
+			"Error: ep->osm_port->priv != ep "
 			"for sw 0x%04llu port %d\n",
 			ntohllu(((struct t_switch *)(ep->sw))->n_id), ep->port);
 		return false;
@@ -8528,8 +8528,8 @@ uint8_t torus_path_sl(void *context, uint8_t path_sl_hint,
 		if (!sport) {
 			guid = osm_node_get_node_guid(osm_sport->p_node);
 			OSM_LOG(log, LOG_INFO,
-				"Error: get_torus_sl: osm_sport (GUID "
-				"0x%04llx) not in our fabric description\n",
+				"Error: osm_sport (GUID 0x%04llx) "
+				"not in our fabric description\n",
 				ntohllu(guid));
 			goto out;
 		}
@@ -8540,8 +8540,8 @@ uint8_t torus_path_sl(void *context, uint8_t path_sl_hint,
 		if (!dport) {
 			guid = osm_node_get_node_guid(osm_dport->p_node);
 			OSM_LOG(log, LOG_INFO,
-				"Error: get_torus_sl: osm_dport (GUID "
-				"0x%04llx) not in our fabric description\n",
+				"Error: osm_dport (GUID 0x%04llx) "
+				"not in our fabric description\n",
 				ntohllu(guid));
 			goto out;
 		}
@@ -8553,14 +8553,14 @@ uint8_t torus_path_sl(void *context, uint8_t path_sl_hint,
 	if (sport->type != SRCSINK) {
 		guid = osm_node_get_node_guid(osm_sport->p_node);
 		OSM_LOG(log, LOG_INFO,
-			"Error: get_torus_sl: osm_sport (GUID 0x%04llx) "
+			"Error: osm_sport (GUID 0x%04llx) "
 			"not a data src/sink port\n", ntohllu(guid));
 		goto out;
 	}
 	if (dport->type != SRCSINK) {
 		guid = osm_node_get_node_guid(osm_dport->p_node);
 		OSM_LOG(log, LOG_INFO,
-			"Error: get_torus_sl: osm_dport (GUID 0x%04llx) "
+			"Error: osm_dport (GUID 0x%04llx) "
 			"not a data src/sink port\n", ntohllu(guid));
 		goto out;
 	}
-- 
1.5.6.GIT


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
