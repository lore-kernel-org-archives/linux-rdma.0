From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH v4 05/18] opensm: Add struct osm_routing_engine callback
 to build spanning trees for multicast.
Date: Fri,  3 Sep 2010 10:43:01 -0600
Message-ID: <1283532194-27112-6-git-send-email-jaschut@sandia.gov>
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

If a routing engine needs to compute spanning trees with special
properties, it needs a way to override the default implementation.
A routing engine callback provides that mechanism.  Routing engines
that can use the default implementation can leave the callback
pointer set to NULL.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/include/opensm/osm_opensm.h |    6 ++++++
 opensm/opensm/osm_mcast_mgr.c      |    7 ++++++-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/opensm/include/opensm/osm_opensm.h b/opensm/include/opensm/osm_opensm.h
index 734a6db..fddcf53 100644
--- a/opensm/include/opensm/osm_opensm.h
+++ b/opensm/include/opensm/osm_opensm.h
@@ -132,6 +132,8 @@ struct osm_routing_engine {
 	uint8_t (*path_sl)(void *context, IN uint8_t path_sl_hint,
 			   IN const osm_port_t *src_port,
 			   IN const osm_port_t *dst_port);
+	ib_api_status_t (*mcast_build_stree)(void *context,
+					     IN OUT osm_mgrp_box_t *mgb);
 	void (*delete) (void *context);
 	struct osm_routing_engine *next;
 };
@@ -165,6 +167,10 @@ struct osm_routing_engine {
 *	path_sl
 *		The callback for computing path SL.
 *
+*	mcast_build_stree
+*		The callback for building the spanning tree for multicast
+*		forwarding, called per MLID.
+*
 *	delete
 *		The delete method, may be used for routing engine
 *		internals cleanup.
diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index e42070d..48de91c 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -987,6 +987,7 @@ Exit:
 static ib_api_status_t mcast_mgr_process_mlid(osm_sm_t * sm, uint16_t mlid)
 {
 	ib_api_status_t status = IB_SUCCESS;
+	struct osm_routing_engine *re = sm->p_subn->p_osm->routing_engine_used;
 	osm_mgrp_box_t *mbox;
 
 	OSM_LOG_ENTER(sm->p_log);
@@ -1001,7 +1002,11 @@ static ib_api_status_t mcast_mgr_process_mlid(osm_sm_t * sm, uint16_t mlid)
 
 	mbox = osm_get_mbox_by_mlid(sm->p_subn, cl_hton16(mlid));
 	if (mbox) {
-		status = mcast_mgr_build_spanning_tree(sm, mbox);
+		if (re && re->mcast_build_stree)
+			status = re->mcast_build_stree(re->context, mbox);
+		else
+			status = mcast_mgr_build_spanning_tree(sm, mbox);
+
 		if (status != IB_SUCCESS)
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A17: "
 				"Unable to create spanning tree (%s) for mlid "
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
