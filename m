From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 03/10] opensm: perfmgr fix dump_counters
Date: Tue, 3 Jul 2012 16:53:00 -0700
Message-ID: <20120703165300.8bf50b6d.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Mark ports in the DB as invalid until data arrives.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_perfmgr_db.h |    1 +
 opensm/osm_perfmgr_db.c         |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/opensm/osm_perfmgr_db.h b/include/opensm/osm_perfmgr_db.h
index 42a47bd..4c7996d 100644
--- a/include/opensm/osm_perfmgr_db.h
+++ b/include/opensm/osm_perfmgr_db.h
@@ -126,6 +126,7 @@ typedef struct db_port {
 	perfmgr_db_data_cnt_reading_t dc_total;
 	perfmgr_db_data_cnt_reading_t dc_previous;
 	time_t last_reset;
+	boolean_t valid;
 } db_port_t;
 
 /** =========================================================================
diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index a472287..98bf59c 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -108,6 +108,11 @@ static inline perfmgr_db_err_t bad_node_port(db_node_t * node, uint8_t port)
 	return PERFMGR_EVENT_DB_SUCCESS;
 }
 
+static inline void mark_port_valid(db_node_t * node, uint8_t port)
+{
+	node->ports[port].valid = TRUE;
+}
+
 /** =========================================================================
  */
 static db_node_t *malloc_node(uint64_t guid, boolean_t esp0,
@@ -131,6 +136,7 @@ static db_node_t *malloc_node(uint64_t guid, boolean_t esp0,
 		rc->ports[i].last_reset = cur_time;
 		rc->ports[i].err_previous.time = cur_time;
 		rc->ports[i].dc_previous.time = cur_time;
+		rc->ports[i].valid = FALSE;
 	}
 	snprintf(rc->node_name, sizeof(rc->node_name), "%s", name);
 
@@ -271,6 +277,8 @@ perfmgr_db_add_err_reading(perfmgr_db_t * db, uint64_t guid, uint8_t port,
 	if ((rc = bad_node_port(node, port)) != PERFMGR_EVENT_DB_SUCCESS)
 		goto Exit;
 
+	mark_port_valid(node, port);
+
 	p_port = &(node->ports[port]);
 	previous = &(node->ports[port].err_previous);
 
@@ -413,6 +421,8 @@ perfmgr_db_add_dc_reading(perfmgr_db_t * db, uint64_t guid, uint8_t port,
 	if ((rc = bad_node_port(node, port)) != PERFMGR_EVENT_DB_SUCCESS)
 		goto Exit;
 
+	mark_port_valid(node, port);
+
 	p_port = &node->ports[port];
 	previous = &node->ports[port].dc_previous;
 
@@ -579,6 +589,10 @@ static void dump_node_mr(db_node_t * node, FILE * fp)
 		"multicast_rcv_pkts");
 	for (i = (node->esp0) ? 0 : 1; i < node->num_ports; i++) {
 		char *since = ctime(&node->ports[i].last_reset);
+
+		if (!node->ports[i].valid)
+			continue;
+
 		since[strlen(since) - 1] = '\0';	/* remove \n */
 
 		fprintf(fp,
@@ -622,6 +636,10 @@ static void dump_node_hr(db_node_t * node, FILE * fp)
 	fprintf(fp, "\n");
 	for (i = (node->esp0) ? 0 : 1; i < node->num_ports; i++) {
 		char *since = ctime(&node->ports[i].last_reset);
+
+		if (!node->ports[i].valid)
+			continue;
+
 		since[strlen(since) - 1] = '\0';	/* remove \n */
 
 		fprintf(fp, "\"%s\" 0x%" PRIx64 " port %d (Since %s)\n"
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
