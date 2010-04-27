From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: libibnetdisc: Add grouping for Voltaire's ISR4700 switch
Date: Tue, 27 Apr 2010 14:35:29 +0200
Message-ID: <20100427143529.75d64f9f@frecb007965>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yair Goldel <yairg-smomgflXvOZWk0Htik3J/w@public.gmane.org>, OF EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  The ISR4700 features 3 kind of boards:
    
  - sLB-4018 line board with a single 36 port asic
  - sFB-4700 fabric board with a single 36 port asic
  - sFB-4700X2 double density fabric board with 2 36 port asics
    
  The double density fabric board (sFB-4700X2) features external 12X
connectors that are only an aggregation of 3 4X ports, therefore
ext_portnum is set to match the number printed on the faceplate.
    
Signed-off-by: Sebastien Dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>

diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
index 136282c..2735224 100644
--- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -121,7 +121,7 @@ typedef struct ibnd_chassis {
 	ibnd_node_t *nodes;
 
 	/* specific to voltaire type nodes */
-#define SPINES_MAX_NUM 12
+#define SPINES_MAX_NUM 18
 #define LINES_MAX_NUM 36
 	ibnd_node_t *spinenode[SPINES_MAX_NUM + 1];
 	ibnd_node_t *linenode[LINES_MAX_NUM + 1];
diff --git a/infiniband-diags/libibnetdisc/src/chassis.c b/infiniband-diags/libibnetdisc/src/chassis.c
index 80e034b..cd2113f 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.c
+++ b/infiniband-diags/libibnetdisc/src/chassis.c
@@ -49,8 +49,8 @@
 #include "internal.h"
 #include "chassis.h"
 
-static char *ChassisTypeStr[5] =
-    { "", "ISR9288", "ISR9096", "ISR2012", "ISR2004" };
+static char *ChassisTypeStr[6] =
+{ "", "ISR9288", "ISR9096", "ISR2012", "ISR2004", "ISR4700" };
 static char *ChassisSlotTypeStr[4] = { "", "Line", "Spine", "SRBD" };
 
 typedef struct chassis_scan {
@@ -71,7 +71,7 @@ char *ibnd_get_chassis_type(ibnd_node_t * node)
 		return NULL;
 	if (!node->chassis)
 		return NULL;
-	if (node->ch_type == UNRESOLVED_CT || node->ch_type > ISR2004_CT)
+	if (node->ch_type == UNRESOLVED_CT || node->ch_type > ISR4700_CT)
 		return NULL;
 	return ChassisTypeStr[node->ch_type];
 }
@@ -273,10 +273,23 @@ static int is_spine_2012(ibnd_node_t * n)
 	return (devid == VTR_DEVID_SFB2012);
 }
 
+static int is_spine_4700(ibnd_node_t * n)
+{
+	uint32_t devid = mad_get_field(n->info, 0, IB_NODE_DEVID_F);
+	return (devid == VTR_DEVID_SFB4700);
+}
+
+static int is_spine_4700x2(ibnd_node_t * n)
+{
+	uint32_t devid = mad_get_field(n->info, 0, IB_NODE_DEVID_F);
+	return (devid == VTR_DEVID_SFB4700X2);
+}
+
 static int is_spine(ibnd_node_t * n)
 {
 	return (is_spine_9096(n) || is_spine_9288(n) ||
-		is_spine_2004(n) || is_spine_2012(n));
+		is_spine_2004(n) || is_spine_2012(n) ||
+		is_spine_4700(n) || is_spine_4700x2(n));
 }
 
 static int is_line_24(ibnd_node_t * n)
@@ -298,9 +311,16 @@ static int is_line_2024(ibnd_node_t * n)
 	return (devid == VTR_DEVID_SLB2024);
 }
 
