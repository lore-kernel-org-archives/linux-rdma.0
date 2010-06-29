From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] opensm: Modify OSM_LOG_SYS messages
Date: Tue, 29 Jun 2010 17:38:54 +0300
Message-ID: <4C2A057E.6090809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Modify OSM_LOG_SYS messages

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_node_info_rcv.c |    7 ++-----
 opensm/opensm/osm_sa.c            |    2 +-
 opensm/opensm/osm_ucast_file.c    |    4 ++--
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/opensm/opensm/osm_node_info_rcv.c b/opensm/opensm/osm_node_info_rcv.c
index b3e272c..d24e757 100644
--- a/opensm/opensm/osm_node_info_rcv.c
+++ b/opensm/opensm/osm_node_info_rcv.c
@@ -72,8 +72,8 @@ static void report_duplicated_guid(IN osm_sm_t * sm, osm_physp_t * p_physp,
 	p_old = p_physp->p_remote_physp;
 	p_new = osm_node_get_physp_ptr(p_neighbor_node, port_num);
 
-	OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D01: "
-		"Found duplicated node.\n"
+	OSM_LOG(sm->p_log, OSM_LOG_SYS | OSM_LOG_ERROR, "ERR 0D01: "
+		"Found duplicated node GUID.\n"
 		"Node 0x%" PRIx64 " port %u is reachable from remote node "
 		"0x%" PRIx64 " port %u and remote node 0x%" PRIx64 " port %u.\n"
 		"Paths are:\n",
@@ -91,9 +91,6 @@ static void report_duplicated_guid(IN osm_sm_t * sm, osm_physp_t * p_physp,
 			"DR path with hop count %d couldn't be extended\n",
 			path.hop_count);
 	osm_dump_dr_path(sm->p_log, &path, OSM_LOG_ERROR);
-
-	osm_log(sm->p_log, OSM_LOG_SYS,
-		"FATAL: duplicated guids or 12x lane reversal\n");
 }
 
 static void requery_dup_node_info(IN osm_sm_t * sm, osm_physp_t * p_physp,
diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
index 3473e4c..ef9872d 100644
--- a/opensm/opensm/osm_sa.c
+++ b/opensm/opensm/osm_sa.c
@@ -923,7 +923,7 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 	file = fopen(file_name, "r");
 	if (!file) {
 		OSM_LOG(&p_osm->log, OSM_LOG_ERROR | OSM_LOG_SYS, "ERR 4C02: "
-			"cannot open sa db file \'%s\'. Skip restoring\n",
+			"Can't open sa db file \'%s\'. Skip restoring\n",
 			file_name);
 		return -1;
 	}
diff --git a/opensm/opensm/osm_ucast_file.c b/opensm/opensm/osm_ucast_file.c
index ef79fc1..8cb3cb6 100644
--- a/opensm/opensm/osm_ucast_file.c
+++ b/opensm/opensm/osm_ucast_file.c
@@ -142,7 +142,7 @@ static int do_ucast_file_load(void *context)
 	file = fopen(file_name, "r");
 	if (!file) {
 		OSM_LOG(&p_osm->log, OSM_LOG_ERROR | OSM_LOG_SYS, "ERR 6302: "
-			"cannot open ucast dump file \'%s\': %m\n", file_name);
+			"Can't open ucast dump file \'%s\': %m\n", file_name);
 		return -1;
 	}
 
@@ -269,7 +269,7 @@ static int do_lid_matrix_file_load(void *context)
 	file = fopen(file_name, "r");
 	if (!file) {
 		OSM_LOG(&p_osm->log, OSM_LOG_ERROR | OSM_LOG_SYS, "ERR 6305: "
-			"cannot open lid matrix file \'%s\': %m\n", file_name);
+			"Can't open lid matrix file \'%s\': %m\n", file_name);
 		return -1;
 	}
 
-- 
1.5.3.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
