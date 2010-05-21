From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH] opensm/qos.c: Revert port ranges for calls to
 sl2vl_update_table().
Date: Fri, 21 May 2010 14:18:35 -0600
Message-ID: <1274473115-3153-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Before commit 051a1dd5 (opensm/osm_qos.c: split switch external and end
ports setup), osm_qos_setup() would end up calling sl2vl_update_table()
for output ports 1-N, and inport ports 0-N.

Commit 051a1dd5 changed this around to be output ports 0-N, and input
ports 1-N, and an InfiniScale IV based fabric would log lots of errors
like these:

  log_rcv_cb_error: ERR 3111: Received MAD with error status = 0x1C
  SubnGetResp(SLtoVLMappingTable), attr_mod 0x2300, TID 0xad069
  Initial path: 0,1,1,4,13 Return path: 0,25,1,7,10

The attr_mod in every such message has 0x00 in the least significant
byte.

With the port ranges restored to their old values, the above log messages
stop.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_qos.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index 6bbbfa2..b8c3111 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -230,12 +230,12 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 					  &qcfg->sl2vl);
 	}
 
-	for (i = 1; i < num_ports; i++) {
+	for (i = 0; i < num_ports; i++) {
 		p = osm_node_get_physp_ptr(node, i);
 		force_update = p->need_update || sm->p_subn->need_update;
-		for (j = 0; j < num_ports; j++)
-			if (sl2vl_update_table(sm, p, i, i << 8 | j,
-					       force_update, &qcfg->sl2vl))
+		for (j = 1; j < num_ports; j++)
+			if (sl2vl_update_table(sm, p, i, j, force_update,
+					       &qcfg->sl2vl))
 				ret = -1;
 	}
 
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
