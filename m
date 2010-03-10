From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH v2 06/15] opensm: Make mcast_mgr_purge_tree() available
 outside osm_mcast_mgr.c.
Date: Wed, 10 Mar 2010 11:06:48 -0700
Message-ID: <1268244416-20351-7-git-send-email-jaschut@sandia.gov>
References: <1268244416-20351-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1268244416-20351-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A routing engine that needs to compute multicast spanning trees with
special properties will need to delete old trees.  There's already
a function that does this: mcast_mgr_purge_tree().

Make it available outside osm_mcast_mgr.c, and change the name
to follow the naming convention (osm_ prefix) for global functions.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/include/opensm/osm_multicast.h |   33 +++++++++++++++++++++++++++++++++
 opensm/opensm/osm_mcast_mgr.c         |    4 ++--
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/opensm/include/opensm/osm_multicast.h b/opensm/include/opensm/osm_multicast.h
index 1da575d..df6ac6c 100644
--- a/opensm/include/opensm/osm_multicast.h
+++ b/opensm/include/opensm/osm_multicast.h
@@ -53,6 +53,7 @@
 #include <opensm/osm_mcm_port.h>
 #include <opensm/osm_subnet.h>
 #include <opensm/osm_log.h>
+#include <opensm/osm_sm.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -193,6 +194,38 @@ osm_mgrp_t *osm_mgrp_new(IN osm_subn_t * subn, IN ib_net16_t mlid,
 *	Multicast Group, osm_mgrp_delete
 *********/
 
+/*
+ * Need a forward declaration to work around include loop:
+ * osm_sm.h <- osm_multicast.h
+ */
+struct osm_sm;
+
+/****f* OpenSM: Multicast Tree/osm_purge_mtree
+* NAME
+*	osm_purge_mtree
+*
+* DESCRIPTION
+*	Frees all the nodes in a multicast spanning tree
+*
+* SYNOPSIS
+*/
+void osm_purge_mtree(IN struct osm_sm * sm, IN osm_mgrp_box_t * mgb);
+/*
+* PARAMETERS
+*	sm
+*		[in] Pointer to osm_sm_t object.
+*	mgb
+*		[in] Pointer to an osm_mgrp_box_t object.
+*
+* RETURN VALUES
+*	None.
+*
+*
+* NOTES
+*
+* SEE ALSO
+*********/
+
 /****f* OpenSM: Multicast Group/osm_mgrp_is_guid
 * NAME
 *	osm_mgrp_is_guid
diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index bd67d4e..e6db6db 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -146,7 +146,7 @@ static void mcast_mgr_purge_tree_node(IN osm_mtree_node_t * p_mtn)
 	free(p_mtn);
 }
 
-static void mcast_mgr_purge_tree(osm_sm_t * sm, IN osm_mgrp_box_t * mbox)
+void osm_purge_mtree(osm_sm_t * sm, IN osm_mgrp_box_t * mbox)
 {
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -735,7 +735,7 @@ static ib_api_status_t mcast_mgr_build_spanning_tree(osm_sm_t * sm,
 	   on multicast forwarding table information if the user wants to
 	   preserve existing multicast routes.
 	 */
-	mcast_mgr_purge_tree(sm, mbox);
+	osm_purge_mtree(sm, mbox);
 
 	/* build the first "subset" containing all member ports */
 	if (make_port_list(&port_list, mbox)) {
-- 
1.6.6.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
