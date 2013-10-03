From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: [PATCH 1/5] OpenSM: dfsssp - send multicast forwarding tables to switches
Date: Fri,  4 Oct 2013 00:03:05 +0900
Message-ID: <1380812586-1583-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Issue: dfsssp calculates mcast forwarding tables but doesn't
distribute them to the switches, because is_mc_member/num_of_mcm
for each switch was reset to 0 in osm_mcast_mgr.c.
dfsssp relies on this data to figure out with switch is involved
in the mcast group.

Fix: recalculate is_mc_member/num_of_mcm similar to the code
of create_mgrp_switch_map(...) in osm_mcast_mgr.c right before
the update_mcft function and reset to 0 afterwards.

Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
---
 opensm/osm_ucast_dfsssp.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index ef7de59..9c34795 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -1544,6 +1544,43 @@ static int update_lft(osm_ucast_mgr_t * p_mgr, vertex_t * adj_list,
 	return 0;
 }
 
+/* the function updates the multicast group membership information
+   similar to create_mgrp_switch_map (osm_mcast_mgr.c)
+   => with it we can identify if a switch needs to be processed
+   or not in update_mcft
+*/
+static void update_mgrp_membership(cl_qlist_t * port_list)
+{
+	osm_mcast_work_obj_t *wobj = NULL;
+	osm_port_t *port = NULL;
+	osm_switch_t *sw = NULL;
+	cl_list_item_t *i = NULL;
+
+	for (i = cl_qlist_head(port_list); i != cl_qlist_end(port_list);
+	     i = cl_qlist_next(i)) {
+		wobj = cl_item_obj(i, wobj, list_item);
+		port = wobj->p_port;
+		if (port->p_node->sw) {
+			sw = port->p_node->sw;
+			sw->is_mc_member = 1;
+		} else {
+			sw = port->p_physp->p_remote_physp->p_node->sw;
+			sw->num_of_mcm++;
+		}
+	}
+}
+
+/* reset is_mc_member and num_of_mcm for future computations */
+static void reset_mgrp_membership(vertex_t * adj_list, uint32_t adj_list_size)
+{
+	uint32_t i = 0;
+
+	for (i = 1; i < adj_list_size; i++) {
+		adj_list[i].sw->is_mc_member = 0;
+		adj_list[i].sw->num_of_mcm = 0;
+	}
+}
+
 /* update the multicast forwarding tables of all switches with the informations
    from the previous dijsktra step for the current mlid
 */
@@ -2386,6 +2423,11 @@ static ib_api_status_t dfsssp_do_mcast_routing(void * context,
 		goto Exit;
 	}
 
+	/* set mcast group membership again for update_mcft
+	   (unfortunately: osm_mcast_mgr_find_root_switch resets it)
+	 */
+	update_mgrp_membership(&mcastgrp_port_list);
+
 	/* update the mcast forwarding tables of the switches */
 	err = update_mcft(sm, adj_list, adj_list_size, mbox->mlid,
 			  &mcastgrp_port_map, root_sw);
@@ -2398,6 +2440,7 @@ static ib_api_status_t dfsssp_do_mcast_routing(void * context,
 	}
 
 Exit:
+	reset_mgrp_membership(adj_list, adj_list_size);
 	osm_mcast_drop_port_list(&mcastgrp_port_list);
 	OSM_LOG_EXIT(sm->p_log);
 	return status;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
