From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH v4 17/18] opensm: Avoid havoc in dump_ucast_routes()
 caused by torus-2QoS persistent use of osm_port_t:priv.
Date: Fri,  3 Sep 2010 10:43:13 -0600
Message-ID: <1283532194-27112-18-git-send-email-jaschut@sandia.gov>
References: <1283532194-27112-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283532194-27112-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Torus-2QoS makes persistent use of osm_port_t:priv to speed calculation
of path SL values.

However, osm_switch_recommend_path() uses a non-NULL osm_port_t:priv
as a flag that osm_port_t:priv holds a tracking array used when
LMC > 0.  It turns out that 1) dump_ucast_routes() does not need
osm_switch_recommend_path() to consider alternate routes, and 2)
before the addition of torus-2QoS, osm_port_t:priv use never
persisted past the unicast routing function, so it was always
NULL on entry to dump_ucast_routes().

Fix this up by making the routing_for_lmc flag explicitly set by
the caller of osm_switch_recommend_path(), rather than inferring
it from osm_port_t:priv.  This retains existing behavior for
existing routing engines, and allows torus-2QoS to make persistent
use of osm_port_t:priv.

The alternative would be to add another member to osm_port_t,
say osm_port_t:priv2.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/include/opensm/osm_switch.h |   12 ++++++++++++
 opensm/opensm/osm_dump.c           |    2 +-
 opensm/opensm/osm_switch.c         |    7 ++++---
 opensm/opensm/osm_ucast_mgr.c      |    1 +
 4 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/opensm/include/opensm/osm_switch.h b/opensm/include/opensm/osm_switch.h
index 51a8427..f407dd9 100644
--- a/opensm/include/opensm/osm_switch.h
+++ b/opensm/include/opensm/osm_switch.h
@@ -918,6 +918,7 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 				  IN osm_port_t * p_port, IN uint16_t lid_ho,
 				  IN unsigned start_from,
 				  IN boolean_t ignore_existing,
+				  IN boolean_t routing_for_lmc,
 				  IN boolean_t dor);
 /*
 * PARAMETERS
@@ -940,6 +941,17 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 *		If false, the switch will choose an existing route if one
 *		exists, otherwise will choose the optimal route.
 *
+*	routing_for_lmc
+*		[in] We support an enhanced LMC aware routing mode:
+*		In the case of LMC > 0, we can track the remote side
+*		system and node for all of the lids of the target
+*		and try and avoid routing again through the same
+*		system / node.
+*
+*		Assume if routing_for_lmc is TRUE that this procedure
+*		was provided with the tracking array and counter via
+*		p_port->priv, and we can conduct this algorithm.
+*
 *	dor
 *		[in] If TRUE, Dimension Order Routing will be done.
 *
diff --git a/opensm/opensm/osm_dump.c b/opensm/opensm/osm_dump.c
index bfff1a0..535a03f 100644
--- a/opensm/opensm/osm_dump.c
+++ b/opensm/opensm/osm_dump.c
@@ -221,7 +221,7 @@ static void dump_ucast_routes(cl_map_item_t * item, FILE * file, void *cxt)
 			/* No LMC Optimization */
 			best_port = osm_switch_recommend_path(p_sw, p_port,
 							      lid_ho, 1, TRUE,
-							      dor);
+							      FALSE, dor);
 			fprintf(file, "No %u hop path possible via port %u!",
 				best_hops, best_port);
 		}
diff --git a/opensm/opensm/osm_switch.c b/opensm/opensm/osm_switch.c
index b621852..9785a9d 100644
--- a/opensm/opensm/osm_switch.c
+++ b/opensm/opensm/osm_switch.c
@@ -216,6 +216,7 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 				  IN osm_port_t * p_port, IN uint16_t lid_ho,
 				  IN unsigned start_from,
 				  IN boolean_t ignore_existing,
+				  IN boolean_t routing_for_lmc,
 				  IN boolean_t dor)
 {
 	/*
@@ -225,10 +226,10 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 	   and try and avoid routing again through the same
 	   system / node.
 
-	   If this procedure is provided with the tracking array
-	   and counter we can conduct this algorithm.
+	   Assume if routing_for_lmc is true that this procedure was
+	   provided the tracking array and counter via p_port->priv,
+	   and we can conduct this algorithm.
 	 */
-	boolean_t routing_for_lmc = (p_port->priv != NULL);
 	uint16_t base_lid;
 	uint8_t hops;
 	uint8_t least_hops;
diff --git a/opensm/opensm/osm_ucast_mgr.c b/opensm/opensm/osm_ucast_mgr.c
index e6e40f0..f5a715f 100644
--- a/opensm/opensm/osm_ucast_mgr.c
+++ b/opensm/opensm/osm_ucast_mgr.c
@@ -252,6 +252,7 @@ static void ucast_mgr_process_port(IN osm_ucast_mgr_t * p_mgr,
 	 */
 	port = osm_switch_recommend_path(p_sw, p_port, lid_ho, start_from,
 					 p_mgr->p_subn->ignore_existing_lfts,
+					 p_mgr->p_subn->opt.lmc,
 					 p_mgr->is_dor);
 
 	if (port == OSM_NO_PATH) {
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
