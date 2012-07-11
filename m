From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V2 10/10] opensm/console: add perfmgr "print_errors" (pe)
 console command.
Date: Wed, 11 Jul 2012 11:48:19 -0700
Message-ID: <20120711114819.38eaa1f1e91c3ddc8a094e4d@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Only print ports with error counters > 0

Changes since V1:
	My rebase got cross wired for the console help message.  Fix this.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_perfmgr.h    |    2 +-
 include/opensm/osm_perfmgr_db.h |    6 +-
 opensm/osm_console.c            |   14 +++++-
 opensm/osm_perfmgr.c            |   10 ++--
 opensm/osm_perfmgr_db.c         |  103 ++++++++++++++++++++++++---------------
 5 files changed, 86 insertions(+), 49 deletions(-)

diff --git a/include/opensm/osm_perfmgr.h b/include/opensm/osm_perfmgr.h
index 68cf7f3..97fead1 100644
--- a/include/opensm/osm_perfmgr.h
+++ b/include/opensm/osm_perfmgr.h
@@ -246,7 +246,7 @@ void osm_perfmgr_clear_counters(osm_perfmgr_t * p_perfmgr);
 void osm_perfmgr_dump_counters(osm_perfmgr_t * p_perfmgr,
 			       perfmgr_db_dump_t dump_type);
 void osm_perfmgr_print_counters(osm_perfmgr_t *pm, char *nodename, FILE *fp,
-				char *port);
+				char *port, int err_only);
 
 ib_api_status_t osm_perfmgr_bind(osm_perfmgr_t * p_perfmgr,
 				 ib_net64_t port_guid);
diff --git a/include/opensm/osm_perfmgr_db.h b/include/opensm/osm_perfmgr_db.h
index d6c8feb..6333692 100644
--- a/include/opensm/osm_perfmgr_db.h
+++ b/include/opensm/osm_perfmgr_db.h
@@ -190,11 +190,11 @@ perfmgr_db_err_t perfmgr_db_mark_active(perfmgr_db_t *db, uint64_t guid,
 void perfmgr_db_clear_counters(perfmgr_db_t * db);
 perfmgr_db_err_t perfmgr_db_dump(perfmgr_db_t * db, char *file,
 				 perfmgr_db_dump_t dump_type);
-void perfmgr_db_print_all(perfmgr_db_t * db, FILE *fp);
+void perfmgr_db_print_all(perfmgr_db_t * db, FILE *fp, int err_only);
 void perfmgr_db_print_by_name(perfmgr_db_t * db, char *nodename, FILE *fp,
-			      char *port);
+			      char *port, int err_only);
 void perfmgr_db_print_by_guid(perfmgr_db_t * db, uint64_t guid, FILE *fp,
-			      char *port);
+			      char *port, int err_only);
 
 /** =========================================================================
  * helper functions to fill in the various db objects from wire objects
diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index fd247c9..789092f 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -240,7 +240,7 @@ static void help_perfmgr(FILE * out, int detail)
 {
 	fprintf(out,
 		"perfmgr(pm) [enable|disable\n"
-		"             |clear_counters|dump_counters|print_counters(pc)\n"
+		"             |clear_counters|dump_counters|print_counters(pc)|print_errors(pe)\n"
 		"             |set_rm_nodes|clear_rm_nodes|clear_inactive\n"
 		"             |dump_redir|clear_redir|sweep_time[seconds]]\n");
 	if (detail) {
@@ -260,6 +260,11 @@ static void help_perfmgr(FILE * out, int detail)
 		fprintf(out,
 			"   [pc [<nodename|nodeguid>][:<port>]] -- same as print_counters\n");
 		fprintf(out,
+			"   [print_errors [<nodename|nodeguid>]] -- print only ports with errors\n"
+			"                                           Optionaly limit output by name or guid\n");
+		fprintf(out,
+			"   [pe [<nodename|nodeguid>]] -- same as print_errors\n");
+		fprintf(out,
 			"   [dump_redir [<nodename|nodeguid>]] -- dump the redirection table\n");
 		fprintf(out,
 			"   [clear_redir [<nodename|nodeguid>]] -- clear the redirection table\n");
@@ -1487,7 +1492,12 @@ static void perfmgr_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 				}
 			}
 			osm_perfmgr_print_counters(&p_osm->perfmgr, p_cmd,
-						   out, port);
+						   out, port, 0);
+		} else if (strcmp(p_cmd, "print_errors") == 0 ||
+			   strcmp(p_cmd, "pe") == 0) {
+			p_cmd = name_token(p_last);
+			osm_perfmgr_print_counters(&p_osm->perfmgr, p_cmd,
+						   out, NULL, 1);
 		} else if (strcmp(p_cmd, "dump_redir") == 0) {
 			p_cmd = name_token(p_last);
 			dump_redir(p_osm, p_cmd, out);
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 456c163..e47935a 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -1437,16 +1437,18 @@ void osm_perfmgr_dump_counters(osm_perfmgr_t * pm, perfmgr_db_dump_t dump_type)
  * Print the DB information to the fp specified
  *******************************************************************/
 void osm_perfmgr_print_counters(osm_perfmgr_t * pm, char *nodename, FILE * fp,
-				char *port)
+				char *port, int err_only)
 {
 	if (nodename) {
 		char *end = NULL;
 		uint64_t guid = strtoull(nodename, &end, 0);
 		if (nodename + strlen(nodename) != end)
-			perfmgr_db_print_by_name(pm->db, nodename, fp, port);
+			perfmgr_db_print_by_name(pm->db, nodename, fp, port,
+						 err_only);
 		else
-			perfmgr_db_print_by_guid(pm->db, guid, fp, port);
+			perfmgr_db_print_by_guid(pm->db, guid, fp, port,
+						 err_only);
 	} else
-		perfmgr_db_print_all(pm->db, fp);
+		perfmgr_db_print_all(pm->db, fp, err_only);
 }
 #endif				/* ENABLE_OSM_PERF_MGR */
diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index ea6fe19..9d79ec9 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -751,7 +751,7 @@ static void dump_hr_dc(FILE *fp, uint64_t val64, int data)
 /**********************************************************************
  * Output a human readable output of the port counters
  **********************************************************************/
-static void dump_node_hr(db_node_t * node, FILE * fp, char *port)
+static void dump_node_hr(db_node_t * node, FILE * fp, char *port, int err_only)
 {
 	int i = (node->esp0) ? 0 : 1;
 	int num_ports = node->num_ports;
@@ -766,7 +766,6 @@ static void dump_node_hr(db_node_t * node, FILE * fp, char *port)
 			fprintf(fp, "Warning: \"%s\" is not a valid port\n", port);
 		}
 	}
-	fprintf(fp, "\n");
 	for (/* set above */; i < num_ports; i++) {
 		char *since = ctime(&node->ports[i].last_reset);
 
@@ -774,37 +773,63 @@ static void dump_node_hr(db_node_t * node, FILE * fp, char *port)
 			continue;
 
 		since[strlen(since) - 1] = '\0';	/* remove \n */
+		perfmgr_db_err_reading_t *err = &node->ports[i].err_total;
+
+		if (err_only
+		    && err->symbol_err_cnt == 0
+		    && err->link_err_recover == 0
+		    && err->link_downed == 0
+		    && err->rcv_err == 0
+		    && err->rcv_rem_phys_err == 0
+		    && err->rcv_switch_relay_err == 0
+		    && err->xmit_discards == 0
+		    && err->xmit_constraint_err == 0
+		    && err->rcv_constraint_err == 0
+		    && err->link_integrity == 0
+		    && err->buffer_overrun == 0
+		    && err->vl15_dropped == 0)
+			continue;
 
-		fprintf(fp, "\"%s\" 0x%" PRIx64 " active %s port %d (Since %s)\n"
-			"     symbol_err_cnt       : %" PRIu64 "\n"
-			"     link_err_recover     : %" PRIu64 "\n"
-			"     link_downed          : %" PRIu64 "\n"
-			"     rcv_err              : %" PRIu64 "\n"
-			"     rcv_rem_phys_err     : %" PRIu64 "\n"
-			"     rcv_switch_relay_err : %" PRIu64 "\n"
-			"     xmit_discards        : %" PRIu64 "\n"
-			"     xmit_constraint_err  : %" PRIu64 "\n"
-			"     rcv_constraint_err   : %" PRIu64 "\n"
-			"     link_integrity_err   : %" PRIu64 "\n"
-			"     buf_overrun_err      : %" PRIu64 "\n"
-			"     vl15_dropped         : %" PRIu64 "\n",
-			node->node_name,
-			node->node_guid,
-			node->active ? "TRUE":"FALSE",
-			i,
-			since,
-			node->ports[i].err_total.symbol_err_cnt,
-			node->ports[i].err_total.link_err_recover,
-			node->ports[i].err_total.link_downed,
-			node->ports[i].err_total.rcv_err,
-			node->ports[i].err_total.rcv_rem_phys_err,
-			node->ports[i].err_total.rcv_switch_relay_err,
-			node->ports[i].err_total.xmit_discards,
-			node->ports[i].err_total.xmit_constraint_err,
-			node->ports[i].err_total.rcv_constraint_err,
-			node->ports[i].err_total.link_integrity,
-			node->ports[i].err_total.buffer_overrun,
-			node->ports[i].err_total.vl15_dropped);
+		fprintf(fp, "\"%s\" 0x%" PRIx64 " active %s port %d (Since %s)\n",
+			node->node_name, node->node_guid,
+			node->active ? "TRUE":"FALSE", i, since);
+
+		if (!err_only || err->symbol_err_cnt != 0)
+			fprintf(fp, "     symbol_err_cnt       : %" PRIu64 "\n",
+				err->symbol_err_cnt);
+		if (!err_only || err->link_err_recover != 0)
+			fprintf(fp, "     link_err_recover     : %" PRIu64 "\n",
+				err->link_err_recover);
+		if (!err_only || err->link_downed != 0)
+			fprintf(fp, "     link_downed          : %" PRIu64 "\n",
+				err->link_downed);
+		if (!err_only || err->rcv_err != 0)
+			fprintf(fp, "     rcv_err              : %" PRIu64 "\n",
+				err->rcv_err);
+		if (!err_only || err->rcv_rem_phys_err != 0)
+			fprintf(fp, "     rcv_rem_phys_err     : %" PRIu64 "\n",
+				err->rcv_rem_phys_err);
+		if (!err_only || err->rcv_switch_relay_err != 0)
+			fprintf(fp, "     rcv_switch_relay_err : %" PRIu64 "\n",
+				err->rcv_switch_relay_err);
+		if (!err_only || err->xmit_discards != 0)
+			fprintf(fp, "     xmit_discards        : %" PRIu64 "\n",
+				err->xmit_discards);
+		if (!err_only || err->xmit_constraint_err != 0)
+			fprintf(fp, "     xmit_constraint_err  : %" PRIu64 "\n",
+				err->xmit_constraint_err);
+		if (!err_only || err->rcv_constraint_err != 0)
+			fprintf(fp, "     rcv_constraint_err   : %" PRIu64 "\n",
+				err->rcv_constraint_err);
+		if (!err_only || err->link_integrity != 0)
+			fprintf(fp, "     link_integrity_err   : %" PRIu64 "\n",
+				err->link_integrity);
+		if (!err_only || err->buffer_overrun != 0)
+			fprintf(fp, "     buf_overrun_err      : %" PRIu64 "\n",
+				err->buffer_overrun);
+		if (!err_only || err->vl15_dropped != 0)
+			fprintf(fp, "     vl15_dropped         : %" PRIu64 "\n",
+				err->vl15_dropped);
 
 		fprintf(fp, "     xmit_data            : %" PRIu64,
 			node->ports[i].dc_total.xmit_data);
@@ -852,7 +877,7 @@ static void db_dump(cl_map_item_t * const p_map_item, void *context)
 		break;
 	case PERFMGR_EVENT_DB_DUMP_HR:
 	default:
-		dump_node_hr(node, fp, NULL);
+		dump_node_hr(node, fp, NULL, 0);
 		break;
 	}
 }
