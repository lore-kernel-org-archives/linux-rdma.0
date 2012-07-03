From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 05/10] opensm: perfmgr mark inactive nodes in perfmgr db
Date: Tue, 3 Jul 2012 16:53:22 -0700
Message-ID: <20120703165322.0fb22b1c.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



When "missing" nodes are not removed by default mark them as inactive.  In
addition, add a console option to remove them.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_perfmgr.h    |    7 ++++
 include/opensm/osm_perfmgr_db.h |    5 +++
 opensm/osm_console.c            |    8 ++++-
 opensm/osm_perfmgr.c            |    4 ++
 opensm/osm_perfmgr_db.c         |   69 ++++++++++++++++++++++++++++++++++++--
 5 files changed, 88 insertions(+), 5 deletions(-)

diff --git a/include/opensm/osm_perfmgr.h b/include/opensm/osm_perfmgr.h
index be6f978..d9a3102 100644
--- a/include/opensm/osm_perfmgr.h
+++ b/include/opensm/osm_perfmgr.h
@@ -235,6 +235,13 @@ inline static uint16_t osm_perfmgr_get_sweep_time_s(osm_perfmgr_t * p_perfmgr)
 	return p_perfmgr->sweep_time_s;
 }
 
+inline static unsigned osm_perfmgr_delete_inactive(osm_perfmgr_t * pm)
+{
+	unsigned rc;
+	perfmgr_db_delete_inactive(pm->db, &rc);
+	return (rc);
+}
+
 void osm_perfmgr_clear_counters(osm_perfmgr_t * p_perfmgr);
 void osm_perfmgr_dump_counters(osm_perfmgr_t * p_perfmgr,
 			       perfmgr_db_dump_t dump_type);
