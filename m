From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_dump.c: dump SL2VL tables
Date: Thu, 25 Mar 2010 17:56:14 +0200
Message-ID: <4BAB879E.30203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

Dumping SL2VL tables in ROUTING verbosity level when QoS is on.
This is needed for SL2VL tables analysis in general, and for
routing engines that are using IB VLs in particular, such as
torus-2QoS.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_dump.c |   61 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 60 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_dump.c b/opensm/opensm/osm_dump.c
index 86e9c00..2c21591 100644
--- a/opensm/opensm/osm_dump.c
+++ b/opensm/opensm/osm_dump.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -456,6 +456,60 @@ static void dump_topology_node(cl_map_item_t * item, FILE * file, void *cxt)
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
@@ -630,6 +684,11 @@ void osm_dump_all(osm_opensm_t * osm)
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
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