@@ -861,7 +886,7 @@ static void db_dump(cl_map_item_t * const p_map_item, void *context)
  * print all node data to fp
  **********************************************************************/
 void
-perfmgr_db_print_all(perfmgr_db_t * db, FILE *fp)
+perfmgr_db_print_all(perfmgr_db_t * db, FILE *fp, int err_only)
 {
 	cl_map_item_t *item;
 	db_node_t *node;
@@ -870,7 +895,7 @@ perfmgr_db_print_all(perfmgr_db_t * db, FILE *fp)
 	item = cl_qmap_head(&db->pc_data);
 	while (item != cl_qmap_end(&db->pc_data)) {
 		node = (db_node_t *)item;
-		dump_node_hr(node, fp, NULL);
+		dump_node_hr(node, fp, NULL, err_only);
 		item = cl_qmap_next(item);
 	}
 	cl_plock_release(&db->lock);
@@ -881,7 +906,7 @@ perfmgr_db_print_all(perfmgr_db_t * db, FILE *fp)
  **********************************************************************/
 void
 perfmgr_db_print_by_name(perfmgr_db_t * db, char *nodename, FILE *fp,
-			 char *port)
+			 char *port, int err_only)
 {
 	cl_map_item_t *item;
 	db_node_t *node;
@@ -893,7 +918,7 @@ perfmgr_db_print_by_name(perfmgr_db_t * db, char *nodename, FILE *fp,
 	while (item != cl_qmap_end(&db->pc_data)) {
 		node = (db_node_t *)item;
 		if (strcmp(node->node_name, nodename) == 0) {
-			dump_node_hr(node, fp, port);
+			dump_node_hr(node, fp, port, err_only);
 			goto done;
 		}
 		item = cl_qmap_next(item);
@@ -909,7 +934,7 @@ done:
  **********************************************************************/
 void
 perfmgr_db_print_by_guid(perfmgr_db_t * db, uint64_t nodeguid, FILE *fp,
-			 char *port)
+			 char *port, int err_only)
 {
 	cl_map_item_t *node;
 
@@ -917,7 +942,7 @@ perfmgr_db_print_by_guid(perfmgr_db_t * db, uint64_t nodeguid, FILE *fp,
 
 	node = cl_qmap_get(&db->pc_data, nodeguid);
 	if (node != cl_qmap_end(&db->pc_data))
-		dump_node_hr((db_node_t *)node, fp, port);
+		dump_node_hr((db_node_t *)node, fp, port, err_only);
 	else
 		fprintf(fp, "Node 0x%" PRIx64 " not found...\n", nodeguid);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
