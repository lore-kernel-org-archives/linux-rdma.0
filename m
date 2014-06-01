From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_sa_path_record.c: Fix misleading error messages
 during sweep
Date: Sun, 01 Jun 2014 08:41:36 -0400
Message-ID: <538B1F80.7010905@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

PathQuery is received during heavy-sweep caused by just rebooted node.
The PathQuery is received for the new node during discovery stage
when no LID is still assigned to the node.

Fix: change from using OSM_LOG_ERROR to OSM_LOG_DEBUG for ERR 1F20 and 1F21

Signed-off-by: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_path_record.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index aaf2f2f..a915636 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -1113,7 +1113,7 @@ static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 					  &src_lid_min_ho, &src_lid_max_ho);
 
 	if (src_lid_min_ho == 0) {
-		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F20:"
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"Obtained source LID of 0. No such LID possible "
 			"(%s port %d)\n",
 			p_src_alias_guid->p_base_port->p_node->print_desc,
@@ -1122,7 +1122,7 @@ static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 	}
 
 	if (dest_lid_min_ho == 0) {
-		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F21:"
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"Obtained destination LID of 0. No such LID possible "
 			"(%s port %d)\n",
 			p_dest_alias_guid->p_base_port->p_node->print_desc,
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