diff --git a/include/opensm/osm_perfmgr_db.h b/include/opensm/osm_perfmgr_db.h
index 8231a12..6cfb1aa 100644
--- a/include/opensm/osm_perfmgr_db.h
+++ b/include/opensm/osm_perfmgr_db.h
@@ -136,6 +136,7 @@ typedef struct db_port {
 typedef struct db_node {
 	cl_map_item_t map_item;	/* must be first */
 	uint64_t node_guid;
+	boolean_t active;       /* activly being monitored */
 	boolean_t esp0;
 	db_port_t *ports;
 	uint8_t num_ports;
@@ -161,6 +162,7 @@ perfmgr_db_err_t perfmgr_db_create_entry(perfmgr_db_t * db, uint64_t guid,
 					 boolean_t esp0, uint8_t num_ports,
 					 char *node_name);
 perfmgr_db_err_t perfmgr_db_delete_entry(perfmgr_db_t * db, uint64_t guid);
+perfmgr_db_err_t perfmgr_db_delete_inactive(perfmgr_db_t * db, unsigned *cnt);
 
 perfmgr_db_err_t perfmgr_db_add_err_reading(perfmgr_db_t * db, uint64_t guid,
 					    uint8_t port,
@@ -182,6 +184,9 @@ perfmgr_db_err_t perfmgr_db_get_prev_dc(perfmgr_db_t * db, uint64_t guid,
 perfmgr_db_err_t perfmgr_db_clear_prev_dc(perfmgr_db_t * db, uint64_t guid,
 					  uint8_t port);
 
+perfmgr_db_err_t perfmgr_db_mark_active(perfmgr_db_t *db, uint64_t guid,
+					boolean_t active);
+
 void perfmgr_db_clear_counters(perfmgr_db_t * db);
 perfmgr_db_err_t perfmgr_db_dump(perfmgr_db_t * db, char *file,
 				 perfmgr_db_dump_t dump_type);
diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index e68be25..79a40d1 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -239,7 +239,7 @@ static void help_update_desc(FILE *out, int detail)
 static void help_perfmgr(FILE * out, int detail)
 {
 	fprintf(out,
-		"perfmgr [enable|disable|clear_counters|dump_counters|print_counters|dump_redir|clear_redir|set_rm_nodes|clear_rm_nodes|sweep_time[seconds]]\n");
+		"perfmgr [enable|disable|clear_counters|dump_counters|print_counters|dump_redir|clear_redir|set_rm_nodes|clear_rm_nodes|clear_inactive|sweep_time[seconds]]\n");
 	if (detail) {
 		fprintf(out,
 			"perfmgr -- print the performance manager state\n");
@@ -260,6 +260,8 @@ static void help_perfmgr(FILE * out, int detail)
 		fprintf(out,
 			"   [[set|clear]_rm_nodes] -- enable/disable the removal of \"inactive\" nodes from the DB\n"
 			"                             Inactive nodes are those which no longer appear on the fabric\n");
+		fprintf(out,
+			"   [clear_inactive] -- Delete inactive nodes from the DB\n");
 	}
 }
 #endif				/* ENABLE_OSM_PERF_MGR */
@@ -1459,7 +1461,11 @@ static void perfmgr_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 				osm_perfmgr_dump_counters(&p_osm->perfmgr,
 							  PERFMGR_EVENT_DB_DUMP_HR);
 			}
+		} else if (strcmp(p_cmd, "clear_inactive") == 0) {
+			unsigned cnt = osm_perfmgr_delete_inactive(&p_osm->perfmgr);
+			fprintf(out, "Removed %u nodes from Database\n", cnt);
 		} else if (strcmp(p_cmd, "print_counters") == 0) {
+			char *port = NULL;
 			p_cmd = name_token(p_last);
 			if (p_cmd) {
 				osm_perfmgr_print_counters(&p_osm->perfmgr,
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index bec2381..4a0386a 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -148,6 +148,8 @@ static void remove_marked_nodes(osm_perfmgr_t * pm)
 
 		if (pm->rm_nodes)
 			perfmgr_db_delete_entry(pm->db, pm->remove_list->guid);
+		else
+			perfmgr_db_mark_active(pm->db, pm->remove_list->guid, FALSE);
 
 		if (pm->remove_list->name)
 			free(pm->remove_list->name);
@@ -524,6 +526,8 @@ static void perfmgr_query_counters(cl_map_item_t * p_map_item, void *context)
 		goto Exit;
 	}
 
+	perfmgr_db_mark_active(pm->db, node_guid, TRUE);
+
 	/* issue the query for each port */
 	for (port = mon_node->esp0 ? 0 : 1; port < num_ports; port++) {
 		ib_net16_t lid;
diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index b04be27..44994f1 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -105,6 +105,7 @@ static inline perfmgr_db_err_t bad_node_port(db_node_t * node, uint8_t port)
 		return PERFMGR_EVENT_DB_GUIDNOTFOUND;
 	if (port >= node->num_ports || (!node->esp0 && port == 0))
 		return PERFMGR_EVENT_DB_PORTNOTFOUND;
+
 	return PERFMGR_EVENT_DB_SUCCESS;
 }
 
@@ -139,6 +140,7 @@ static db_node_t *malloc_node(uint64_t guid, boolean_t esp0,
 		rc->ports[i].valid = FALSE;
 	}
 	snprintf(rc->node_name, sizeof(rc->node_name), "%s", name);
+	rc->active = FALSE;
 
 	return rc;
 
@@ -207,6 +209,62 @@ perfmgr_db_delete_entry(perfmgr_db_t * db, uint64_t guid)
 	return(PERFMGR_EVENT_DB_SUCCESS);
 }
 
+perfmgr_db_err_t
+perfmgr_db_delete_inactive(perfmgr_db_t * db, unsigned *cnt)
+{
+	perfmgr_db_err_t rc = PERFMGR_EVENT_DB_SUCCESS;
+	int i = 0;
+	int num = 0;
+	uint64_t * guid_list;
+	cl_map_item_t * p_map_item = cl_qmap_head(&db->pc_data);
+
+	if (p_map_item == cl_qmap_end(&db->pc_data)) {
+		rc = PERFMGR_EVENT_DB_SUCCESS;
+		goto Done;
+	}
+
+	while (p_map_item != cl_qmap_end(&db->pc_data)) {
+		db_node_t *n = (db_node_t *)p_map_item;
+		if (n->active == FALSE) {
+			guid_list = realloc(guid_list,
+					sizeof(*guid_list) * (num+1));
+			if (!guid_list) {
+				num = 0;
+				rc = PERFMGR_EVENT_DB_NOMEM;
+				goto Done;
+			}
+			guid_list[num] = n->node_guid;
+			num++;
+		}
+		p_map_item = cl_qmap_next(p_map_item);
+	}
+
+	for (i = 0 ; i < num; i++)
+		perfmgr_db_delete_entry(db, guid_list[i]);
+
+	free(guid_list);
+
+Done:
+	if (cnt)
+		*cnt = num;
+
+	return(rc);
+}
+
+perfmgr_db_err_t
+perfmgr_db_mark_active(perfmgr_db_t *db, uint64_t guid, boolean_t active)
+{
+	db_node_t *node = NULL;
+
+	cl_plock_excl_acquire(&db->lock);
+	node = get(db, guid);
+	if (node)
+		node->active = active;
+	cl_plock_release(&db->lock);
+	return (PERFMGR_EVENT_DB_SUCCESS);
+}
+
+
 /**********************************************************************
  * Dump a reading vs the previous reading to stdout
  **********************************************************************/
@@ -575,7 +633,7 @@ static void dump_node_mr(db_node_t * node, FILE * fp)
 {
 	int i = 0;
 
-	fprintf(fp, "\nName\tGUID\tPort\tLast Reset\t"
+	fprintf(fp, "\nName\tGUID\tActive\tPort\tLast Reset\t"
 		"%s\t%s\t"
 		"%s\t%s\t%s\t%s\t%s\t%s\t%s\t"
 		"%s\t%s\t%s\t%s\t%s\t%s\t%s\t"
@@ -609,13 +667,15 @@ static void dump_node_mr(db_node_t * node, FILE * fp)
 		since[strlen(since) - 1] = '\0';	/* remove \n */
 
 		fprintf(fp,
-			"%s\t0x%" PRIx64 "\t%d\t%s\t%" PRIu64 "\t%" PRIu64 "\t"
+			"%s\t0x%" PRIx64 "\t%s\t%d\t%s\t%" PRIu64 "\t%" PRIu64 "\t"
 			"%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t"
 			"%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t" "%" PRIu64
 			"\t%" PRIu64 "\t%" PRIu64 "\t" "%" PRIu64 "\t%" PRIu64
 			"\t%" PRIu64 "\t%" PRIu64 "\t" "%" PRIu64 "\t%" PRIu64
 			"\t%" PRIu64 "\t%" PRIu64 "\n", node->node_name,
-			node->node_guid, i, since,
+			node->node_guid,
+			node->active ? "TRUE" : "FALSE",
+			i, since,
 			node->ports[i].err_total.symbol_err_cnt,
 			node->ports[i].err_total.link_err_recover,
 			node->ports[i].err_total.link_downed,
@@ -655,7 +715,7 @@ static void dump_node_hr(db_node_t * node, FILE * fp)
 
 		since[strlen(since) - 1] = '\0';	/* remove \n */
 
-		fprintf(fp, "\"%s\" 0x%" PRIx64 " port %d (Since %s)\n"
+		fprintf(fp, "\"%s\" 0x%" PRIx64 " active %s port %d (Since %s)\n"
 			"     symbol_err_cnt       : %" PRIu64 "\n"
 			"     link_err_recover     : %" PRIu64 "\n"
 			"     link_downed          : %" PRIu64 "\n"
@@ -678,6 +738,7 @@ static void dump_node_hr(db_node_t * node, FILE * fp)
 			"     multicast_rcv_pkts   : %" PRIu64 "\n",
 			node->node_name,
 			node->node_guid,
+			node->active ? "TRUE":"FALSE",
 			i,
 			since,
 			node->ports[i].err_total.symbol_err_cnt,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
