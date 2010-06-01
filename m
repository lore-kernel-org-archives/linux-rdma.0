From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH v2] opensm/qos.c: Revert port ranges for calls to
 sl2vl_update_table().
Date: Tue,  1 Jun 2010 08:56:52 -0600
Message-ID: <1275404212-5646-1-git-send-email-jaschut@sandia.gov>
References: <20100530235616.GK28549@me>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100530235616.GK28549@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Before commit 051a1dd5 (opensm/osm_qos.c: split switch external and end
ports setup), osm_qos_setup() would end up calling sl2vl_update_table()
for output ports 1-N, and inport ports 0-N.

Commit 051a1dd5 changed this around to be output ports 0-N, and input
ports 1-N, and an InfiniScale IV-based fabric would log lots of errors
like these:

  log_rcv_cb_error: ERR 3111: Received MAD with error status = 0x1C
  SubnGetResp(SLtoVLMappingTable), attr_mod 0x2300, TID 0xad069
  Initial path: 0,1,1,4,13 Return path: 0,25,1,7,10

The attr_mod in every such message has 0x00 in the least significant
byte, which specifies the output port.

With the port ranges restored to their old values, the above log messages
stop.  Hal Rosenstock pointed out that we should not be attempting
to program a base SP0 with SL2VL maps; see, e.g.,  IBA 1.2.1, section
14.2.5.8, page 844.  So, this patch is a full reversion for
switches supporting base SP0, but only a partial reversion for
switches supporting enhanced SP0.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_qos.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index f814ea8..cce59ee 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -230,10 +230,11 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
 					  &qcfg->sl2vl);
 	}
 
-	for (i = 1; i < num_ports; i++) {
+	for (i = 0; i < num_ports; i++) {
 		p = osm_node_get_physp_ptr(node, i);
 		force_update = p->need_update || sm->p_subn->need_update;
-		for (j = 0; j < num_ports; j++)
+		j = ib_switch_info_is_enhanced_port0(&node->sw->switch_info) ? 0 : 1;
+		for (; j < num_ports; j++)
 			if (sl2vl_update_table(sm, p, i, i << 8 | j,
 					       force_update, &qcfg->sl2vl))
 				ret = -1;
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
