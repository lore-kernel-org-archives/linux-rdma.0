From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 4/4] opensm/console: add "print all" to print_counters
 console command
Date: Thu, 24 Mar 2011 18:20:56 -0700
Message-ID: <20110324182056.b47260e5.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Mon, 14 Mar 2011 13:18:28 -0700
Subject: [PATCH] opensm/console: add "print all" to print_counters console command

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_perfmgr_db.h |    1 +
 opensm/osm_console.c            |   12 ++++--------
 opensm/osm_perfmgr.c            |   13 ++++++++-----
 opensm/osm_perfmgr_db.c         |   19 +++++++++++++++++++
 4 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/include/opensm/osm_perfmgr_db.h b/include/opensm/osm_perfmgr_db.h
index 8f4706d..57e0fb3 100644
--- a/include/opensm/osm_perfmgr_db.h
+++ b/include/opensm/osm_perfmgr_db.h
@@ -183,6 +183,7 @@ perfmgr_db_err_t perfmgr_db_clear_prev_dc(perfmgr_db_t * db, uint64_t guid,
 void perfmgr_db_clear_counters(perfmgr_db_t * db);
 perfmgr_db_err_t perfmgr_db_dump(perfmgr_db_t * db, char *file,
 				 perfmgr_db_dump_t dump_type);
+void perfmgr_db_print_all(perfmgr_db_t * db, FILE *fp);
 void perfmgr_db_print_by_name(perfmgr_db_t * db, char *nodename, FILE *fp);
 void perfmgr_db_print_by_guid(perfmgr_db_t * db, uint64_t guid, FILE *fp);
 
diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 0ee528e..114c569 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -244,7 +244,8 @@ static void help_perfmgr(FILE * out, int detail)
 		fprintf(out,
 			"   [dump_counters [mach]] -- dump the counters (optionally in [mach]ine readable format)\n");
 		fprintf(out,
-			"   [print_counters <nodename|nodeguid>] -- print the counters for the specified node\n");
+			"   [print_counters [<nodename|nodeguid>]] -- print the internal counters\n"
+			"                                             Optionaly limit output by name or guid\n");
 		fprintf(out,
 			"   [dump_redir [<nodename|nodeguid>]] -- dump the redirection table\n");
 		fprintf(out,
@@ -1358,13 +1359,8 @@ static void perfmgr_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 			}
 		} else if (strcmp(p_cmd, "print_counters") == 0) {
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
index 6952d72..e6070c3 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -1740,10 +1740,13 @@ void osm_perfmgr_dump_counters(osm_perfmgr_t * pm, perfmgr_db_dump_t dump_type)
  *******************************************************************/
 void osm_perfmgr_print_counters(osm_perfmgr_t * pm, char *nodename, FILE * fp)
 {
-	uint64_t guid = strtoull(nodename, NULL, 0);
-	if (guid == 0 && errno)
-		perfmgr_db_print_by_name(pm->db, nodename, fp);
-	else
-		perfmgr_db_print_by_guid(pm->db, guid, fp);
+	if (nodename) {
+		uint64_t guid = strtoull(nodename, NULL, 0);
+		if (guid == 0 && errno)
+			perfmgr_db_print_by_name(pm->db, nodename, fp);
+		else
+			perfmgr_db_print_by_guid(pm->db, guid, fp);
+	} else
+		perfmgr_db_print_all(pm->db, fp);
 }
 #endif				/* ENABLE_OSM_PERF_MGR */
diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index 7a96d41..10bd41e 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -694,6 +694,25 @@ static void db_dump(cl_map_item_t * const p_map_item, void *context)
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
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