+static int is_line_4700(ibnd_node_t * n)
+{
+	uint32_t devid = mad_get_field(n->info, 0, IB_NODE_DEVID_F);
+	return (devid == VTR_DEVID_SLB4018);
+}
+
 static int is_line(ibnd_node_t * n)
 {
-	return (is_line_24(n) || is_line_8(n) || is_line_2024(n));
+	return (is_line_24(n) || is_line_8(n) ||
+		is_line_2024(n) || is_line_4700(n));
 }
 
 int is_chassis_switch(ibnd_node_t * n)
@@ -309,52 +329,100 @@ int is_chassis_switch(ibnd_node_t * n)
 }
 
 /* these structs help find Line (Anafa) slot number while using spine portnum */
-char line_slot_2_sfb4[25] = {
-	0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4,
-	4
+char line_slot_2_sfb4[37] = {
+	0,
+	1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3,
+	4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+};
+char anafa_line_slot_2_sfb4[37] = {
+	0,
+	1, 1, 1, 2, 2, 2, 1, 1, 1, 2, 2, 2, 1, 1, 1, 2, 2, 2,
+	1, 1, 1, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 };
 
-char anafa_line_slot_2_sfb4[25] = {
-	0, 1, 1, 1, 2, 2, 2, 1, 1, 1, 2, 2, 2, 1, 1, 1, 2, 2, 2, 1, 1, 1, 2, 2,
-	2
+char line_slot_2_sfb12[37] = {
+	0,
+	1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9,
+	10, 10, 11, 11, 12, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+};
+char anafa_line_slot_2_sfb12[37] = {
+	0,
+	1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2,
+	1, 2, 1, 2, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 };
 
-char line_slot_2_sfb12[25] = {
-	0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11,
-	12, 12
+/* LB slot = table[spine port] */
+char line_slot_2_sfb18[37] = {
+	0,
+	1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9,
+	10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 18};
+/* LB asic num = table[spine port] */
+char anafa_line_slot_2_sfb18[37] = {
+	0,
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
 };
 
-char anafa_line_slot_2_sfb12[25] = {
-	0, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1,
-	2
+/* LB slot = table[spine port] */
+char line_slot_2_sfb18x2[37] = {
+	0,
+	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,
+	0, 0, 0, 0, 0, 0, 0, 0, 0,  0,  0,  0,  0,  0,  0,  0,  0,  0};
+/* LB asic num = table[spine port] */
+char anafa_line_slot_2_sfb18x2[37] = {
+	0,
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 };
 
 /* IPR FCR modules connectivity while using sFB4 port as reference */
-char ipr_slot_2_sfb4_port[25] = {
-	0, 3, 2, 1, 3, 2, 1, 3, 2, 1, 3, 2, 1, 3, 2, 1, 3, 2, 1, 3, 2, 1, 3, 2,
-	1
+char ipr_slot_2_sfb4_port[37] = {
+	0,
+	3, 2, 1, 3, 2, 1, 3, 2, 1, 3, 2, 1, 3, 2, 1, 3, 2, 1,
+	3, 2, 1, 3, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 };
 
 /* these structs help find Spine (Anafa) slot number while using spine portnum */
-char spine12_slot_2_slb[25] = {
-	0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	0
+char spine12_slot_2_slb[37] = {
+	0,
+	1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 };
-
-char anafa_spine12_slot_2_slb[25] = {
-	0, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	0
+char anafa_spine12_slot_2_slb[37] = {
+	0,
+	1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 };
 
-char spine4_slot_2_slb[25] = {
-	0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	0
+char spine4_slot_2_slb[37] = {
+	0,
+	1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+};
+char anafa_spine4_slot_2_slb[37] = {
+	0,
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 };
 
-char anafa_spine4_slot_2_slb[25] = {
-	0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-	0
+/* FB slot = table[line port] */
+char spine18_slot_2_slb[37] = {
+	0,
+	1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+};
+/* FB asic = table[line port] */
+char anafa_spine18_slot_2_slb[37] = {
+	0,
+	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 };
+char anafa_spine18x2_slot_2_slb[37] = {
+	0,
+	2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+};
+
 
 /*	reference                     { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 }; */
 
@@ -377,6 +445,14 @@ static int get_sfb_slot(ibnd_node_t * n, ibnd_port_t * lineport)
 		n->ch_type = ISR2004_CT;
 		n->ch_slotnum = spine4_slot_2_slb[lineport->portnum];
 		n->ch_anafanum = anafa_spine4_slot_2_slb[lineport->portnum];
+	} else if (is_spine_4700(n)) {
+		n->ch_type = ISR4700_CT;
+		n->ch_slotnum = spine18_slot_2_slb[lineport->portnum];
+		n->ch_anafanum = anafa_spine18_slot_2_slb[lineport->portnum];
+	} else if (is_spine_4700x2(n)) {
+		n->ch_type = ISR4700_CT;
+		n->ch_slotnum = spine18_slot_2_slb[lineport->portnum];
+		n->ch_anafanum = anafa_spine18x2_slot_2_slb[lineport->portnum];
 	} else {
 		IBND_ERROR("Unexpected node found: guid 0x%016" PRIx64 "\n",
 			   n->guid);
@@ -445,6 +521,14 @@ static int get_slb_slot(ibnd_node_t * n, ibnd_port_t * spineport)
 		n->ch_type = ISR2004_CT;
 		n->ch_slotnum = line_slot_2_sfb4[spineport->portnum];
 		n->ch_anafanum = anafa_line_slot_2_sfb4[spineport->portnum];
+	} else if (is_spine_4700(spineport->node)) {
+		n->ch_type = ISR4700_CT;
+		n->ch_slotnum = line_slot_2_sfb18[spineport->portnum];
+		n->ch_anafanum = anafa_line_slot_2_sfb18[spineport->portnum];
+	} else if (is_spine_4700x2(spineport->node)) {
+		n->ch_type = ISR4700_CT;
+		n->ch_slotnum = line_slot_2_sfb18x2[spineport->portnum];
+		n->ch_anafanum = anafa_line_slot_2_sfb18x2[spineport->portnum];
 	} else {
 		IBND_ERROR("Unexpected node found: guid 0x%016" PRIx64 "\n",
 			   spineport->node->guid);
@@ -479,11 +563,22 @@ static int fill_voltaire_chassis_record(ibnd_node_t * node)
 			port = node->ports[p];
 			if (port && is_spine(port->remoteport->node))
 				get_router_slot(node, port->remoteport);
-	} else if (is_spine(node))
+		}
+	else if (is_spine(node)) {
+		int is_4700x2 = is_spine_4700x2(node);
+
 		for (p = 1; p <= node->numports; p++) {
 			port = node->ports[p];
 			if (!port || !port->remoteport)
 				continue;
+
+			/*
+			 * Skip ISR4700 double density fabric boards ports 19-36
+			 * as they are chassis external ports
+			 */
+			if (is_4700x2 && (port->portnum > 18))
+				continue;
+
 			remnode = port->remoteport->node;
 			if (remnode->type != IB_NODE_SWITCH) {
 				if (!remnode->ch_found)
@@ -498,16 +593,24 @@ static int fill_voltaire_chassis_record(ibnd_node_t * node)
 			/* we could break here, but need to find if more routers connected */
 		}
 
-	else if (is_line(node))
+	} else if (is_line(node)) {
+		int is_4700_line = is_line_4700(node);
+
 		for (p = 1; p <= node->numports; p++) {
 			port = node->ports[p];
-			if (!port || port->portnum > 12 || !port->remoteport)
+			if (!port || !port->remoteport)
+				continue;
+
+			if ((is_4700_line && (port->portnum > 18)) ||
+			    (!is_4700_line && (port->portnum > 12)))
 				continue;
+
 			/* we assume here that remoteport belongs to spine */
 			if (get_slb_slot(node, port->remoteport))
 				return -1;
 			break;
 		}
+	}
 
 	/* for each port of this node, map external ports */
 	for (p = 1; p <= node->numports; p++) {
@@ -522,9 +625,15 @@ static int fill_voltaire_chassis_record(ibnd_node_t * node)
 
 static int get_line_index(ibnd_node_t * node)
 {
-	int retval = 3 * (node->ch_slotnum - 1) + node->ch_anafanum;
+	int retval;
+
+	if (is_line_4700(node))
+		retval = node->ch_slotnum;
+	else
+		retval = 3 * (node->ch_slotnum - 1) + node->ch_anafanum;
 
 	if (retval > LINES_MAX_NUM || retval < 1) {
+		printf("%s: retval = %d\n", __FUNCTION__, retval);
 		IBND_ERROR("Internal error\n");
 		return -1;
 	}
@@ -537,6 +646,8 @@ static int get_spine_index(ibnd_node_t * node)
 
 	if (is_spine_9288(node) || is_spine_2012(node))
 		retval = 3 * (node->ch_slotnum - 1) + node->ch_anafanum;
+	else if (is_spine_4700(node) || is_spine_4700x2(node))
+		retval = 2 * (node->ch_slotnum - 1) + node->ch_anafanum;
 	else
 		retval = node->ch_slotnum;
 
@@ -584,14 +695,23 @@ static int pass_on_lines_catch_spines(ibnd_chassis_t * chassis)
 	int i, p;
 
 	for (i = 1; i <= LINES_MAX_NUM; i++) {
+		int is_4700_line;
+
 		node = chassis->linenode[i];
 
 		if (!(node && is_line(node)))
 			continue;	/* empty slot or router */
 
+		is_4700_line = is_line_4700(node);
+
 		for (p = 1; p <= node->numports; p++) {
+
 			port = node->ports[p];
-			if (!port || port->portnum > 12 || !port->remoteport)
+			if (!port || !port->remoteport)
+				continue;
+
+			if ((is_4700_line && (port->portnum > 18)) ||
+			    (!is_4700_line && (port->portnum > 12)))
 				continue;
 
 			remnode = port->remoteport->node;
@@ -612,17 +732,31 @@ static int pass_on_spines_catch_lines(ibnd_chassis_t * chassis)
 	int i, p;
 
 	for (i = 1; i <= SPINES_MAX_NUM; i++) {
+		int is_4700x2;
+
 		node = chassis->spinenode[i];
 		if (!node)
 			continue;	/* empty slot */
+
+		is_4700x2 = is_spine_4700x2(node);
+
 		for (p = 1; p <= node->numports; p++) {
 			port = node->ports[p];
 			if (!port || !port->remoteport)
 				continue;
+
+			/*
+			 * ISR4700 double density fabric board ports 19-36 are
+			 * chassis external ports, so skip them
+			 */
+			if (is_4700x2 && (port->portnum > 18))
+				continue;
+
 			remnode = port->remoteport->node;
 
 			if (!remnode->ch_found)
 				continue;	/* some error - line/router not initialized ? FIXME */
+
 			if (insert_line_router(remnode, chassis))
 				return -1;
 		}
@@ -667,9 +801,18 @@ static int build_chassis(ibnd_node_t * node, ibnd_chassis_t * chassis)
 
 	/* loop: pass on all ports of node */
 	for (p = 1; p <= node->numports; p++) {
+
 		port = node->ports[p];
 		if (!port || !port->remoteport)
 			continue;
+
+		/*
+		 * ISR4700 double density fabric board ports 19-36 are
+		 * chassis external ports, so skip them
+		 */
+		if (is_spine_4700x2(node) && (port->portnum > 18))
+			continue;
+
 		remnode = port->remoteport->node;
 
 		if (!remnode->ch_found)
@@ -738,6 +881,21 @@ ext port | 1 2 3 4 5 6 7 8 9 10 11 12
 A2 int port| 13 14 15 16 17 18 19 20 21 22 23 24
 ---------------------------------------------------
 
+Module : sLB-4018
+
+int port | 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36
+ext port |  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18
+---------------------------------------------------
+
+Module : sFB-4700X2
+
+  12X port -> 3 x 4X ports:
+
+A1 int port | 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36
+   ext port |  7  7  7  8  8  8  9  9  9 10 10 10 11 11 11 12 12 12
+A2 int port | 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36
+   ext port |  1  1  1  2  2  2  3  3  3  4  4  4  5  5  5  6  6  6
+
 */
 
 int int2ext_map_slb24[2][25] = {
@@ -761,6 +919,21 @@ int int2ext_map_slb2024[2][25] = {
 	 11, 12}
 };
 
+int int2ext_map_slb4018[37] = {
+	0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18
+};
+
+int int2ext_map_sfb4700x2[2][37] = {
+	{0,
+	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 10, 11, 11, 11, 12, 12, 12},
+	{0,
+	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6}
+};
+
 /*	reference			{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 }; */
 
 /* map internal ports to external ports if appropriate */
@@ -769,12 +942,22 @@ static void voltaire_portmap(ibnd_port_t * port)
 	int portnum = port->portnum;
 	int chipnum = 0;
 	ibnd_node_t *node = port->node;
+	int is_4700_line = is_line_4700(node);
+	int is_4700x2_spine = is_spine_4700x2(node);
 
-	if (!node->ch_found || !is_line(node) || (portnum < 13 || portnum > 24)) {
+	if (!node->ch_found || (!is_line(node) && !is_4700x2_spine)) {
 		port->ext_portnum = 0;
 		return;
 	}
 
+	if (((is_4700_line || is_4700x2_spine) &&
+	     (portnum < 19 || portnum > 36)) ||
+	    ((!is_4700_line && !is_4700x2_spine) &&
+	     (portnum < 13 || portnum > 24))) {
+			port->ext_portnum = 0;
+		return;
+	}
+
 	if (port->node->ch_anafanum < 1 || port->node->ch_anafanum > 2) {
 		port->ext_portnum = 0;
 		return;
@@ -786,6 +969,12 @@ static void voltaire_portmap(ibnd_port_t * port)
 		port->ext_portnum = int2ext_map_slb24[chipnum][portnum];
 	else if (is_line_2024(node))
 		port->ext_portnum = int2ext_map_slb2024[chipnum][portnum];
+	/* sLB-4018: Only one asic per LB */
+	else if (is_4700_line)
+		port->ext_portnum = int2ext_map_slb4018[portnum];
+	/* sFB-4700X2 4X port */
+	else if (is_4700x2_spine)
+		port->ext_portnum = int2ext_map_sfb4700x2[chipnum][portnum];
 	else
 		port->ext_portnum = int2ext_map_slb8[chipnum][portnum];
 }
diff --git a/infiniband-diags/libibnetdisc/src/chassis.h b/infiniband-diags/libibnetdisc/src/chassis.h
index 2191046..f8e0ee2 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.h
+++ b/infiniband-diags/libibnetdisc/src/chassis.h
@@ -70,6 +70,9 @@
 #define VTR_DEVID_SFB2004		0x5a40
 #define VTR_DEVID_ISR2004		0x5a41
 #define VTR_DEVID_SRB2004		0x5a42
+#define VTR_DEVID_SLB4018		0x5a5b
+#define VTR_DEVID_SFB4700		0x5a5c
+#define VTR_DEVID_SFB4700X2		0x5a5d
 
 /* Vendor IDs (for chassis based systems) */
 #define VTR_VENDOR_ID			0x8f1	/* Voltaire */
@@ -78,7 +81,8 @@
 #define XS_VENDOR_ID			0x1397	/* Xsigo */
 
 enum ibnd_chassis_type {
-	UNRESOLVED_CT, ISR9288_CT, ISR9096_CT, ISR2012_CT, ISR2004_CT
+	UNRESOLVED_CT, ISR9288_CT, ISR9096_CT, ISR2012_CT, ISR2004_CT,
+	ISR4700_CT
 };
 enum ibnd_chassis_slot_type { UNRESOLVED_CS, LINE_CS, SPINE_CS, SRBD_CS };
