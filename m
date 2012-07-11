From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V2 07/10] opensm/console; add port option to perfmgr
 print_counters
Date: Wed, 11 Jul 2012 11:48:14 -0700
Message-ID: <20120711114814.a6646c91bdfd014d362418cc@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Changes since V1:
	My rebase got cross wired for the console help message.  Fix this.


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_perfmgr.h    |    3 ++-
 include/opensm/osm_perfmgr_db.h |    6 ++++--
 opensm/osm_console.c            |   13 ++++++++++---
 opensm/osm_perfmgr.c            |    7 ++++---
 opensm/osm_perfmgr_db.c         |   33 +++++++++++++++++++++++----------
 5 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/include/opensm/osm_perfmgr.h b/include/opensm/osm_perfmgr.h
index d9a3102..68cf7f3 100644
--- a/include/opensm/osm_perfmgr.h
+++ b/include/opensm/osm_perfmgr.h
@@ -245,7 +245,8 @@ inline static unsigned osm_perfmgr_delete_inactive(osm_perfmgr_t * pm)
 void osm_perfmgr_clear_counters(osm_perfmgr_t * p_perfmgr);
 void osm_perfmgr_dump_counters(osm_perfmgr_t * p_perfmgr,
 			       perfmgr_db_dump_t dump_type);
-void osm_perfmgr_print_counters(osm_perfmgr_t *pm, char *nodename, FILE *fp);
+void osm_perfmgr_print_counters(osm_perfmgr_t *pm, char *nodename, FILE *fp,
+				char *port);
 
 ib_api_status_t osm_perfmgr_bind(osm_perfmgr_t * p_perfmgr,
 				 ib_net64_t port_guid);
diff --git a/include/opensm/osm_perfmgr_db.h b/include/opensm/osm_perfmgr_db.h
index d1e9049..d6c8feb 100644
--- a/include/opensm/osm_perfmgr_db.h
+++ b/include/opensm/osm_perfmgr_db.h
@@ -191,8 +191,10 @@ void perfmgr_db_clear_counters(perfmgr_db_t * db);
 perfmgr_db_err_t perfmgr_db_dump(perfmgr_db_t * db, char *file,
 				 perfmgr_db_dump_t dump_type);
 void perfmgr_db_print_all(perfmgr_db_t * db, FILE *fp);
-void perfmgr_db_print_by_name(perfmgr_db_t * db, char *nodename, FILE *fp);
-void perfmgr_db_print_by_guid(perfmgr_db_t * db, uint64_t guid, FILE *fp);
+void perfmgr_db_print_by_name(perfmgr_db_t * db, char *nodename, FILE *fp,
+			      char *port);
+void perfmgr_db_print_by_guid(perfmgr_db_t * db, uint64_t guid, FILE *fp,
+			      char *port);
 
 /** =========================================================================
  * helper functions to fill in the various db objects from wire objects
diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 8e09b69..b6d7d31 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -252,8 +252,8 @@ static void help_perfmgr(FILE * out, int detail)
 		fprintf(out,
 			"   [dump_counters [mach]] -- dump the counters (optionally in [mach]ine readable format)\n");
 		fprintf(out,
-			"   [print_counters [<nodename|nodeguid>]] -- print the internal counters\n"
-			"                                             Optionaly limit output by name or guid\n");
+			"   [print_counters [<nodename|nodeguid>][:<port>]] -- print the internal counters\n"
+			"                                                      Optionaly limit output by name, guid, or port\n");
 		fprintf(out,
 			"   [dump_redir [<nodename|nodeguid>]] -- dump the redirection table\n");
 		fprintf(out,
@@ -1468,8 +1468,15 @@ static void perfmgr_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 		} else if (strcmp(p_cmd, "print_counters") == 0) {
 			char *port = NULL;
 			p_cmd = name_token(p_last);
+			if (p_cmd) {
+				port = strchr(p_cmd, ':');
+				if (port) {
+					*port = '\0';
+					port++;
+				}
+			}
 			osm_perfmgr_print_counters(&p_osm->perfmgr, p_cmd,
-						   out);
+						   out, port);
 		} else if (strcmp(p_cmd, "dump_redir") == 0) {
 			p_cmd = name_token(p_last);
 			dump_redir(p_osm, p_cmd, out);
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 840af39..456c163 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -1436,15 +1436,16 @@ void osm_perfmgr_dump_counters(osm_perfmgr_t * pm, perfmgr_db_dump_t dump_type)
 /*******************************************************************
  * Print the DB information to the fp specified
  *******************************************************************/
