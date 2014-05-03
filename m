From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/3 opensm] perfmgr: Add xmit_wait to event plugin error counters
 data structure
Date: Sat, 03 May 2014 01:40:47 -0400
Message-ID: <5364815F.6040605@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Susan Coulter (skc-YOWKrPYUwWM@public.gmane.org)" <skc-YOWKrPYUwWM@public.gmane.org>, Florent Parent <florent.parent-hUdP7zcY/u2zFPF/XzyFIQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date: Fri, 4 Apr 2014 20:07:04 -0400

NOTE: This changes the plugin interface.  However, OpenSM plugins must be
compiled for the specific version of OpenSM used.  So this should not be an
issue.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_event_plugin.h   |    1 +
 opensm/osm_perfmgr_db.c             |    5 ++---
 osmeventplugin/src/osmeventplugin.c |    4 +++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/opensm/osm_event_plugin.h b/include/opensm/osm_event_plugin.h
index ca5a719..db5ebca 100644
--- a/include/opensm/osm_event_plugin.h
+++ b/include/opensm/osm_event_plugin.h
@@ -126,6 +126,7 @@ typedef struct osm_epi_pe_event {
 	uint64_t link_integrity;
 	uint64_t buffer_overrun;
 	uint64_t vl15_dropped;
+	uint64_t xmit_wait;
 	time_t time_diff_s;
 } osm_epi_pe_event_t;
 
diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index 5b476bd..1b78942 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -359,7 +359,6 @@ perfmgr_db_add_err_reading(perfmgr_db_t * db, uint64_t guid, uint8_t port,
 	perfmgr_db_err_reading_t *previous = NULL;
 	perfmgr_db_err_t rc = PERFMGR_EVENT_DB_SUCCESS;
 	osm_epi_pe_event_t epi_pe_data;
-	uint64_t xmit_wait_diff;
 
 	cl_plock_excl_acquire(&db->lock);
 	node = get(db, guid);
@@ -415,9 +414,9 @@ perfmgr_db_add_err_reading(perfmgr_db_t * db, uint64_t guid, uint8_t port,
 	epi_pe_data.vl15_dropped =
 	    (reading->vl15_dropped - previous->vl15_dropped);
 	p_port->err_total.vl15_dropped += epi_pe_data.vl15_dropped;
-	xmit_wait_diff =
+	epi_pe_data.xmit_wait =
 	    (reading->xmit_wait - previous->xmit_wait);
-	p_port->err_total.xmit_wait += xmit_wait_diff;
+	p_port->err_total.xmit_wait += epi_pe_data.xmit_wait;
 
 	p_port->err_previous = *reading;
 
diff --git a/osmeventplugin/src/osmeventplugin.c b/osmeventplugin/src/osmeventplugin.c
index 0f3f9fb..23986db 100644
--- a/osmeventplugin/src/osmeventplugin.c
+++ b/osmeventplugin/src/osmeventplugin.c
@@ -105,7 +105,9 @@ static void handle_port_counter(_log_events_t * log, osm_epi_pe_event_t * pc)
 	    || pc->xmit_constraint_err > 0
 	    || pc->rcv_constraint_err > 0
 	    || pc->link_integrity > 0
-	    || pc->buffer_overrun > 0 || pc->vl15_dropped > 0) {
+	    || pc->buffer_overrun > 0
+	    || pc->vl15_dropped > 0
+	    || pc->xmit_wait > 0) {
 		fprintf(log->log_file,
 			"Port counter errors for node 0x%" PRIx64
 			" (%s) port %d\n", pc->port_id.node_guid,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
