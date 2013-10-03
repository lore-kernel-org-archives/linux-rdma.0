From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: [PATCH 2/5] OpenSM: dfsssp - send multicast forwarding tables to switches
Date: Fri,  4 Oct 2013 00:03:06 +0900
Message-ID: <1380812586-1583-2-git-send-email-domke.j.aa@m.titech.ac.jp>
References: <1380812586-1583-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1380812586-1583-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Issue: root switch of the mcast spanning tree was ignored.
When a port of the root switch is part of the mcast group, then
it won't be processed and non of its ports will be part of
the resulting mcast forwarding table.

Fix: remove the test for used_link==NULL, because all switches in
adj_list should have a used_link set by the prior dijkstra step
(except the root switch) => test not needed and root switch will
be included in mcast update.

Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
---
 opensm/osm_ucast_dfsssp.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index 9c34795..219f8bb 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -1607,13 +1607,11 @@ static int update_mcft(osm_sm_t * p_sm, vertex_t * adj_list,
 			" (%s) for MLID 0x%X\n", cl_ntoh64(adj_list[i].guid),
 			p_sw->p_node->print_desc, mlid_ho);
 
-		/* if a) no route goes thru this switch  or
-		      b) the switch does not support mcast  or
-		      c) no ports of this switch are part or the mcast group
+		/* if a) the switch does not support mcast  or
+		      b) no ports of this switch are part or the mcast group
 		   then cycle
 		 */
-		if (!(adj_list[i].used_link) ||
-		    osm_switch_supports_mcast(p_sw) == FALSE ||
+		if (osm_switch_supports_mcast(p_sw) == FALSE ||
 		    (p_sw->num_of_mcm == 0 && !(p_sw->is_mc_member)))
 			continue;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
