From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/1] opensm/osm_node_info_rcv.c: Fix multiple switch discovery during a sweep
Date: Wed,  5 Feb 2014 12:08:18 +0200
Message-ID: <1391594898-18129-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Because of the race between Get(SwitchInfo) and Get(NodeInfo) to the
same switch, SM will send additional Get(SwitchInfo) before it get a
first reply. In a sequence SM will send many redundant MADs and slow
down the discovery process significantly.
With this fix, when a switch doesn't respond to Get(SwitchInfo) once
during the sweep it will be dropped.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_node_info_rcv.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index c0233f7..b7c20e8 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -573,20 +573,9 @@ static void ni_rcv_process_existing_switch(IN osm_sm_t * sm,
 	/*
 	   If this switch has already been probed during this sweep,
 	   then don't bother reprobing it.
-	   There is one exception - if the node has been visited, but
-	   for some reason we don't have the switch object (this can happen
-	   if the SwitchInfo mad didn't reach the SM) then we want
-	   to retry to probe the switch.
 	 */
 	if (p_node->discovery_count == 1)
 		ni_rcv_process_switch(sm, p_node, p_madw);
-	else if (!p_node->sw) {
-		/* we don't have the SwitchInfo - retry to get it */
-		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
-			"Retry to get SwitchInfo on node GUID:0x%" PRIx64 "\n",
-			cl_ntoh64(osm_node_get_node_guid(p_node)));
-		ni_rcv_process_switch(sm, p_node, p_madw);
-	}
 
 	OSM_LOG_EXIT(sm->p_log);
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
