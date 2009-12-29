From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_slvl_map_rcv.c: verify port number values
 received from network
Date: Tue, 29 Dec 2009 17:07:35 +0200
Message-ID: <20091229150735.GX26940@me>
References: <20091201194110.GA26753@comcast.net>
 <20091229150528.GV26940@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091229150528.GV26940@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Verify that port number values received from network are in range and
valid for access. Report error otherwise.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_slvl_map_rcv.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_slvl_map_rcv.c b/opensm/opensm/osm_slvl_map_rcv.c
index b35d867..6229db9 100644
--- a/opensm/opensm/osm_slvl_map_rcv.c
+++ b/opensm/opensm/osm_slvl_map_rcv.c
@@ -104,8 +104,17 @@ void osm_slvl_rcv_process(IN void *context, IN void *p_data)
 
 	/* in case of a non switch node the attr modifier should be ignored */
 	if (osm_node_get_type(p_node) == IB_NODE_TYPE_SWITCH) {
+		unsigned num_ports = osm_node_get_num_physp(p_node) - 1;
 		out_port_num = cl_ntoh32(p_smp->attr_mod) & 0xff;
 		in_port_num = (cl_ntoh32(p_smp->attr_mod) >> 8) & 0xff;
+		if (in_port_num > num_ports || out_port_num > num_ports) {
+			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2C07"
+				"Invalid attribute modifier 0x%x reveived in"
+				" response from switch 0x%" PRIx64 "\n",
+				cl_ntoh32(p_smp->attr_mod),
+				cl_ntoh64(node_guid));
+			goto Exit;
+		}
 		p_physp = osm_node_get_physp_ptr(p_node, out_port_num);
 	} else {
 		p_physp = p_port->p_physp;
-- 
1.6.6.rc4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