-void osm_perfmgr_print_counters(osm_perfmgr_t * pm, char *nodename, FILE * fp)
+void osm_perfmgr_print_counters(osm_perfmgr_t * pm, char *nodename, FILE * fp,
+				char *port)
 {
 	if (nodename) {
 		char *end = NULL;
 		uint64_t guid = strtoull(nodename, &end, 0);
 		if (nodename + strlen(nodename) != end)
-			perfmgr_db_print_by_name(pm->db, nodename, fp);
+			perfmgr_db_print_by_name(pm->db, nodename, fp, port);
 		else
-			perfmgr_db_print_by_guid(pm->db, guid, fp);
+			perfmgr_db_print_by_guid(pm->db, guid, fp, port);
 	} else
 		perfmgr_db_print_all(pm->db, fp);
 }
diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index 6c8ef9a..6f9c1ab 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -702,12 +702,23 @@ static void dump_node_mr(db_node_t * node, FILE * fp)
 /**********************************************************************
  * Output a human readable output of the port counters
  **********************************************************************/
-static void dump_node_hr(db_node_t * node, FILE * fp)
-{
-	int i = 0;
-
+static void dump_node_hr(db_node_t * node, FILE * fp, char *port)
+{
+	int i = (node->esp0) ? 0 : 1;
+	int num_ports = node->num_ports;
+
+	if (port) {
+		char *end = NULL;
+		int p = strtoul(port, &end, 0);
+		if (port + strlen(port) == end && p >= i && p < num_ports) {
+			i = p;
+			num_ports = p+1;
+		} else {
+			fprintf(fp, "Warning: \"%s\" is not a valid port\n", port);
+		}
+	}
 	fprintf(fp, "\n");
-	for (i = (node->esp0) ? 0 : 1; i < node->num_ports; i++) {
+	for (/* set above */; i < num_ports; i++) {
 		char *since = ctime(&node->ports[i].last_reset);
 
 		if (!node->ports[i].valid)
@@ -782,7 +793,7 @@ static void db_dump(cl_map_item_t * const p_map_item, void *context)
 		break;
 	case PERFMGR_EVENT_DB_DUMP_HR:
 	default:
-		dump_node_hr(node, fp);
+		dump_node_hr(node, fp, NULL);
 		break;
 	}
 }
@@ -800,7 +811,7 @@ perfmgr_db_print_all(perfmgr_db_t * db, FILE *fp)
 	item = cl_qmap_head(&db->pc_data);
 	while (item != cl_qmap_end(&db->pc_data)) {
 		node = (db_node_t *)item;
-		dump_node_hr(node, fp);
+		dump_node_hr(node, fp, NULL);
 		item = cl_qmap_next(item);
 	}
 	cl_plock_release(&db->lock);
@@ -810,7 +821,8 @@ perfmgr_db_print_all(perfmgr_db_t * db, FILE *fp)
  * print node data to fp
  **********************************************************************/
 void
-perfmgr_db_print_by_name(perfmgr_db_t * db, char *nodename, FILE *fp)
+perfmgr_db_print_by_name(perfmgr_db_t * db, char *nodename, FILE *fp,
+			 char *port)
 {
 	cl_map_item_t *item;
 	db_node_t *node;
@@ -822,7 +834,7 @@ perfmgr_db_print_by_name(perfmgr_db_t * db, char *nodename, FILE *fp)
 	while (item != cl_qmap_end(&db->pc_data)) {
 		node = (db_node_t *)item;
 		if (strcmp(node->node_name, nodename) == 0) {
-			dump_node_hr(node, fp);
+			dump_node_hr(node, fp, port);
 			goto done;
 		}
 		item = cl_qmap_next(item);
@@ -837,7 +849,8 @@ done:
  * print node data to fp
  **********************************************************************/
 void
-perfmgr_db_print_by_guid(perfmgr_db_t * db, uint64_t nodeguid, FILE *fp)
+perfmgr_db_print_by_guid(perfmgr_db_t * db, uint64_t nodeguid, FILE *fp,
+			 char *port)
 {
 	cl_map_item_t *node;
 
@@ -845,7 +858,7 @@ perfmgr_db_print_by_guid(perfmgr_db_t * db, uint64_t nodeguid, FILE *fp)
 
 	node = cl_qmap_get(&db->pc_data, nodeguid);
 	if (node != cl_qmap_end(&db->pc_data))
-		dump_node_hr((db_node_t *)node, fp);
+		dump_node_hr((db_node_t *)node, fp, port);
 	else
 		fprintf(fp, "Node 0x%" PRIx64 " not found...\n", nodeguid);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
