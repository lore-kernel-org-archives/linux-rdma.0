From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 06/10] opensm/console: add "print all" to print_counters
 console command
Date: Tue, 3 Jul 2012 16:53:33 -0700
Message-ID: <20120703165333.8f77ac6b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org




Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_perfmgr_db.h |    1 +
 opensm/osm_console.c            |   12 ++++--------
 opensm/osm_perfmgr.c            |   15 +++++++++------
 opensm/osm_perfmgr_db.c         |   19 +++++++++++++++++++
 4 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/include/opensm/osm_perfmgr_db.h b/include/opensm/osm_perfmgr_db.h
index 6cfb1aa..d1e9049 100644
--- a/include/opensm/osm_perfmgr_db.h
+++ b/include/opensm/osm_perfmgr_db.h
@@ -190,6 +190,7 @@ perfmgr_db_err_t perfmgr_db_mark_active(perfmgr_db_t *db, uint64_t guid,
 void perfmgr_db_clear_counters(perfmgr_db_t * db);
 perfmgr_db_err_t perfmgr_db_dump(perfmgr_db_t * db, char *file,
 				 perfmgr_db_dump_t dump_type);
+void perfmgr_db_print_all(perfmgr_db_t * db, FILE *fp);
 void perfmgr_db_print_by_name(perfmgr_db_t * db, char *nodename, FILE *fp);
 void perfmgr_db_print_by_guid(perfmgr_db_t * db, uint64_t guid, FILE *fp);
 
diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 79a40d1..8e09b69 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -252,7 +252,8 @@ static void help_perfmgr(FILE * out, int detail)
 		fprintf(out,
 			"   [dump_counters [mach]] -- dump the counters (optionally in [mach]ine readable format)\n");
 		fprintf(out,
-			"   [print_counters <nodename|nodeguid>] -- print the counters for the specified node\n");
+			"   [print_counters [<nodename|nodeguid>]] -- print the internal counters\n"
+			"                                             Optionaly limit output by name or guid\n");
 		fprintf(out,
 			"   [dump_redir [<nodename|nodeguid>]] -- dump the redirection table\n");
 		fprintf(out,
@@ -1467,13 +1468,8 @@ static void perfmgr_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 		} else if (strcmp(p_cmd, "print_counters") == 0) {
 			char *port = NULL;
 			p_cmd = name_token(p_last);
-			if (p_cmd) {
-				osm_perfmgr_print_counters(&p_osm->perfmgr,
-							   p_cmd, out);
-			} else {
-				fprintf(out,
-					"print_counters requires a node name or node GUID to be specified\n");
-			}
+			osm_perfmgr_print_counters(&p_osm->perfmgr, p_cmd,
+						   out);
 		} else if (strcmp(p_cmd, "dump_redir") == 0) {
 			p_cmd = name_token(p_last);
 			dump_redir(p_osm, p_cmd, out);
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 4a0386a..28dd996 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -1432,11 +1432,14 @@ void osm_perfmgr_dump_counters(osm_perfmgr_t * pm, perfmgr_db_dump_t dump_type)
  *******************************************************************/
 void osm_perfmgr_print_counters(osm_perfmgr_t * pm, char *nodename, FILE * fp)
 {
-	char *end = NULL;
-	uint64_t guid = strtoull(nodename, &end, 0);
-	if (nodename + strlen(nodename) != end)
-		perfmgr_db_print_by_name(pm->db, nodename, fp);
-	else
-		perfmgr_db_print_by_guid(pm->db, guid, fp);
+	if (nodename) {
+		char *end = NULL;
+		uint64_t guid = strtoull(nodename, &end, 0);
+		if (nodename + strlen(nodename) != end)
+			perfmgr_db_print_by_name(pm->db, nodename, fp);
+		else
+			perfmgr_db_print_by_guid(pm->db, guid, fp);
+	} else
+		perfmgr_db_print_all(pm->db, fp);
 }
 #endif				/* ENABLE_OSM_PERF_MGR */
diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index 44994f1..6c8ef9a 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -788,6 +788,25 @@ static void db_dump(cl_map_item_t * const p_map_item, void *context)
 }
 
 /**********************************************************************
+ * print all node data to fp
+ **********************************************************************/
+void
+perfmgr_db_print_all(perfmgr_db_t * db, FILE *fp)
+{
+	cl_map_item_t *item;
+	db_node_t *node;
+
+	cl_plock_acquire(&db->lock);
+	item = cl_qmap_head(&db->pc_data);
+	while (item != cl_qmap_end(&db->pc_data)) {
+		node = (db_node_t *)item;
+		dump_node_hr(node, fp);
+		item = cl_qmap_next(item);
+	}
+	cl_plock_release(&db->lock);
+}
+
+/**********************************************************************
  * print node data to fp
  **********************************************************************/
 void
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
