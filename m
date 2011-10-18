From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2] opensm/osm_dump.c: dump SL2VL tables in debug verbosity
 level when QoS is on
Date: Tue, 18 Oct 2011 09:17:33 -0400
Message-ID: <4E9D7C6D.4030903@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_dump.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index 8aa8095..0108365 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -480,6 +480,60 @@ static void dump_topology_node(cl_map_item_t * item, FILE * file, void *cxt)
 	}
 }
 
+static void dump_sl2vl_tbl(cl_map_item_t * item, FILE * file, void *cxt)
+{
+	osm_port_t *p_port = (osm_port_t *) item;
+	osm_node_t *p_node = p_port->p_node;
+	uint32_t in_port, out_port,
+		 num_ports = p_node->node_info.num_ports;
+	ib_net16_t base_lid = osm_port_get_base_lid(p_port);
+	osm_physp_t *p_physp;
+	ib_slvl_table_t *p_tbl;
+	int i, n;
+	char buf[1024];
+	char * header_line =	"#in out : 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15";
+	char * separator_line = "#--------------------------------------------------------";
+
+	if (!num_ports)
+		return;
+
+	fprintf(file, "%s 0x%016" PRIx64 ", base LID %d, "
+		"\"%s\"\n%s\n%s\n",
+		ib_get_node_type_str(p_node->node_info.node_type),
+		cl_ntoh64(p_port->guid), cl_ntoh16(base_lid),
+		p_node->print_desc, header_line, separator_line);
+
+	if (p_node->node_info.node_type == IB_NODE_TYPE_SWITCH) {
+		for (out_port = 0; out_port <= num_ports; out_port++){
+			p_physp = osm_node_get_physp_ptr(p_node, out_port);
+
+			/* no need to print SL2VL table for port that is down */
+			if (!p_physp->p_remote_physp)
+				continue;
+
+			for (in_port = 0; in_port <= num_ports; in_port++) {
+				p_tbl = osm_physp_get_slvl_tbl(p_physp, in_port);
+				for (i = 0, n = 0; i < 16; i++)
+					n += sprintf(buf + n, " %-2d",
+						ib_slvl_table_get(p_tbl, i));
+				fprintf(file, "%-3d %-3d :%s\n",
+					in_port, out_port, buf);
+			}
+		}
+	} else {
+		p_physp = p_port->p_physp;
+		CL_ASSERT(p_physp->p_remote_physp);
+		p_tbl = osm_physp_get_slvl_tbl(p_physp, 0);
+		for (i = 0, n = 0; i < 16; i++)
+			n += sprintf(buf + n, " %-2d",
+					ib_slvl_table_get(p_tbl, i));
+		fprintf(file, "%-3d %-3d :%s\n",
+			0, p_physp->port_num, buf);
+	}
+
+	fprintf(file, "%s\n\n", separator_line);
+}
+
 static void print_node_report(cl_map_item_t * item, FILE * file, void *cxt)
 {
 	osm_node_t *p_node = (osm_node_t *) item;
@@ -663,6 +717,11 @@ void osm_dump_all(osm_opensm_t * osm)
 		osm_dump_qmap_to_file(osm, "opensm.mcfdbs",
 				      &osm->subn.sw_guid_tbl,
 				      dump_mcast_routes, osm);
+		/* SL2VL tables */
+		if (osm->subn.opt.qos)
+			osm_dump_qmap_to_file(osm, "opensm-sl2vl.dump",
+					      &osm->subn.port_guid_tbl,
+					      dump_sl2vl_tbl, osm);
 	}
 	osm_dump_qmap_to_file(osm, "opensm-subnet.lst",
 			      &osm->subn.node_guid_tbl, dump_topology_node,
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
