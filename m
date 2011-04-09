From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 4/4] infiniband-diags: Make sure buffers are set to zero before
 calling xxx_query_via
Date: Sat, 09 Apr 2011 11:22:02 -0400
Message-ID: <4DA0799A.7080108@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aviad Yehezkel <aviadye-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


where xxx is smp and pma. This is a cosmetic change based on
IBA 1.2.1 vol 1 p.725 line 9:

When constructing a response MAD that contains all or part of
the corresponding request MAD, it is acceptable to include the
contents of reserved fields in the request MAD in the response
MAD without regard to their content. That is, such fields need not
be set to zero in the response MAD.

Signed-off-by: Aviad Yehezkel <aviadye-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibaddr.c b/src/ibaddr.c
index 6e17458..397ef77 100644
--- a/src/ibaddr.c
+++ b/src/ibaddr.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
+ * Copyright (c) 2011 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -52,8 +53,8 @@ static int ib_resolve_addr(ib_portid_t * portid, int portnum, int show_lid,
 			   int show_gid)
 {
 	char gid_str[INET6_ADDRSTRLEN];
-	uint8_t portinfo[64];
-	uint8_t nodeinfo[64];
+	uint8_t portinfo[IB_SMP_DATA_SIZE] = { 0 };
+	uint8_t nodeinfo[IB_SMP_DATA_SIZE] = { 0 };
 	uint64_t guid, prefix;
 	ibmad_gid_t gid;
 	int lmc;
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index 7574165..8cf755d 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -2,7 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
  * Copyright (c) 2007 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2008 Lawrence Livermore National Lab.  All rights reserved.
- * Copyright (c) 2010 Mellanox Technologies LTD.  All rights reserved.
+ * Copyright (c) 2010,2011 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -670,7 +670,7 @@ int main(int argc, char **argv)
 				guid_str);
 	} else if (!all && dr_path) {
 		ibnd_node_t *sw = NULL;
-		uint8_t ni[IB_SMP_DATA_SIZE];
+		uint8_t ni[IB_SMP_DATA_SIZE] = { 0 };
 
 		if (!smp_query_via(ni, &port_id, IB_ATTR_NODE_INFO, 0,
 				   ibd_timeout, ibmad_port))
diff --git a/src/ibportstate.c b/src/ibportstate.c
index 499dabc..d2ee58b 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
+ * Copyright (c) 2011 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -247,7 +248,7 @@ int main(int argc, char **argv)
 	int peerlocalportnum, peerlwe, peerlws, peerlwa, peerlse, peerlss,
 	    peerlsa;
 	int peerwidth, peerspeed;
-	uint8_t data[IB_SMP_DATA_SIZE];
+	uint8_t data[IB_SMP_DATA_SIZE] = { 0 };
 	ib_portid_t peerportid = { 0 };
 	int portnum = 0;
 	ib_portid_t selfportid = { 0 };
@@ -356,6 +357,7 @@ int main(int argc, char **argv)
 		printf("Initial %s PortInfo:\n", is_switch ? "Switch" : "CA");
 	else
 		printf("%s PortInfo:\n", is_switch ? "Switch" : "CA");
+	memset(data, 0, sizeof(data));
 	get_port_info(&portid, data, portnum);
 	show_port_info(&portid, data, portnum);
 
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 4317b67..295b398 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2007 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2008 Lawrence Livermore National Lab.  All rights reserved.
  * Copyright (c) 2009 HNR Consulting.  All rights reserved.
+ * Copyright (c) 2011 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -326,7 +327,7 @@ static int print_results(ib_portid_t * portid, char *node_name,
 static int query_cap_mask(ib_portid_t * portid, char *node_name, int portnum,
 			  uint16_t * cap_mask)
 {
-	uint8_t pc[1024];
+	uint8_t pc[1024] = { 0 };
 	uint16_t rc_cap_mask;
 
 	/* PerfMgt ClassPortInfo is a required attribute */
@@ -369,7 +370,7 @@ static int print_port(ib_portid_t * portid, uint16_t cap_mask, char *node_name,
 static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
 		       char *node_name, int port)
 {
-	uint8_t pc[1024];
+	uint8_t pc[1024] = { 0 };
 	/* bits defined in Table 228 PortCounters CounterSelect and
 	 * CounterSelect2
 	 */
@@ -391,9 +392,11 @@ static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
 		IBERROR("Failed to reset errors %s port %d", node_name, port);
 
 	if (details && clear_errors) {
+		memset(pc, 0, 1024);
 		performance_reset_via(pc, portid, port, 0xf, ibd_timeout,
 				      IB_GSI_PORT_XMIT_DISCARD_DETAILS,
 				      ibmad_port);
+		memset(pc, 0, 1024);
 		performance_reset_via(pc, portid, port, 0x3f, ibd_timeout,
 				      IB_GSI_PORT_RCV_ERROR_DETAILS,
 				      ibmad_port);
@@ -685,7 +688,7 @@ int main(int argc, char **argv)
 				node_guid_str);
 	} else if (dr_path) {
 		ibnd_node_t *node = ibnd_find_node_dr(fabric, dr_path);
-		uint8_t ni[IB_SMP_DATA_SIZE];
+		uint8_t ni[IB_SMP_DATA_SIZE] = { 0 };
 
 		if (!smp_query_via(ni, &portid, IB_ATTR_NODE_INFO, 0,
 				   ibd_timeout, ibmad_port)) {
diff --git a/src/ibroute.c b/src/ibroute.c
index b765c84..7339218 100644
--- a/src/ibroute.c
+++ b/src/ibroute.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
- * Copyright (c) 2009 Mellanox Technologies LTD.  All rights reserved.
+ * Copyright (c) 2009-2011 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -130,7 +130,7 @@ int dump_mlid(char *str, int strlen, unsigned mlid, unsigned nports,
 	return i * 2;
 }
 
-uint16_t mft[16][IB_MLIDS_IN_BLOCK];
+uint16_t mft[16][IB_MLIDS_IN_BLOCK] = { { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0 }, { 0}, { 0 }, { 0 } };
 
 char *dump_multicast_tables(ib_portid_t * portid, unsigned startlid,
 			    unsigned endlid)
@@ -303,9 +303,9 @@ int dump_lid(char *str, int strlen, int lid, int valid)
 
 char *dump_unicast_tables(ib_portid_t * portid, int startlid, int endlid)
 {
-	char lft[IB_SMP_DATA_SIZE];
-	char nd[IB_SMP_DATA_SIZE];
-	uint8_t sw[IB_SMP_DATA_SIZE];
+	char lft[IB_SMP_DATA_SIZE] = { 0 };
+	char nd[IB_SMP_DATA_SIZE] = { 0 };
+	uint8_t sw[IB_SMP_DATA_SIZE] = { 0 };
 	char str[200], *s;
 	uint64_t nodeguid;
 	int block, i, e, top;
diff --git a/src/ibsendtrap.c b/src/ibsendtrap.c
index 1b91595..618706b 100644
--- a/src/ibsendtrap.c
+++ b/src/ibsendtrap.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2008 Lawrence Livermore National Security
  * Copyright (c) 2008-2009 Voltaire Inc.  All rights reserved.
  * Copyright (c) 2009 HNR Consulting.  All rights reserved.
+ * Copyright (c) 2011 Mellanox Technologies LTD.  All rights reserved.
  *
  * Produced at Lawrence Livermore National Laboratory.
  * Written by Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>.
@@ -56,7 +57,7 @@ int error_port = 1;
 static uint16_t get_node_type(ib_portid_t * port)
 {
 	uint16_t node_type = IB_NODE_TYPE_CA;
-	uint8_t data[IB_SMP_DATA_SIZE];
+	uint8_t data[IB_SMP_DATA_SIZE] = { 0 };
 
 	if (smp_query_via(data, port, IB_ATTR_NODE_INFO, 0, 0, srcport))
 		node_type = (uint16_t) mad_get_field(data, 0, IB_NODE_TYPE_F);
@@ -65,7 +66,7 @@ static uint16_t get_node_type(ib_portid_t * port)
 
 static uint32_t get_cap_mask(ib_portid_t * port)
 {
-	uint8_t data[IB_SMP_DATA_SIZE];
+	uint8_t data[IB_SMP_DATA_SIZE] = { 0 };
 	uint32_t cap_mask = 0;
 
 	if (smp_query_via(data, port, IB_ATTR_PORT_INFO, 0, 0, srcport))
diff --git a/src/ibtracert.c b/src/ibtracert.c
index 9b563ab..c9f511b 100644
--- a/src/ibtracert.c
+++ b/src/ibtracert.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
  * Copyright (c) 2009 HNR Consulting.  All rights reserved.
- * Copyright (c) 2010 Mellanox Technologies LTD.  All rights reserved.
+ * Copyright (c) 2010,2011 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -119,9 +119,11 @@ static int get_node(Node * node, Port * port, ib_portid_t * portid)
 	void *pi = port->portinfo, *ni = node->nodeinfo, *nd = node->nodedesc;
 	char *s, *e;
 
+	memset(ni, 0, sizeof(node->nodeinfo));
 	if (!smp_query_via(ni, portid, IB_ATTR_NODE_INFO, 0, timeout, srcport))
 		return -1;
 
+	memset(nd, 0, sizeof(node->nodedesc));
 	if (!smp_query_via(nd, portid, IB_ATTR_NODE_DESC, 0, timeout, srcport))
 		return -1;
 
@@ -132,6 +134,7 @@ static int get_node(Node * node, Port * port, ib_portid_t * portid)
 			*s = ' ';
 	}
 
+	memset(pi, 0, sizeof(port->portinfo));
 	if (!smp_query_via(pi, portid, IB_ATTR_PORT_INFO, 0, timeout, srcport))
 		return -1;
 
@@ -154,6 +157,7 @@ static int switch_lookup(Switch * sw, ib_portid_t * portid, int lid)
 {
 	void *si = sw->switchinfo, *fdb = sw->fdb;
 
+	memset(si, 0, sizeof(sw->switchinfo));
 	if (!smp_query_via(si, portid, IB_ATTR_SWITCH_INFO, 0, timeout,
 			   srcport))
 		return -1;
@@ -164,6 +168,7 @@ static int switch_lookup(Switch * sw, ib_portid_t * portid, int lid)
 	if (lid >= sw->linearcap && lid > sw->linearFDBtop)
 		return -1;
 
+	memset(fdb, 0, sizeof(sw->fdb));
 	if (!smp_query_via(fdb, portid, IB_ATTR_LINEARFORWTBL, lid / 64,
 			   timeout, srcport))
 		return -1;
@@ -383,7 +388,7 @@ static int insert_node(Node * new)
 
 static int get_port(Port * port, int portnum, ib_portid_t * portid)
 {
-	char portinfo[64];
+	char portinfo[64] = { 0 };
 	void *pi = portinfo;
 
 	port->portnum = portnum;
@@ -446,6 +451,7 @@ static int switch_mclookup(Node * node, ib_portid_t * portid, int mlid,
 
 	memset(map, 0, 256);
 
+	memset(si, 0, sizeof(sw.switchinfo));
 	if (!smp_query_via(si, portid, IB_ATTR_SWITCH_INFO, 0, timeout,
 			   srcport))
 		return -1;
@@ -461,6 +467,7 @@ static int switch_mclookup(Node * node, ib_portid_t * portid, int mlid,
 	maxsets = (node->numports + 15) / 16;	/* round up */
 
 	for (set = 0; set < maxsets; set++) {
+		memset(mdb, 0, sizeof(mdb));
 		if (!smp_query_via(mdb, portid, IB_ATTR_MULTICASTFORWTBL,
 				   block | (set << 28), timeout, srcport))
 			return -1;
@@ -686,7 +693,7 @@ free_name:
 
 static int resolve_lid(ib_portid_t * portid, const void *srcport)
 {
-	uint8_t portinfo[64];
+	uint8_t portinfo[64] = { 0 };
 	uint16_t lid;
 
 	if (!smp_query_via(portinfo, portid, IB_ATTR_PORT_INFO, 0, 0, srcport))
diff --git a/src/perfquery.c b/src/perfquery.c
index 07a9226..ef63da2 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
  * Copyright (c) 2007 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2009 HNR Consulting.  All rights reserved.
+ * Copyright (c) 2011 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -288,6 +289,7 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
 	char buf[1024];
 
 	if (extended != 1) {
+		memset(pc, 0, sizeof(pc));
 		if (!pma_query_via(pc, portid, port, timeout,
 				   IB_GSI_PORT_COUNTERS, srcport))
 			IBERROR("perfquery");
@@ -312,6 +314,7 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
 			    ("PerfMgt ClassPortInfo 0x%x extended counters not indicated\n",
 			     cap_mask);
 
+		memset(pc, 0, sizeof(pc));
 		if (!pma_query_via(pc, portid, port, timeout,
 				   IB_GSI_PORT_COUNTERS_EXT, srcport))
 			IBERROR("perfextquery");
@@ -335,6 +338,7 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
 static void reset_counters(int extended, int timeout, int mask,
 			   ib_portid_t * portid, int port)
 {
+	memset(pc, 0, sizeof(pc));
 	if (extended != 1) {
 		if (!performance_reset_via(pc, portid, port, mask, timeout,
 					   IB_GSI_PORT_COUNTERS, srcport))
@@ -357,6 +361,7 @@ static void common_func(ib_portid_t * portid, int port_num, int mask,
 	char buf[1024];
 
 	if (query) {
+		memset(pc, 0, sizeof(pc));
 		if (!pma_query_via(pc, portid, port_num, ibd_timeout, attr,
 				   srcport))
 			IBERROR("cannot query %s", name);
@@ -367,6 +372,7 @@ static void common_func(ib_portid_t * portid, int port_num, int mask,
 		       portid2str(portid), port_num, buf);
 	}
 
+	memset(pc, 0, sizeof(pc));
 	if (reset && !performance_reset_via(pc, portid, port, mask, ibd_timeout,
 					    attr, srcport))
 		IBERROR("cannot reset %s", name);
@@ -404,6 +410,7 @@ void dump_portsamples_control(ib_portid_t * portid, int port)
 {
 	char buf[1024];
 
+	memset(pc, 0, sizeof(pc));
 	if (!pma_query_via(pc, portid, port, ibd_timeout,
 			   IB_GSI_PORT_SAMPLES_CONTROL, srcport))
 		IBERROR("sampctlquery");
@@ -463,7 +470,7 @@ int main(int argc, char **argv)
 	uint16_t cap_mask;
 	int all_ports_loop = 0;
 	int node_type, num_ports = 0;
-	uint8_t data[IB_SMP_DATA_SIZE];
+	uint8_t data[IB_SMP_DATA_SIZE] = { 0 };
 	int start_port = 1;
 	int enhancedport0;
 	int i;
@@ -522,6 +529,7 @@ int main(int argc, char **argv)
 	}
 
 	/* PerfMgt ClassPortInfo is a required attribute */
+	memset(pc, 0, sizeof(pc));
 	if (!pma_query_via(pc, &portid, port, ibd_timeout, CLASS_PORT_INFO,
 			   srcport))
 		IBERROR("classportinfo query");
diff --git a/src/sminfo.c b/src/sminfo.c
index ef13911..b02906f 100644
--- a/src/sminfo.c
+++ b/src/sminfo.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
+ * Copyright (c) 2011 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -46,7 +47,7 @@
 
 #include "ibdiag_common.h"
 
-static uint8_t sminfo[1024];
+static uint8_t sminfo[1024] = { 0 };
 
 struct ibmad_port *srcport;
 
diff --git a/src/smpquery.c b/src/smpquery.c
index a1559e8..a46bb18 100644
--- a/src/smpquery.c
+++ b/src/smpquery.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
+ * Copyright (c) 2011 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -84,8 +85,8 @@ static char *node_desc(ib_portid_t * dest, char **argv, int argc)
 {
 	int node_type, l;
 	uint64_t node_guid;
-	char nd[IB_SMP_DATA_SIZE];
-	uint8_t data[IB_SMP_DATA_SIZE];
+	char nd[IB_SMP_DATA_SIZE] = { 0 };
+	uint8_t data[IB_SMP_DATA_SIZE] = { 0 };
 	char dots[128];
 	char *nodename = NULL;
 
@@ -117,7 +118,7 @@ static char *node_desc(ib_portid_t * dest, char **argv, int argc)
 static char *node_info(ib_portid_t * dest, char **argv, int argc)
 {
 	char buf[2048];
-	char data[IB_SMP_DATA_SIZE];
+	char data[IB_SMP_DATA_SIZE] = { 0 };
 
 	if (!smp_query_via(data, dest, IB_ATTR_NODE_INFO, 0, 0, srcport))
 		return "node info query failed";
@@ -131,7 +132,7 @@ static char *node_info(ib_portid_t * dest, char **argv, int argc)
 static char *port_info(ib_portid_t * dest, char **argv, int argc)
 {
 	char buf[2048];
-	char data[IB_SMP_DATA_SIZE];
+	char data[IB_SMP_DATA_SIZE] = { 0 };
 	int portnum = 0;
 
 	if (argc > 0)
@@ -149,7 +150,7 @@ static char *port_info(ib_portid_t * dest, char **argv, int argc)
 static char *switch_info(ib_portid_t * dest, char **argv, int argc)
 {
 	char buf[2048];
-	char data[IB_SMP_DATA_SIZE];
+	char data[IB_SMP_DATA_SIZE] = { 0 };
 
 	if (!smp_query_via(data, dest, IB_ATTR_SWITCH_INFO, 0, 0, srcport))
 		return "switch info query failed";
@@ -162,7 +163,7 @@ static char *switch_info(ib_portid_t * dest, char **argv, int argc)
 
 static char *pkey_table(ib_portid_t * dest, char **argv, int argc)
 {
-	uint8_t data[IB_SMP_DATA_SIZE];
+	uint8_t data[IB_SMP_DATA_SIZE] = { 0 };
 	int i, j, k;
 	uint16_t *p;
 	unsigned mod;
@@ -215,7 +216,7 @@ static char *pkey_table(ib_portid_t * dest, char **argv, int argc)
 static char *sl2vl_dump_table_entry(ib_portid_t * dest, int in, int out)
 {
 	char buf[2048];
-	char data[IB_SMP_DATA_SIZE];
+	char data[IB_SMP_DATA_SIZE] = { 0 };
 	int portnum = (in << 8) | out;
 
 	if (!smp_query_via(data, dest, IB_ATTR_SLVL_TABLE, portnum, 0, srcport))
@@ -229,7 +230,7 @@ static char *sl2vl_dump_table_entry(ib_portid_t * dest, int in, int out)
 
 static char *sl2vl_table(ib_portid_t * dest, char **argv, int argc)
 {
-	uint8_t data[IB_SMP_DATA_SIZE];
+	uint8_t data[IB_SMP_DATA_SIZE] = { 0 };
 	int type, num_ports, portnum = 0;
 	int i;
 	char *ret;
@@ -266,7 +267,7 @@ static char *vlarb_dump_table_entry(ib_portid_t * dest, int portnum, int offset,
 				    unsigned cap)
 {
 	char buf[2048];
-	char data[IB_SMP_DATA_SIZE];
+	char data[IB_SMP_DATA_SIZE] = { 0 };
 
 	if (!smp_query_via(data, dest, IB_ATTR_VL_ARBITRATION,
 			   (offset << 16) | portnum, 0, srcport))
@@ -292,7 +293,7 @@ static char *vlarb_dump_table(ib_portid_t * dest, int portnum,
 
 static char *vlarb_table(ib_portid_t * dest, char **argv, int argc)
 {
-	uint8_t data[IB_SMP_DATA_SIZE];
+	uint8_t data[IB_SMP_DATA_SIZE] = { 0 };
 	int portnum = 0;
 	int type, enhsp0, lowcap, highcap;
 	char *ret = 0;
@@ -308,6 +309,7 @@ static char *vlarb_table(ib_portid_t * dest, char **argv, int argc)
 
 		mad_decode_field(data, IB_NODE_TYPE_F, &type);
 		if (type == IB_NODE_SWITCH) {
+			memset(data, 0, sizeof(data));
 			if (!smp_query_via(data, dest, IB_ATTR_SWITCH_INFO, 0,
 					   0, srcport))
 				return "switch info query failed";
@@ -318,6 +320,7 @@ static char *vlarb_table(ib_portid_t * dest, char **argv, int argc)
 				     portid2str(dest), 0);
 				return 0;
 			}
+			memset(data, 0, sizeof(data));
 		}
 	}
 
@@ -341,7 +344,7 @@ static char *vlarb_table(ib_portid_t * dest, char **argv, int argc)
 
 static char *guid_info(ib_portid_t * dest, char **argv, int argc)
 {
-	uint8_t data[IB_SMP_DATA_SIZE];
+	uint8_t data[IB_SMP_DATA_SIZE] = { 0 };
 	int i, j, k;
 	uint64_t *p;
 	unsigned mod;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
